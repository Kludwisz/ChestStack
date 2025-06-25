#ifndef RNG_CUH_
#define RNG_CUH_

#define __STDC_FORMAT_MACROS 1

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <cstdlib>
#include <cstddef>
#include <cstdio>
#include <cinttypes>

///=============================================================================
///                              CUDA helpers
///=============================================================================

__host__ static void gpuAssert(cudaError_t err, const char *file, int line) {
    if (err != cudaSuccess) {
        std::fprintf(stderr, "CUDA error %s:%d — %s\n", file, line, cudaGetErrorString(err));
        std::exit(EXIT_FAILURE);
    }
}
#define CUDA_CHECK(ans) gpuAssert((ans), __FILE__, __LINE__)

///=============================================================================
///                    C implementation of Java Random
///=============================================================================

__host__ __device__ static inline void setSeed(uint64_t *seed, uint64_t value)
{
    *seed = (value ^ 0x5deece66d) & ((1ULL << 48) - 1);
}

__host__ __device__ static inline int next(uint64_t *seed, const int bits)
{
    *seed = (*seed * 0x5deece66d + 0xb) & ((1ULL << 48) - 1);
    return (int) ((int64_t)*seed >> (48 - bits));
}

__host__ __device__ static inline int nextInt(uint64_t *seed, const int n)
{
    int bits, val;
    const int m = n - 1;

    if ((m & n) == 0) {
        uint64_t x = n * (uint64_t)next(seed, 31);
        return (int) ((int64_t) x >> 31);
    }

    do {
        bits = next(seed, 31);
        val = bits % n;
    }
    while ((int32_t)((uint32_t)bits - val + m) < 0);
    return val;
}

__host__ __device__ static inline uint64_t nextLong(uint64_t *seed)
{
    return ((uint64_t) next(seed, 32) << 32) + next(seed, 32);
}

__host__ __device__ static inline float nextFloat(uint64_t *seed)
{
    return next(seed, 24) / (float) (1 << 24);
}

__host__ __device__ static inline double nextDouble(uint64_t *seed)
{
    uint64_t x = (uint64_t)next(seed, 26);
    x <<= 27;
    x += next(seed, 27);
    return (int64_t) x / (double) (1ULL << 53);
}

/* Jumps forwards in the random number sequence by simulating 'n' calls to next.
 */
__host__ __device__ static inline void skipNextN(uint64_t *seed, uint64_t n)
{
    uint64_t m = 1;
    uint64_t a = 0;
    uint64_t im = 0x5deece66dULL;
    uint64_t ia = 0xb;
    uint64_t k;

    for (k = n; k; k >>= 1)
    {
        if (k & 1)
        {
            m *= im;
            a = im * a + ia;
        }
        ia = (im + 1) * ia;
        im *= im;
    }

    *seed = *seed * m + a;
    *seed &= 0xffffffffffffULL;
}

__host__ __device__ static inline void setCarverSeed(uint64_t *rand, uint64_t structure_seed, int x, int z)
{
    setSeed(rand, structure_seed);
    uint64_t a = nextLong(rand);
    uint64_t b = nextLong(rand);
    uint64_t carver = a*x ^ b*z ^ structure_seed;
    setSeed(rand, carver); 
}

__host__ __device__ static inline uint64_t getCarverSeed(uint64_t structure_seed, int x, int z)
{
    uint64_t rand = structure_seed ^ 0x5deece66dULL;
    uint64_t a = nextLong(&rand);
    uint64_t b = nextLong(&rand);
    return a*x ^ b*z ^ structure_seed; 
}

__host__ __device__ static inline void setRegionSeed(uint64_t* rand, uint64_t structure_seed, int rx, int rz, int salt)
{
    constexpr uint64_t REGION_SEED_A = 341873128712ULL;
    constexpr uint64_t REGION_SEED_B = 132897987541ULL; 
    setSeed(rand, rx * REGION_SEED_A + rz * REGION_SEED_B + structure_seed + salt);
}



///=============================================================================
///                               Xoroshiro 128
///=============================================================================

typedef struct Xoroshiro Xoroshiro;
struct Xoroshiro {
    uint64_t lo, hi;
};

__host__ __device__ static inline void xSetSeed(Xoroshiro *xr, uint64_t value)
{
    constexpr uint64_t XL = 0x9e3779b97f4a7c15ULL;
    constexpr uint64_t XH = 0x6a09e667f3bcc909ULL;
    constexpr uint64_t A = 0xbf58476d1ce4e5b9ULL;
    constexpr uint64_t B = 0x94d049bb133111ebULL;
    uint64_t l = value ^ XH;
    uint64_t h = l + XL;
    l = (l ^ (l >> 30)) * A;
    h = (h ^ (h >> 30)) * A;
    l = (l ^ (l >> 27)) * B;
    h = (h ^ (h >> 27)) * B;
    l = l ^ (l >> 31);
    h = h ^ (h >> 31);
    xr->lo = l;
    xr->hi = h;
}

__host__ __device__ static inline uint64_t rotl64(uint64_t x, uint8_t b)
{
    return (x << b) | (x >> (64-b));
}

__host__ __device__ static inline uint64_t xNextLong(Xoroshiro *xr)
{
    uint64_t l = xr->lo;
    uint64_t h = xr->hi;
    uint64_t n = rotl64(l + h, 17) + l;
    h ^= l;
    xr->lo = rotl64(l, 49) ^ h ^ (h << 21);
    xr->hi = rotl64(h, 28);
    return n;
}

__host__ __device__ static inline int xNextInt(Xoroshiro *xr, uint32_t n)
{
    uint64_t r = (xNextLong(xr) & 0xFFFFFFFF) * n;
    if ((uint32_t)r < n)
    {
        while ((uint32_t)r < (~n + 1) % n)
        {
            r = (xNextLong(xr) & 0xFFFFFFFF) * n;
        }
    }
    return r >> 32;
}

__host__ __device__ static inline double xNextDouble(Xoroshiro *xr)
{
    return (xNextLong(xr) >> (64-53)) * 1.1102230246251565E-16;
}

__host__ __device__ static inline float xNextFloat(Xoroshiro *xr)
{
    return (xNextLong(xr) >> (64-24)) * 5.9604645E-8F;
}

__host__ __device__ static inline void xSkipN(Xoroshiro *xr, int count)
{
    while (count --> 0)
        xNextLong(xr);
}

__host__ __device__ static inline uint64_t xNextLongJ(Xoroshiro *xr)
{
    int32_t a = xNextLong(xr) >> 32;
    int32_t b = xNextLong(xr) >> 32;
    return ((uint64_t)a << 32) + b;
}

__host__ __device__ static inline int xNextIntJ(Xoroshiro *xr, uint32_t n)
{
    int bits, val;
    const int m = n - 1;

    if ((m & n) == 0) {
        uint64_t x = n * (xNextLong(xr) >> 33);
        return (int) ((int64_t) x >> 31);
    }

    do {
        bits = (xNextLong(xr) >> 33);
        val = bits % n;
    }
    while ((int32_t)((uint32_t)bits - val + m) < 0);
    return val;
}

__host__ __device__ static inline void xSetDecoratorSeed(Xoroshiro* xr, uint64_t world_seed, int x, int z, int salt)
{
    xSetSeed(xr, world_seed);
    uint64_t a = xNextLongJ(xr) | 1ULL;
    uint64_t b = xNextLongJ(xr) | 1ULL;
    uint64_t popseed = (a*x + b*z) ^ world_seed;
    xSetSeed(xr, popseed + salt);
}

#endif /* RNG_CUH_ */