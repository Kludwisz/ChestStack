#ifndef CARVER_REVERSAL_CUH
#define CARVER_REVERSAL_CUH

#include <intrin.h>
#include "rng.cuh"

typedef struct ReversalParams ReversalParams;
struct ReversalParams {
    uint64_t carver_seed;
    int x;
    int z;
};

typedef struct ReversalOutput ReversalOutput;
struct ReversalOutput {
    uint64_t results[32];
    int resultCount;
};

__host__ __device__ inline void lift(uint64_t value, int bit, const ReversalParams* params, ReversalOutput* out) {
    const uint64_t target_carver = params->carver_seed;
    const uint64_t partial_carver = getCarverSeed(value, params->x, params->z);

    if (bit >= 32) {
        const uint64_t mask = (1ULL << (bit + 16)) - 1;
        if ((target_carver & mask) == (partial_carver & mask)) {
            out->results[(out->resultCount)++] = value;
        }
    }
    else {
        const uint64_t mask = (1ULL << bit) - 1;
        if ((target_carver & mask) == (partial_carver & mask)) {
            lift(value, bit+1, params, out);
            lift(value | (65536ULL << bit), bit+1, params, out);
        }
    }
}

__device__ void inline reverseCarverSeedGPU(uint64_t carver_seed, int x, int z, ReversalOutput* out) {
    const ReversalParams params = {carver_seed, x, z};

    int freeBits = __ffs(x | z) - 1;
    uint64_t c = carver_seed & ((1ULL << freeBits) - 1);

    if (freeBits >= 16) {
        lift(c, freeBits - 16, &params, out);
    } 
    else {
        for (int increment = 1 << freeBits; c < 65536ULL; c += increment) {
            lift(c, 0, &params, out);
        }
    }
}

__host__ void inline reverseCarverSeedCPU(uint64_t carver_seed, int x, int z, ReversalOutput* out) {
    const ReversalParams params = {carver_seed, x, z};

    unsigned long freeBits = 32; 
    if ((x|z) != 0) {
        _BitScanForward(&freeBits, x|z);
        freeBits--;
    }
    uint64_t c = carver_seed & ((1ULL << freeBits) - 1);

    if (freeBits >= 16) {
        lift(c, freeBits - 16, &params, out);
    } 
    else {
        for (int increment = 1 << freeBits; c < 65536ULL; c += increment) {
            lift(c, 0, &params, out);
        }
    }
}

#endif