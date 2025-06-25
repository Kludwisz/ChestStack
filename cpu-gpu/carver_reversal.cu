#include "carver_reversal.cuh"


__host__ __device__ void lift(uint64_t value, int bit, const ReversalParams* params, ReversalOutput* out) {
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

__host__ __device__ void reverseCarverSeed(uint64_t carver_seed, int x, int z, ReversalOutput* out) {
    const ReversalParams params = {carver_seed, x, z};

    int freeBits = __builtin_ctz(x | z);
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

/*
extern int countChests(Xoroshiro*);

void process_result(uint64_t structure_seed, int x, int z) {
    for (uint64_t u = 0; u < 65536U; u++) {
        uint64_t worldseed = structure_seed | (u << 48);
        Xoroshiro xr;
        xSetDecoratorSeed(&xr, worldseed, x<<4, (z-1)<<4, 30001);
        int c = countChests(&xr);
        if (c >= 4) {
            printf("%lld : %d   /tp %d 0 %d\n", worldseed, c, x*16 + 7, z*16 - 15 + 128);
        }
    }
}

int main() {
    //auto t0 = std::chrono::steady_clock::now();

    ReversalOutput out = { 0 };

    for (int x = 10; x < 30; x++) {
        printf("### x = %d\n", x);
        for (int z = 10; z < 30; z++) {
            out.resultCount = 0;
            reverseCarverSeed(137099342588438ULL, x, z, &out);
            for (int i = 0; i < out.resultCount; i++)
                process_result(out.results[i], x, z);
        }
    }

    //auto t1 = std::chrono::steady_clock::now();
    //double sec = (t1 - t0).count() * 1e-9;
    //printf("%f seconds\n", sec);
}
*/