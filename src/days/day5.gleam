// A list of pairs X|Y
// this says that X comes before Y
//
// Then a list of Ints
// Check that this list obeys all of the above pairs

import gleam/result
import gleam/int
import gleam/string
import gleam/io
import gleam/list
import gleam/dict.{type Dict}
import simplifile
import gleam/option.{Some,None}


// Idea, parse pairs into a directed graph
// find node that doesnt exist in any other (ie the start)
// find path that traverses list
// store path order in a dict

// simple idea first
// just put the rules into dict


pub fn main(){
    let store : Graph = dict.new()
    
    let rules = [1,2,3,4]
    |> list.window_by_2()
    |> break(store)

    [1,2,3,4]
    |> testbook(rules)
    // |> io.debug


    
    let input = get_data()
    |> allfile
 
    io.debug("parse the rules")
    // take top of file and make a dict of the rules
    let allrules = parserules(input.0)
    |> break(store)

    io.debug("parse the books")
    let allbooks=str2int( input.1 )

    

    io.debug("test each pair of pages")
    // take the bottom of file convert to ints and then  
    let report =  list.map( allbooks, fn(x) {testbook(x, allrules)}) 
    |> list.map( fn(y) {list.all(y, fn(x){x==True})})
    //
    io.debug("prepare report")
    list.zip(report, allbooks)
    |> good_middle
    |> int.sum
    |> io.debug
    

}


fn allfile(d:String) {
  let k = string.replace(d,"\r\n","\n")
  |> string.split("\n")
  |> list.chunk(fn(x) { string.contains(x, "|") })
    case k {
        [a,b] -> #(a,list.filter(b, fn(x) {x != ""}) )
        _ -> panic as "Input needs rules and books"
      }
}
pub fn parserules(d:List(String)) {
    d
    |> list.filter_map(string.split_once(_,"|"))
    |> list.map(toint)


  }

fn toint(d: #(String,String))-> Edge {
    case int.parse(d.0), int.parse(d.1){
        Ok(x),Ok(y) -> #(x,y)
        _, _ -> panic as "cant convert both ints"
      }

  }
// fn parse(d:#(Int,Int), store:Dict(Int,List[Int]))
//

// break a list of ints into pairs into a set

pub fn break(d:List(Edge), store:Graph) -> Graph{
  list.fold(d, store, with: fn(x, y:Edge) {datainsert(x,y)})
}

fn testbook(d: List(Int), store:Graph) {
  list.window_by_2(d)
  // |> list.map(fn(x){ dict.has_key(store, x.0)})
  |> list.map(fn(x){ 
    bfs_all(store, [x.0],[], x.1)
    |> list.contains(x.1)
  })
  
}

fn test_data(){
    let filename = "aoc24-d5-short.txt"
    case simplifile.read(filename) {
        Ok(x) -> x
        Error(_e) -> panic as "cant read test file"
      }
  }

fn get_data(){
    let filename = "data\\aoc24-day5.txt"
    case simplifile.read(filename) {
        Ok(x) -> x
        Error(_e) -> panic as "cant read data file"
      }
  }

fn str2int(d:List( String )) -> List(List(Int)){

    // use y <- list.map(d)
    // case int.parse(y){ 
    //    Ok(x) -> x
    //    Error(e) -> { io.debug(e) panic as "int parse error" }    
    // } 
    use y <- list.map(d) 
    let r = string.split(y, ",")
    list.filter_map(r, int.parse)
  }


  // I need depth first search

  // pairs of Int -> Dict(Int,List(Int))
pub type Edge = #(Int,Int)
pub type Graph = Dict(Int, List(Int)) 
pub fn datainsert( store:Graph, d: Edge) {
  dict.upsert(store, d.0, fn(x) { 
      case x{
        Some(a) -> [d.1, ..a]
        None() -> [d.1]
      }
    }
  ) 
}


fn lenght_test(d:List(a)) {
    case list.length(d) {
        x if x % 10 == 0 -> {io.debug("loop " <> int.to_string(x)) io.debug(d) ""}
        _ -> ""
      }
  }

// writting bfs is hard, lets just return everything we find
//

pub fn bfs_all(graph:Graph, node:List(Int), acc: List(Int), target: Int) -> List(Int){
  case node{
      [x,..] if x == target -> [x, ..acc]
      // there are still nodes to traverse so look at head
      [current,..rest] -> case dict.get(graph, current), list.contains(acc, current){
                  // we have been here before so skip this node
                  _, True  -> bfs_all(graph, rest, acc, target)
                  // found children so add to front of list and recurse
                  Ok(children), False -> bfs_all(graph, list.flatten([ children, rest ]), [current, ..acc], target)
                  // no children here, move to the next in our node list
                  Error(_), False ->  bfs_all(graph, rest, [current, ..acc], target)
        }      
      // node list is empty so return everything we visited
      [] -> [] 

    }
      // let here: List(Int) = dict.get(graph, node)      
      // |> result.unwrap([])
      // list.map(here, fn(x) {bfs_all(graph, x)})
  }



pub fn good_middle(d: List(#(Bool, List(Int)))){
    list.filter(d, fn(x) {x.0 == True})
    |> list.map(fn(x) { let l = list.length(x.1)/2

    let m = list.drop(x.1,l)
    |> list.first()
    case m{
        Ok(x) -> x
        Error(_) -> panic as "cannot locate middle"
      }
    })
  }
