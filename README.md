# ChestStack
Finding tall stacks of chest minecarts.

## CPU-only app
Compile using
```
g++ carver_reversal.cpp chest_sim.cpp cpu_checker.cpp -O3 -o cpu_checker
```
then run with:
```
./cpu_checker [x_min] [z_min] [x_max] [z_max] [threads]
```
`x_min`, `x_max`, `z_min`, `z_max` define the area of chunks to be checked.
`threads` is the number of threads to be used.

## CPU-GPU app
Coming soon