#include <vector>
#include <cstdlib>
#include <cmath>
#include <cstring>
#include <iostream>
#include <functional>

#include <thread>
#include <mutex>

#include "carver_reversal.h"
#include "chest_sim.h"

// --------------------------------------------------------------------
// global program params

constexpr uint64_t CARVER_SEED = 137099342588438ULL;
constexpr int MIN_CHESTS = 4;

constexpr int BATCH_SIZE = 100;
constexpr int CHUNKS_ON_AXIS = 60'000'000 / 16;
constexpr int TASKS_ON_AXIS = CHUNKS_ON_AXIS / BATCH_SIZE;
constexpr int TASK_COORD_OFFSET = TASKS_ON_AXIS / 2;
constexpr uint64_t MAX_TASK_ID = (uint64_t)TASKS_ON_AXIS * TASKS_ON_AXIS + TASKS_ON_AXIS;

// --------------------------------------------------------------------
// multithreaded carver reversal + worldseed checking

typedef struct Result Result;
struct Result {
    uint64_t worldseed;
    int chunk_x;
    int chunk_z;
};

std::vector<Result> carver_step_results;
std::mutex result_mutex;

static void reverse_carver(int x, int z, ReversalOutput& out) {
    reverseCarverSeed(CARVER_SEED, x, z, &out);
}

static void check_carver_result(Result res) {
    // test for trial chambers generating in correct position
    // -3 30 (feature) -> -1 31 (chunk) rotation = 3
    // rotation = 1 BAD
    // rotation = 2 BAD
    // rotation = 0 BAD

    // so we need trial chambers at feature_chunk + (2, 1) with rotation = 3

    // check position
    int tcx = res.chunk_x + 2;
    int tcz = res.chunk_z + 1;
    int rx = (int)std::floor(tcx / 34.0);
    int rz = (int)std::floor(tcz / 34.0);

    uint64_t rand = 0;
    setRegionSeed(&rand, res.worldseed, rx, rz, 94251327);
    int cx = rx * 34 + nextInt(&rand, 22);
    int cz = rz * 34 + nextInt(&rand, 22);

    if (cx != tcx || cz != tcz)
        return;

    // check rotation
    setCarverSeed(&rand, res.worldseed, cx, cz);
    nextInt(&rand, 21); // skip y
    int rot = nextInt(&rand, 4);
    if (rot != 3) 
        return;

    {
        std::lock_guard<std::mutex> lock(result_mutex);
        carver_step_results.push_back(res);
    }
}

static void carver_reversal_worker(int x_min, int x_max, int z) {
    ReversalOutput out = { 0 };

    for (int x = x_min; x < x_max; ++x) {
        out.resultCount = 0;
        reverse_carver(x, z, out);
        for (int i = 0; i < out.resultCount; i++)
            check_carver_result({out.results[i], x, z-1});
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

// --------------------------------------------------------------------

static void result_process_worker(uint64_t uMin, uint64_t uMax) {
    for (const auto& res : carver_step_results) {
        for (uint64_t u = uMin; u < uMax; u++) {
            uint64_t worldseed = res.worldseed & ((1ULL << 48) - 1);
            worldseed |= u << 48;

            Xoroshiro xr;
            xSetDecoratorSeed(&xr, worldseed, res.chunk_x<<4, res.chunk_z<<4, 30001);
            int chests = countChests(&xr);
            if (chests >= MIN_CHESTS) {
                std::lock_guard<std::mutex> lock(result_mutex);
                printf("%lld  /tp %d 0 %d\n", worldseed, res.chunk_x*16, res.chunk_z*16 + 128);
            }
        }
    }
}

static void processResults(const int thread_count) {
    if (carver_step_results.empty())
        return;
    std::vector<std::thread> threads;

    const int wu_size = 65536 / thread_count;
    const int remainder = 65536 - thread_count * wu_size;
    int current_min = 0;
    for (int i = 0; i < thread_count; i++) {
        const int uMin = current_min;
        const int uMax = uMin + wu_size + (i < remainder ? 1 : 0);
        current_min = uMax;
        threads.emplace_back(result_process_worker, uMin, uMax);
    }

    for (auto& t : threads) {
        t.join();
    }
    carver_step_results.clear();
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
        fprintf(stderr, "--- progress: %d / %d | carver reversal\n", subtasks_done, subtasks_total);

        for (int i = 0; i < thread_count; i++) {
            const int tx = (current_task / TASKS_ON_AXIS) * BATCH_SIZE - TASK_COORD_OFFSET * BATCH_SIZE;
            const int tz = (current_task % TASKS_ON_AXIS) * BATCH_SIZE - TASK_COORD_OFFSET * BATCH_SIZE;
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
        
        fprintf(stderr, "--- progress: %d / %d | sister seed bruteforce\n", subtasks_done, subtasks_total);
        processResults(thread_count);
    }

    return 0;
}