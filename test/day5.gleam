import gleam/io
import gleam/list
import gleeunit/should
import gleam/dict
import gleam/string
import gleeunit
import days/day5.{type Graph}


pub fn main(){
    gleeunit.main()
  }


pub fn bfs_test(){
  let d :day5.Graph = dict.new() 
  |> day5.datainsert(#(1,2))
  |> day5.datainsert(#(3,2))
  |> day5.datainsert(#(2,4))
  should.equal(list.length(dict.keys(d)), 3)

  day5.bfs_all(d,[1],[], 1)
  |> should.equal([1])
  day5.bfs_all(d,[1],[], 4)
  |> should.equal([4,2,1])


  let d = day5.datainsert(d, #(1,5))
  day5.bfs_all(d,[1],[], 5)
  |> should.equal([5,1])

}

pub fn parse_test(){
  let store : Graph = dict.new()
  let r = "1|2\n5|6\n"
  |> string.split("\n")
  |> day5.parserules()
  |> day5.break(store)

  dict.get(r, 1)
  |> should.equal(Ok([2]))
  dict.get(r, 5)
  |> should.equal(Ok([6]))
}

pub fn middle_test() {
    [#(True, [1,99,3])]
    |> day5.good_middle()
    |> should.equal([99])

    [#(True, [1,2,99,4,5])]
    |> day5.good_middle()
    |> should.equal([99])
  }
