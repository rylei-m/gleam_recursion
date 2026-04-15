# USU2026_# Assignment Gleam

## Overview

The assignment requires implementing four functions in `code.gleam`:

- `counting_numbers(n: Int) -> List(Int)`
- `prime_numbers(n: Int) -> List(Int)`
- `lists_of_numbers(n: Int, f: fn(Int) -> List(Int)) -> List(List(Int))`
- `can_reach(from: Int, to: Int, graph: List(List(Int))) -> Result(List(List(Int)), BacktrackState)`

It also defines the following backtracking state type:

    pub type BacktrackState {
      Failed
      Backtrack
    }

## Problems Implemented

### Counting Numbers

Returns the counting numbers from `1` to `n`.

Example behavior:

- `counting_numbers(5)` returns `[1, 2, 3, 4, 5]`
- `counting_numbers(-1)` returns `[]`
- `counting_numbers(1)` returns `[1]`

### Prime Numbers

Returns all prime numbers from `2` to `n` using the Sieve of Eratosthenes.

Example behavior:

- `prime_numbers(5)` returns `[2, 3, 5]`
- `prime_numbers(1)` returns `[]`
- `prime_numbers(15)` returns `[2, 3, 5, 7, 11, 13]`

### Lists of Numbers

Returns a list of lists where each inner list is produced by applying a function to each value from `1` through `n`.

Example behavior:

- `lists_of_numbers(3, counting_numbers)` returns `[[1], [1, 2], [1, 2, 3]]`
- `lists_of_numbers(5, prime_numbers)` returns `[[], [2], [2, 3], [2, 3], [2, 3, 5]]`

### Reachability

Determines whether a node `to` can be reached from a node `from` in a directed graph represented as a list of edges.

Each edge is written as `[x, y]`, meaning there is a directed edge from `x` to `y`.

Example graph:

- `[[4, 2], [2, 3], [1, 3], [3, 4]]`

If a path exists, the program returns the ordered list of edges that connect the start node to the destination node.
If no path exists, it returns `Error(Failed)`.

Example behavior:

- `can_reach(1, 2, [[4, 2], [2, 3], [1, 3], [3, 4]])`
  returns `Ok([[1, 3], [3, 4], [4, 2]])`

- `can_reach(1, 2, [[4, 2], [2, 3], [5, 3], [3, 4]])`
  returns `Error(Failed)`

## Sample Output

Running the provided tests in `main` produces output like:

- `[1, 2, 3, 4, 5, 6]`
- `[2, 3, 5, 7]`
- `[[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [1, 2, 3, 4, 5], [1, 2, 3, 4, 5, 6]]`
- `[[], [2], [2, 3], [2, 3], [2, 3, 5], [2, 3, 5], [2, 3, 5, 7], [2, 3, 5, 7]]`
- `[]`
- `[[]]`
- `Ok([[1, 3], [3, 4], [4, 2]])`
- `Error(Failed)`
