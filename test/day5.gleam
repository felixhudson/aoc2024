import gleam/io
import gleam/list
import gleeunit/should
import gleam/dict
import gleam/set
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
  // let store : Graph = dict.new()
  let store: day5.RuleRecord = day5.new_rulerecord()
  let r = "1|2\n5|6\n"
  |> string.split("\n")
  |> day5.parserules()
  |> day5.break(store)

  set.contains(r.good, #(1,2))
  |> should.be_true
  set.contains(r.good, #(5,6))
  |> should.be_true
}

pub fn middle_test() {
    [#(True, [1,99,3])]
    |> day5.good_middle()
    |> should.equal([99])

    [#(True, [1,2,99,4,5])]
    |> day5.good_middle()
    |> should.equal([99])
  }

pub fn sequence_test() {
  let d :day5.Graph = dict.new() 
  |> day5.datainsert(#(32,15))
  |> day5.datainsert(#(15,2))
  |> day5.datainsert(#(2,10))

  let book = [ 15, 32, 13, 96, 47, 29, 78 ]
  let target = 32
  day5.bfs_all(d,[15],[], target)
  |> should.equal([10,2,15])
}

pub fn set_test() {
    let rules : day5.RuleSet = set.new()
    |> set.insert(#(1,2))
    |> set.insert(#(99,98))

    let a: day5.RuleRecord = day5.new_rulerecord()
    |> day5.insert_set( #(1,2))
    |> day5.insert_set( #(3,5))

    let t = [#(1,2)]
    day5.search_sets(t,a)
    // |> should.be_true

  }
