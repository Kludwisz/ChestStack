/*
This version of the checker runs the carver reversal on multiple CPU threads,
and delegates worldseed checks to the GPU. Because carver reversal will usually be 
the main bottleneck, this won't use the full potential of the GPU, but could be
enough for machines with powerful CPUs and weak GPUs.
*/

#include "chest_sim.cuh"
#include "carver_reversal.cuh"

#include <chrono>
#include <cstdio>
#include <vector>
#include <cstdlib>

#include <thread>
#include <mutex>

// --------------------------------------------------------------------
// global program params

constexpr uint64_t CARVER_SEED = 190383783165418ULL; //137099342588438ULL;
constexpr int MIN_CHESTS = 3;

constexpr int BATCH_SIZE = 100;
constexpr int CHUNKS_ON_AXIS = 60'000'000 / 16;
constexpr int TASKS_ON_AXIS = CHUNKS_ON_AXIS / BATCH_SIZE;
constexpr int TASK_COORD_OFFSET = TASKS_ON_AXIS / 2;
//constexpr uint64_t MAX_TASK_ID = (uint64_t)TASKS_ON_AXIS * TASKS_ON_AXIS;

// --------------------------------------------------------------------
// multithreaded carver reversal

typedef struct Result Result;
struct Result {
    uint64_t worldseed;
    int chunk_x;
    int chunk_z;
};

std::vector<Result> carver_step_results;
std::mutex result_mutex;

static bool trial_chamber_can_generate(int x, int z) {
    int x_in_region = (x%34 + 34) % 34;
    int z_in_region = (z%34 + 34) % 34;
    return x_in_region < 22 && z_in_region < 22;
}

static void reverse_carver(int x, int z, ReversalOutput& out) {
    reverseCarverSeed(CARVER_SEED, x, z, &out);
}

static void check_carver_result(Result res) {
    // check position
    int rx = (int)std::floor(res.chunk_x / 34.0);
    int rz = (int)std::floor(res.chunk_z / 34.0);

    uint64_t rand = 0;
    setRegionSeed(&rand, res.worldseed, rx, rz, 94251327);
    int cx = rx * 34 + nextInt(&rand, 22);
    int cz = rz * 34 + nextInt(&rand, 22);

    if (cx == res.chunk_x && cz == res.chunk_z)
    {
        std::lock_guard<std::mutex> lock(result_mutex);
        carver_step_results.push_back(res);
    }
}

static void carver_reversal_worker(int x_min, int x_max, int z) {
    ReversalOutput out = { 0 };

    for (int x = x_min; x < x_max; ++x) {
        out.resultCount = 0;
        if (!trial_chamber_can_generate(x, z))
            continue;

        reverse_carver(x, z, out);
        for (int i = 0; i < out.resultCount; i++)
            check_carver_result({out.results[i], x, z-1});
    }
}

// --------------------------------------------------------------------
// gpu worldseed bruteforce

constexpr int MAX_WORLDSEED_RESULTS = 64;
__managed__ int worldseedResultCount = 0;
__managed__ Result worldseedResults[MAX_WORLDSEED_RESULTS];

__global__ void bruteforceWorldseeds(const uint64_t structure_seed, const int x, const int z) {
    uint64_t upper16 = blockIdx.x * blockDim.x + threadIdx.x;
    uint64_t worldseed = structure_seed | (upper16 << 48);

    Xoroshiro xr;
    xSetDecoratorSeed(&xr, worldseed, x<<4, z<<4, 30001);
    int chests = countChests(&xr);
    if (chests >= MIN_CHESTS) {
        int ix = atomicAdd(&worldseedResultCount, 1);
        if (ix < MAX_WORLDSEED_RESULTS)
            worldseedResults[ix] = {worldseed, x, z};
    }
}

__host__ void launchBruteforce() {
    for (auto& result : carver_step_results) {
        bruteforceWorldseeds <<< 256, 256 >>> (result.worldseed, result.chunk_x, result.chunk_z);
    }
    carver_step_results.clear();
    CUDA_CHECK(cudaGetLastError());
}

__host__ void processResults() {
    for (int i = 0; i < worldseedResultCount; i++) {
        printf("%lld  /tp %d 0 %d\n", worldseedResults[i].worldseed, worldseedResults[i].chunk_x*16, worldseedResults[i].chunk_z*16 + 128);
    }
}

// --------------------------------------------------------------------

int parse_args(int argc, char* argv[], int& task_min, int& task_max, int& thread_count) {
    task_min = task_max = thread_count = -1;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--start") == 0 && i != argc-1)
            task_min = atoi(argv[i+1]);
        else if (strcmp(argv[i], "--end") == 0 && i != argc-1)
            task_max = atoi(argv[i+1]);
        else if (strcmp(argv[i], "--threads") == 0 && i != argc-1)
            thread_count = atoi(argv[i+1]);
    }

    if (task_min == -1 || task_max == -1 || thread_count == -1) {
        fprintf(stderr, "Usage: (executable) --start [TASK_ID] --end [TASK_ID] --threads [NUM_THREADS]\n");
        return 1;
    }

    return 0;
}

int main(int argc, char* argv[]) {
    int task_min, task_max, thread_count;
    if (parse_args(argc, argv, task_min, task_max, thread_count)) {
        fprintf(stderr, "Launch failed.\n");
        return 1;
    }

    int current_task = task_min;
    int current_task_z = 0;
    int subtasks_total = (task_max - task_min) * BATCH_SIZE;
    int ix = 0;

    while (current_task < task_max) {
        std::vector<std::thread> threads;

        int subtasks_done = (current_task - task_min) * BATCH_SIZE + current_task_z;
        fprintf(stderr, "--- progress: %d / %d subtasks done\n", subtasks_done, subtasks_total);

        for (int i = 0; i < thread_count; i++) {
            const int tx = (current_task / TASKS_ON_AXIS) * BATCH_SIZE - TASK_COORD_OFFSET * BATCH_SIZE;
            const int tz = (current_task % TASKS_ON_AXIS) * BATCH_SIZE - TASK_COORD_OFFSET * BATCH_SIZE;
            if (trial_chamber_can_generate(0, current_task_z))
                threads.emplace_back(carver_reversal_worker, tx, tx + BATCH_SIZE, tz + current_task_z);
            else i--; // need to run the loop an additional time

            current_task_z++;
            if (current_task_z >= BATCH_SIZE) {
                current_task_z = 0;
                current_task++;
                if (current_task >= task_max)
                    break;
            }
        }
        for (auto& t : threads) {
            t.join();
        }

        if ((ix++ & 3) == 0) {
            CUDA_CHECK(cudaDeviceSynchronize());
            processResults();
            worldseedResultCount = 0;
        }

        launchBruteforce();
    }

    CUDA_CHECK(cudaDeviceSynchronize());
    processResults();
    CUDA_CHECK(cudaDeviceReset());

    return 0;
}
