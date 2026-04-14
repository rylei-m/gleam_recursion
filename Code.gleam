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
  if n < 1 {
    []
  } else {
    counting_from(1, n)
  }
}

fn counting_from(current: Int, n: Int) -> List(Int) {
  if current > n {
    []
  } else {
    [current, ..counting_from(current + 1, n)]
  }
}


pub fn prime_numbers(n: Int) -> List(Int) {
  if n < 2 {
    []
  } else {
    sieve(counting_from_prime(2, n))
  }
}

fn counting_from_prime(current: Int, n: Int) -> List(Int) {
  if current > n {
    []
  } else {
    [current, ..counting_from_prime(current + 1, n)]
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
      if int.modulo(first, p) == 0 {
        remove_multiples(rest, p)
      } else {
        [first, ..remove_multiples(rest, p)]
      }
  }
}

pub fn lists_of_numbers(n: Int, f: fn(Int)->List(Int)) -> List(List(Int)) {
  if n < 1 {
    []
  } else {
    build_lists(1, n, f)
  }
}

fn build_lists(
  current: Int, 
  n: Int, 
  f: fn(Int) -> List(Int),
) -> List(List(Int)) {
  if current > n {
    []
  } else {
    [f(current), ..build_lists(current + 1, n, f)]
  }
}

pub fn can_reach(from: Int, to: Int, a: List(List(Int))) -> Result(List(List(Int)), BacktrackState) {
   
}
