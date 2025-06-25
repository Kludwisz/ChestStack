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

constexpr uint64_t CARVER_SEED = 137099342588438ULL;
constexpr int MIN_CHESTS = 4;

constexpr int BATCH_SIZE = 100;
constexpr int CHUNKS_ON_AXIS = 60'000'000 / 16;
constexpr int TASKS_ON_AXIS = CHUNKS_ON_AXIS / BATCH_SIZE;
constexpr uint64_t MAX_TASK_ID = (uint64_t)TASKS_ON_AXIS * TASKS_ON_AXIS;

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

void reverse_carver(int x, int z, ReversalOutput& out) {
    reverseCarverSeedCPU(CARVER_SEED, x, z, &out);
}

void carver_reversal_worker(int x_min, int x_max, int z) {
    ReversalOutput out = { 0 };

    for (int x = x_min; x < x_max; ++x) {
        out.resultCount = 0;
        reverse_carver(x, z, out);
        {
            std::lock_guard<std::mutex> lock(result_mutex);
            for (int i = 0; i < out.resultCount; i++)
                carver_step_results.push_back({out.results[i], x, z});
        } 
    }
}

// --------------------------------------------------------------------
// gpu worldseed bruteforce

constexpr int MAX_WORLDSEED_RESULTS = 64;
__managed__ int worldseedResultCount = 0;
__managed__ Result worldseedResults[MAX_WORLDSEED_RESULTS];

extern __device__ int countChests(Xoroshiro*);
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
    worldseedResultCount = 0;
    for (auto& result : carver_step_results) {
        bruteforceWorldseeds <<< 256, 256 >>> (result.worldseed, result.chunk_x, result.chunk_z);
    }
    carver_step_results.clear();
    CUDA_CHECK(cudaGetLastError());
}

__host__ void processResults() {
    for (int i = 0; i < worldseedResultCount; i++) {
        printf("%lld %d %d\n", worldseedResults[i].worldseed, worldseedResults[i].chunk_x, worldseedResults[i].chunk_z);
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

    while (current_task < task_max) {
        std::vector<std::thread> threads;

        int subtasks_done = (current_task - task_min) * BATCH_SIZE + current_task_z;
        fprintf(stderr, "--- progress: %d / %d subtasks done\n", subtasks_done, subtasks_total);

        for (int i = 0; i < thread_count; i++) {
            const int tx = (current_task / TASKS_ON_AXIS) * BATCH_SIZE;
            const int tz = (current_task % TASKS_ON_AXIS) * BATCH_SIZE;
            threads.emplace_back(carver_reversal_worker, tx, tx + BATCH_SIZE, tz + current_task_z);
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

        auto t0 = std::chrono::steady_clock::now();
        CUDA_CHECK(cudaDeviceSynchronize());
        auto t1 = std::chrono::steady_clock::now();
        double msWaited = (t1 - t0).count() * 1e-6;
        fprintf(stderr, "--- waited %f ms for GPU\n", msWaited);

        processResults();
        launchBruteforce();
    }

    CUDA_CHECK(cudaDeviceSynchronize());
    processResults();
    CUDA_CHECK(cudaDeviceReset());

    return 0;
}
