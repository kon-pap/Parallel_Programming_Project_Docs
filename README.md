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
trail and error. Finally we used `#pragma omp simd reduction(+:dist)` to vectorize the `for` loop in the 
function `distance_squared(Point&, Point&)` to gain a better speedup.