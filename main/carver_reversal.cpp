/*
public static List<Long> reverse(long carverSeed, int x, int z, ChunkRand rand, MCVersion version) {
    ArrayList<Long> result = new ArrayList<>();
    LongUnaryOperator carverHash = value -> rand.setCarverSeed(value, x, z, version);

    int freeBits = Long.numberOfTrailingZeros(x | z);
    long c = Mth.mask(carverSeed, freeBits);

    if(freeBits >= 16) {
        Hensel.lift(c, freeBits - 16, carverSeed, 32, 16, carverHash, result);
    } else {
        for(int increment = (int)Mth.getPow2(freeBits); c < 1L << 16; c += increment) {
            Hensel.lift(c, 0, carverSeed, 32, 16, carverHash, result);
        }
    }

    return result;
}

public static <T extends Collection<Long>> T lift(long value, int bit, long target, int bits, int offset, LongUnaryOperator hash, T result) {
    if(bit >= bits) {
        if(Mth.mask(target, bit + offset) == Mth.mask(hash.applyAsLong(value), bit + offset)) {
            result.add(value);
        }
    } else if(Mth.mask(target, bit) == Mth.mask(hash.applyAsLong(value), bit)) {
        lift(value, bit + 1, target, bits, offset, hash, result);
        lift(value | Mth.getPow2(bit + offset), bit + 1, target, bits, offset, hash, result);
    }

    return result;
}
*/

#include <chrono>
#include <stdio.h>
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

void lift(uint64_t value, int bit, const ReversalParams* params, ReversalOutput* out) {
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

void reverseCarverSeed(uint64_t carver_seed, int x, int z, ReversalOutput* out) {
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

int main() {
    uint64_t a = 3;
    int c = 6325;
    int x = 12;
    int z = 13;

    auto t0 = std::chrono::steady_clock::now();

    for (uint64_t a = 1; a < 100; a++) {
        ReversalOutput out = { 0 };
        reverseCarverSeed(a, x, z, &out);

        for (int i = 0; i < out.resultCount; i++) {
            printf("%lld\n", out.results[i]);
        }
    }

    auto t1 = std::chrono::steady_clock::now();
    double sec = (t1 - t0).count() * 1e-9;
    printf("%f seconds\n", sec);
}