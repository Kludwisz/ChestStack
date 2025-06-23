#include "rng.h"

int countChests(Xoroshiro* xrand)
{
    int counter = 0;

    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 62);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 15);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 49);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 2);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 23);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 68);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);}
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 68);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 48);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 52);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 18);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 18);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 18);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 15);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 2);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
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
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    #pragma unroll
    for (int i = 0; i < 6; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 45);
    #pragma unroll
    for (int i = 0; i < 4; i++) xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
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
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 7; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 60);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 41);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 19);
    xNextIntJ(xrand, 100);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!
    #pragma unroll
    for (int i = 0; i < 3; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 30);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 6);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 2; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 64);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 8);
    #pragma unroll
    for (int i = 0; i < 2; i++) if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) xSkipN(xrand, 3);
    #pragma unroll
    for (int i = 0; i < 5; i++) xNextIntJ(xrand, 100);
    xSkipN(xrand, 45);
    if (xNextIntJ(xrand, 4) != 0) xSkipN(xrand, 2);
    xSkipN(xrand, 4);
    if (xNextIntJ(xrand, 100) == 0) {counter++; xSkipN(xrand, 3);} // COLUMN CHEST!

    return counter;
}
