#include "chest_sim.cuh"

int main() {

    uint64_t seed = 2800335605771220234ULL;
    int x = (-29998800) >> 4;
    int z = (-29935712) >> 4;

    Xoroshiro xrand;
    xSetDecoratorSeed(&xrand, seed, x << 4, z << 4, 30001);
    uint64_t target = -1402333309034400285LL;

    // for (int i = 0; i < 10000; i++) {
    //     if (xrand.lo == target) {
    //         printf("got after %d skips\n", i);
    //     }
    //     xNextLong(&xrand);
    // }
    countChests(&xrand);

    return 0;
}