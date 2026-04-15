import gleam/io
import gleam/int
import gleam/list

/// The Backtrack State is an enumerated type with two states.  
///  It captures the state of backtracking
pub type BacktrackState {
  Failed
  Backtrack
}

pub fn main() {
  // Testing counting numbers
  echo counting_numbers(6)

  // Testing prime numbers
  echo prime_numbers(8)

  // Testing list of numbers
  echo lists_of_numbers(6, counting_numbers)
  echo lists_of_numbers(8, prime_numbers)
  echo lists_of_numbers(-1, counting_numbers)
  echo lists_of_numbers(1, prime_numbers)

  // Testing reachability
  echo can_reach(1, 2, [[4, 2], [2, 3], [1, 3], [3, 4]])
  echo can_reach(1, 2, [[4, 2], [2, 3], [5, 3], [3, 4]])
}

/// returns a lis [1, 2, 3, ..., n]
/// if n is less than 1 then return an empty list
pub fn counting_numbers(n: Int) -> List(Int) {
  case n < 1 {
    True -> []
    False -> counting_from(1, n)
  }
}

/// helper function for counting_numbers
/// builds the list starting at "current" and ending at "n"
fn counting_from(current: Int, n: Int) -> List(Int) {
  case current > n {
    True -> []
    False -> [current, ..counting_from(current + 1, n)]
  }
}

/// returns all prime numbers for 2 to n using sieve of eratsthenes
/// if n is less than 2 it returns an empty list
pub fn prime_numbers(n: Int) -> List(Int) {
  case n < 2 {
    True -> []
    False -> sieve(counting_from_prime(2, n))
  }
}

/// helper function for prime_numbers
/// builds starting list for the sieve
fn counting_from_prime(current: Int, n: Int) -> List(Int) {
  case current > n {
    True -> []
    False -> [current, ..counting_from_prime(current + 1, n)]
  }
}

/// runs the sieve
/// takes the first num as prime, removes all its multiples from list, continue (recursive)
fn sieve(numbers: List(Int)) -> List(Int) {
  case numbers {
    [] -> []
    [first, ..rest] -> [first, ..sieve(remove_multiples(rest, first))]
  }
}

/// removes all multiples of p for a list
fn remove_multiples(numbers: List(Int), p: Int) -> List(Int) {
  case numbers {
    [] -> []
    [first, ..rest] ->
      case int.modulo(first, p) {
        /// first num divisible by p so exclue
        Ok(0) -> remove_multiples(rest, p)
        /// first not divisible by p so keep
        Ok(_) -> [first, ..remove_multiples(rest, p)]
        /// fallback if the previous fails
        Error(_) -> [first, ..remove_multiples(rest, p)]
      }
  }
}

/// returns list of lists, each inner list is produced by f
/// if n is less than 1 it returns an empty list
pub fn lists_of_numbers(n: Int, f: fn(Int)->List(Int)) -> List(List(Int)) {
  case n < 1 {
    True -> []
    False -> build_lists(1, n, f)
  }
}

/// helper function for lists_of_numbers
/// calls f on each int from current to n and collects results
fn build_lists(
  current: Int, 
  n: Int, 
  f: fn(Int) -> List(Int),
) -> List(List(Int)) {
  case current > n {
    True -> []
    False -> [f(current), ..build_lists(current + 1, n, f)]
  }
}

/// tries to find path from "from" to "to" in a directed graph
/// graph is represented as list of edges
/// returns: Ok(path) if path is found, Error(Failed) if no path
pub fn can_reach(from: Int, to: Int, a: List(List(Int))) -> Result(List(List(Int)), BacktrackState) {
  case from == to {
    /// already at destination, path empty
    True -> Ok([])
    False -> case search_path(from, to, a, a, [from]) {
      Ok(path) -> Ok(path)
      Error(_) -> Error(Failed)
    }
  }
}

/// recursive backtracking search for path
fn search_path(current: Int, target: Int, a: List(List(Int)), 
               remaining: List(List(Int)), visited: List(Int),
               ) -> Result(List(List(Int)), BacktrackState) {
  case remaining {
    /// no more edges to try so backtrack
    [] -> Error(Backtrack)

    [edge, ..rest] ->
      case edge {
        [x, y] ->
          case x == current {
            True ->
              case contains(visited, y) {
                /// skip edges leading to already visited node
                True -> search_path(current, target, a, rest, visited)
                False ->
                  case y == target {
                    /// found destination directly
                    True -> Ok([edge])
                    False -> 
                    /// try to continue path from y
                      case search_path(y, target, a, a, [y, ..visited]) {
                        Ok(path) -> Ok([edge, ..path])
                        /// try nect possible edge
                        Error(_) -> search_path(current, target, a, rest, visited)
                      }
                  }
              }
              /// this edge doesnt start from current node so skip
            False -> search_path(current, target, a, rest, visited)
          }
          /// ignore malformed edges
        _ -> search_path(current, target, a, rest, visited)
        }
  }
}

/// returns true if target appears anywhere in list values
/// for preventing cycles during graph search
fn contains(values: List(Int), target: Int) -> Bool {
  case values {
    [] -> False
    [first, ..rest] -> first == target || contains(rest, target)
  }
}
