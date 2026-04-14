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

}

pub fn prime_numbers(n: Int) -> List(Int) {

}


pub fn lists_of_numbers(n: Int, f: fn(Int)->List(Int)) -> List(List(Int)) {

}

pub fn can_reach(from: Int, to: Int, a: List(List(Int))) -> Result(List(List(Int)), BacktrackState) {
   
}
