import gleam/dict
import gleam/list
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
    let loc: day4.XMAS = day4.C([],dict.new(),dict.new(),dict.new())
    let r = string.to_graphemes("XXXMAS")
    |> day4.parseall(loc, 0, 0)

    list.length(r.x)
    |> should.equal(3)
  }
