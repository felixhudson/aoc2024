// A list of pairs X|Y
// this says that X comes before Y
//
// Then a list of Ints
// Check that this list obeys all of the above pairs

import gleam/int
import gleam/result
import gleam/string
import gleam/io
import gleam/pair
import gleam/list
import gleam/dict.{type Dict}
import simplifile
import gleam/option.{Some,None}

type Pagerule = #(Int,Int)
type Rules = Dict(Pagerule,Bool)

// Idea, parse pairs into a directed graph
// find node that doesnt exist in any other (ie the start)
// find path that traverses list
// store path order in a dict

// simple idea first
// just put the rules into dict


pub fn main(){
    let store : Rules = dict.new()
    
    let rules = [1,2,3,4]
    |> list.window_by_2()
    |> break(store)

    [1,2,3,4]
    |> testbook(rules)
    // |> io.debug


    "1|2\n5|6\n"
    |> string.split("\n")
    |> parserules()
    |> break(store)
    // |> io.debug
    
    let input = test_data()
    |> allfile
    // |> io.debug
  
    // take top of file and make a dict of the rules
    let allrules = parserules(input.0)
    |> break(store)
    |> io.debug

    let allbooks=str2int( input.1 )

    // take the bottom of file convert to ints and then  
    let report =  list.map( allbooks, fn(x) {testbook(x, allrules)}) 
    |> io.debug
    // |> list.all(fn(x){x==True})
    //

    list.zip(report, allbooks)
    |> io.debug
    

}

type Inputs {
    Rule(String)
    Book(String)
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
fn parserules(d:List(String)) {
    d
    |> list.filter_map(string.split_once(_,"|"))
    |> list.map(toint)


  }

fn toint(d: #(String,String))-> Pagerule {
    case int.parse(d.0), int.parse(d.1){
        Ok(x),Ok(y) -> #(x,y)
        _, _ -> panic as "cant convert both ints"
      }

  }
// fn parse(d:#(Int,Int), store:Dict(Int,List[Int]))
//

// break a list of ints into pairs into a set

fn break(d:List(Pagerule), store:Rules) -> Rules{
  list.fold(d, store, with: fn(x, y:Pagerule) {dict.insert(x,y,True)})
}

fn testbook(d: List(Int), store:Rules) {
  list.window_by_2(d)
  |> list.map(fn(x){ dict.has_key(store, x)})
}

fn test_data(){
    let filename = "aoc24-d5-short.txt"
    case simplifile.read(filename) {
        Ok(x) -> x
        Error(_e) -> panic as "cant read test file"
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

// writting bfs is hard, lets just return everything we find
//

pub fn bfs_all(graph:Graph, node:List(Int), acc: List(Int)) -> List(Int){
  case node{
      // there are still nodes to traverse so look at head
      [current,..rest] -> case dict.get(graph, current){
                  // found children so add to front of list and recurse
                  Ok(children) -> bfs_all(graph, list.flatten([ children, rest ]), [current, ..acc])
                  // no children here, move to the next in our node list
                  Error(_) ->  bfs_all(graph, rest, [current, ..acc])
        }      
      // node list is empty so return everything we visited
      [] -> acc 

    }
      // let here: List(Int) = dict.get(graph, node)      
      // |> result.unwrap([])
      // list.map(here, fn(x) {bfs_all(graph, x)})
  }

