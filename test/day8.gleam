import gleam/set
import gleam/io
import gleam/result
import gleam/list
import gleeunit
import gleeunit/should
import days/day8

pub fn main(){
    gleeunit.main()
  }

pub fn parse_test() {
    ".a.b.c\nd.e.f."
    |> day8.parse_grid()
    |> list.contains(#("e",2,1))
    |> should.be_true()
  }

pub fn dipole_test(){

    [#("a",2,2), #("b",4,5), #("a",4,4)]
    |> day8.prepare_values
    |> list.map(day8.work_on_pair)
    |> list.flatten
    |> should.equal([#(6,6), #(0,0)])

  }
pub fn quad_test(){
  // [#("0", 8, 1), #("0", 5, 2), #("0", 7, 3), #("0", 4, 4)]
    let r = [#("0", 8, 1), #("0", 5, 2)]
    |> day8.prepare_values
    |> list.map(day8.work_on_pair)
    |> list.flatten
    |> day8.filter_antipodes
    |> result.values

    let s1 = set.from_list(r)
    let s2 = set.from_list([#(11,0), #(2,3)])
    set.is_subset(s1,s2)
    |> should.be_true
}

