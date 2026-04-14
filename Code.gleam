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

pub fn counting_numbers(n: Int) -> List(Int) {
  case n < 1 {
    True -> []
    False -> counting_from(1, n)
  }
}

fn counting_from(current: Int, n: Int) -> List(Int) {
  case current > n {
    True -> []
    False -> [current, ..counting_from(current + 1, n)]
  }
}


pub fn prime_numbers(n: Int) -> List(Int) {
  case n < 2 {
    True -> []
    False -> sieve(counting_from_prime(2, n))
  }
}

fn counting_from_prime(current: Int, n: Int) -> List(Int) {
  case current > n {
    True -> []
    False -> [current, ..counting_from_prime(current + 1, n)]
  }
}

fn sieve(numbers: List(Int)) -> List(Int) {
  case numbers {
    [] -> []
    [first, ..rest] -> [first, ..sieve(remove_multiples(rest, first))]
  }
}

fn remove_multiples(numbers: List(Int), p: Int) -> List(Int) {
  case numbers {
    [] -> []
    [first, ..rest] ->
      case int.modulo(first, p) {
        Ok(0) -> remove_multiples(rest, p)
        Ok(_) -> [first, ..remove_multiples(rest, p)]
        Error(_) -> [first, ..remove_multiples(rest, p)]
      }
  }
}

pub fn lists_of_numbers(n: Int, f: fn(Int)->List(Int)) -> List(List(Int)) {
  case n < 1 {
    True -> []
    False -> build_lists(1, n, f)
  }
}

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

pub fn can_reach(from: Int, to: Int, a: List(List(Int))) -> Result(List(List(Int)), BacktrackState) {
  case from == to {
    True -> Ok([])
    False -> case search_path(from, to, a, a, [from]) {
      Ok(path) -> Ok(path)
      Error(_) -> Error(Failed)
    }
  }
}

fn search_path(current: Int, target: Int, a: List(List(Int)), 
               remaining: List(List(Int)), visited: List(Int),
               ) -> Result(List(List(Int)), BacktrackState) {
  case remaining {
    [] -> Error(Backtrack)

    [edge, ..rest] ->
      case edge {
        [x, y] ->
          case x == current {
            True ->
              case contains(visited, y) {
                True -> search_path(current, target, a, rest, visited)
                False ->
                  case y == target {
                    True -> Ok([edge])
                    False -> 
                      case search_path(y, target, a, a, [y, ..visited]) {
                        Ok(path) -> Ok([edge, ..path])
                        Error(_) -> search_path(current, target, a, rest, visited)
                      }
                  }
              }
            False -> search_path(current, target, a, rest, visited)
          }
        _ -> search_path(current, target, a, rest, visited)
        }
  }
}

fn contains(values: List(Int), target: Int) -> Bool {
  case values {
    [] -> False
    [first, ..rest] -> first == target || contains(rest, target)
  }
}
