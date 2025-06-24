#ifndef CARVER_REVERSAL_H
#define CARVER_REVERSAL_H

#include "rng.h"

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

void reverseCarverSeed(uint64_t carver_seed, int x, int z, ReversalOutput* out);

#endif