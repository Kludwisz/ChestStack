#include "chest_sim.h"

//#define CHEST_SKIP if (xNextIntJ(xrand, 100) == 0) {xSkipN(xrand, 3); printf("%d: chest skipped\n", __LINE__);}
//#define CHEST_OP {counter++; xSkipN(xrand, 1); printf("%d: lootseed=%lld\n", __LINE__, xNextLongJ(xrand));}
#define CHEST_SKIP {if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);}
#define CHEST_OP {counter++; xSkipN(xrand, 3);}

__host__ __device__ int countChests(Xoroshiro* xrand)
{
    int counter = 0;

    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 62);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 3);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 15);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 49);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 2);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 23);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 68);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 68);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 48);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 4);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 52);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 18);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 18);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 18);
    CHEST_SKIP
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 4);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 15);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 2);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 135);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 45);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 2);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 141);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xNextIntJ(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    xNextIntJ(xrand, 100);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 64);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 7; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 41);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 19);
    xNextIntJ(xrand, 100);
    CHEST_SKIP
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 64);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) CHEST_SKIP
    xSkipN(xrand, 4);
    CHEST_SKIP
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) CHEST_OP // COLUMN CHEST!

    return counter;
}

/*
// Code testing
int main2()
{
    //CHEST !!! Pos{x=-450, y=-19, z=-189}
    uint64_t seed = 576920672342937203LL;
    int x = -29;
    int z = -12;

    Xoroshiro xr;
    xSetDecoratorSeed(&xr, seed, x<<4, z<<4, 30001);
    countChests(&xr);
}

void main3()
{
    uint64_t structseed = 68314073758543ULL;
    int x = 19;
    int z = 8;

    for (uint64_t u = 0; u < 65536U; u++) {
        uint64_t worldseed = structseed | (u << 48);
        Xoroshiro xr;
        xSetDecoratorSeed(&xr, worldseed, x<<4, z<<4, 30001);
        int c = countChests(&xr);
        if (c >= 2) {
            printf("%lld\n", worldseed);
        }
    }
}
*/