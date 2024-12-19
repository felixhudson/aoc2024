import gleam/io
import gleam/string
import gleeunit
import gleeunit/should
import days/day4

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn perline_test(){
    let loc: day4.XMAS = day4.C([],[],[],[])
    string.to_graphemes("xxxmas")
    |> day4.parseall(loc, 0, 0)
    |> io.debug
  }
