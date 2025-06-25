# ChestStack
Finding tall stacks of chest minecarts.

## Task layout
We have the total chunk area:<br>
x:  -1875000 -- 1875000<br>
z:  -1875000 -- 1875000

Divided into batches of 100x100 chunks:<br>
bx: -18750 -- 18750<br>
bz: -18750 -- 18750

By encoding these coordinates as `(bx+18750)*37500 + (bz+18750)`,
we get the following range of possible task IDs: `[0, 1406287500]`


## CPU-only app
Compile using
```
g++ carver_reversal.cpp chest_sim.cpp cpu_checker.cpp -O3 -o cpu_checker
```
then run with:
```
./cpu_checker --start [task_id] --end [task_id] --threads [num_threads]
```
where `--start` defines the inclusive start of the task id range, and `--end` defines the exclusive end.

## CPU-GPU app
Compile using
```
nvcc hybrid_checker.cu -O3 -o gpu_checker 
```
then run with:
```
./gpu_checker --start [task_id] --end [task_id] --threads [num_threads]
```
where `--start` defines the inclusive start of the task id range, and `--end` defines the exclusive end.