import gleam/io
import gleam/list
import gleeunit/should
import gleam/dict
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

  day5.bfs_all(d,[1],[])
  |> should.equal([4,2,1])


  let d = day5.datainsert(d, #(1,5))
  day5.bfs_all(d,[1],[])
  |> should.equal([4,2,5,1])

  }
