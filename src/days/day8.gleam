import gleam/result
import gleam/string
import simplifile
import gleam/set
import gleam/dict
import gleam/io
import gleam/list

pub fn main() {

    let s = set.new()
   
    get_data()
    |> parse_grid()
    // make a pair of all same frequency antenna 
    |> io.debug
    |> prepare_values
    |> io.debug
    // generate all anitpodes
    |> list.map(work_on_pair)
    |> list.flatten
    |> filter_antipodes
    |> result.values()
    |> display
    // insert into set
    |> list.fold(s, fn(a,b) { set.insert(a, b) })
    |> set.size()
    |> io.debug
  }

pub fn filter_antipodes(d:List(#(Int,Int))) -> List(Result(#(Int, Int), Int)){
  case d{
     [#(x,y), ..rest]  if x < 0  || y < 0 -> [Error(x), ..filter_antipodes(rest) ]
     [#(x,y), ..rest]  if x > 11 || y > 11 -> [Error(x), ..filter_antipodes(rest) ]
     [g, ..rest] -> [Ok(g), ..filter_antipodes(rest)] 
     [] -> []
    }
  }

pub fn prepare_values(d: List(Antenna)){
    d
    |> list.group(fn(x) {x.0})
    |> dict.values()
    |> list.map(fn(x) {list.combination_pairs(x)})
    |> list.flatten
  }

fn get_data() -> String {
  let filename = "data\\aoc24-d8-short.txt"
  case simplifile.read(filename){
      Ok(x) -> string.replace(x,"\r\n","\n")
      Error(_) -> panic as "Cannot open file"
   }
  
}

pub type Antenna = #(String, Int,Int)

pub fn parse_grid(d:String){
   parse_grid_rec(d, 0,0) 
    // [#("a",2,2), #("b",4,5), #("a",4,4)]
  }

fn parse_grid_rec(d:String, x, y) -> List(Antenna){
    case string.pop_grapheme(d){
      Ok( #(".",rest) ) -> parse_grid_rec(rest, x+1,y)
      Ok( #("\n",rest) ) -> parse_grid_rec(rest,0 ,y+1)
      Ok( #(char,rest) ) -> [#(char,x,y), ..parse_grid_rec(rest, x+1,y)]
      Error(_) -> []
    }

  }

pub fn work_on_pair(pair: #(Antenna,Antenna) )-> List(#(Int,Int)){
  let xdelta = pair.1.1 - pair.0.1
  let ydelta = pair.1.2 - pair.0.2
  [#(pair.0.1 - xdelta, pair.0.2 - ydelta),
    #(pair.0.1 + 2* xdelta, pair.0.2 + 2* ydelta)]
  }


fn display(d:List(#(Int,Int))){
    list.map(d,fn(x) {#(x.1+1,x.0+1)})
    |> io.debug

    d
  }
