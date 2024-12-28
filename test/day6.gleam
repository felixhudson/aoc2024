import gleeunit
import gleeunit/should
import days/day6

pub fn main() {
    gleeunit.main()
  }

pub fn start_test(){

  "....\n..^.\n"
  |> day6.find_start()
  |> should.equal(#(1,2))

  }
