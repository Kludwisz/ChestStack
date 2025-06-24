#include <vector>
#include <cstdlib>
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

// --------------------------------------------------------------------
// multithreaded carver reversal + worldseed checking

typedef struct Result Result;
struct Result {
    uint64_t worldseed;
    int chunk_x;
    int chunk_z;
};

std::mutex result_mutex;

void reverse_carver(int x, int z, ReversalOutput& out) {
    reverseCarverSeed(CARVER_SEED, x, z, &out);
}

void check_worldseeds(uint64_t structure_seed, int x, int z) {
    for (uint64_t u = 0; u < 65536U; u++) {
        uint64_t worldseed = structure_seed | (u << 48);

        Xoroshiro xr;
        xSetDecoratorSeed(&xr, worldseed, x<<4, (z-1)<<4, 30001);
        int c = countChests(&xr);

        if (c >= MIN_CHESTS) {
            std::lock_guard<std::mutex> lock(result_mutex);
            std::cout << worldseed << ' ' << c << ' ' << x << ' ' << z << '\n';
            std::cout << std::flush;
        }
    }
}

void carver_reversal_worker(int x_min, int x_max, int z_min, int z_max) {
    ReversalOutput out = { 0 };

    for (int x = x_min; x < x_max; ++x) {
        for (int z = z_min; z < z_max; ++z) {
            out.resultCount = 0;
            reverse_carver(x, z, out);
            for (int i = 0; i < out.resultCount; i++)
                check_worldseeds(out.results[i] & 0xFFFFFFFFFFFFULL, x, z);
        }
    }
}

// --------------------------------------------------------------------

int parse_args(int argc, char* argv[], int& x_min, int& x_max, int& z_min, int& z_max, int& thread_count) {
    if (argc != 6) {
        std::cerr << "Usage: [executable] x_min z_min x_max z_max thread_count\n";
        return 1;
    }

    x_min = std::atoi(argv[1]);
    z_min = std::atoi(argv[2]);
    x_max = std::atoi(argv[3]);
    z_max = std::atoi(argv[4]);
    thread_count = std::atoi(argv[5]);

    if (x_max <= x_min || z_max <= z_min || thread_count <= 0) {
        std::cerr << "Invalid input values.\n";
        return 1;
    }

    return 0;
}

int main(int argc, char* argv[]) {
    int x_min, x_max, z_min, z_max, thread_count;
    if (parse_args(argc, argv, x_min, x_max, z_min, z_max, thread_count)) {
        std::cerr << "launch failed.\n";
        return 1;
    }

    int total_rows = z_max - z_min;
    int rows_per_thread = total_rows / thread_count;
    int remaining_rows = total_rows % thread_count;

    std::vector<std::thread> threads;

    int current_z = z_min;
    for (int i = 0; i < thread_count; ++i) {
        int start_z = current_z;
        int end_z = start_z + rows_per_thread + (i < remaining_rows ? 1 : 0);
        threads.emplace_back(carver_reversal_worker, x_min, x_max, start_z, end_z);
        current_z = end_z;
    }

    for (auto& t : threads) {
        t.join();
    }

    return 0;
}
