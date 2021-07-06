# Group-302

This is your teams documentation repository. 
You can find informational material here. 
This is also the place where you should keep your project documentation (such as the slides for the presentation).

You should have access to separate repositories to store code for each of the tasks on your project descriptions (OpenMP, MPI, Hybrid, Bonus).

### Team Members

Member 1: Daniel Baur <ga48cid@mytum.de>

Member 2: Konstantinos Papaioannou <k.papaioannou@tum.de>

Member 3: Srivatsa Ravindra <ge37geb@mytum.de>

# KDTree and Nearest Neighbour Search
Nearest neighbour search can be performed efficiently in O(log n) using KD Trees.
We were given the sequential implementation of the code and our task was to parallelize the code using OpenMP, MPI and Hybrid approach.

### OpenMP
The given sequential code computes nearest neighbours of 10 query points. 
Our idea was to parallelize this part where we create multiple threads and each thread will compute the nearest neighbour of one single query point.
The results had to be `ordered` to allow the submission server to check for the correctness of our solution.Another opportunity for parallelization was in the function `build_tree_rec(Point**, int, int)`. This function builds
the tree. The left and the right sub tree are built by the same thread which is not ideal. Since the 
left and the right subtree could be built independently of each other we have utilizated
the concept of 'tasks' in OpenMP. Whenever an executing thread encounters the directive
`#pragma omp task`, a new task is created which could be executed by different threads.
To ensure that overhead due to task creation does not impact the performance we limit
the creation of tasks when the depth of the tree reaches 8. `#pragma omp task if(depth < 8)`
ensures that no new tasks are created when the depth is more than 8. The number 8 was decided by 
trial and error. Finally we used `#pragma omp simd reduction(+:dist)` to vectorize the `for` loop in the 
function `distance_squared(Point&, Point&)` to gain a better speedup.


### MPI
Our approach involves having one process work as a `main` process and rest of the 
15 processes will be `worker` processes. `main` process is responsible for allocating work to each worker process
and then printing the result. `main` process will first read the input `seed`, `dim` and `num_points`. These are then broadcasted to each of the worker process.
Using the `num_points` and `size` the amount of work each `worker` can do is decided as the `chunk_size`.
The main process then calculates the `start` and `end` pointer that defines the portion of data each `worker` can work on.
Each worker receives these `start` and `end` pointers from the `main` process and then 
builds a subtree of `points`. Each worker will find a local nearest neighbor for each query.
`MPI_Reduce` is then used to find the nearnest neigbor with minimum distance across all workers for each query.


### Hybrid
Our approach focuses on combining the two previous approaches in an efficient way. Thus, after splitting the problem in smaller pieces like in the MPI approach we make sure that each MPI process uses a shared memory model (in our case OMP). That means that each MPI process creates the tree corresponding to its chunk using `#pragma omp task` and then tries to solve the problem for all the queries in parallel using `#pragma omp parallel for`. Finally, we keep on using `#pragma omp simd` to compute the loop inside distance_squared function and we finally reduce all the results coming from all the MPI processes

### Bonus
Our bonus approach uses the same approach used in the hybrid implementation. The only difference between them is the way we vectorize the for loop inside distance_squared function. In this case, we use C intrinsic functions instead of OMP SIMD. Worth mentioning is the fact that we don't use a remainder loop because the size of each point is 128, which is perfectly divided with 8. This slightly different vectorization approach seems to give us better results regarding the final speedup.