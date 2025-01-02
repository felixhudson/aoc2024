import gleam/set
import gleam/dict
import gleam/io
import gleam/int
import gleam/string
import gleam/list

// idea
// make a dict of 3 Int,Int,Int
// this will be the val,x,y of every element

// also keep a list of zeros

pub fn main(){
    // 11198541019
    // 11157632118
    let elements = "11198541019\r\n11157632118"
    |> parse_grid()

    let matrix:Matrix = elements
    |> set.from_list()

    let zeros = elements
    |> find_zeros()
    |> io.debug


    find_paths(matrix, zeros, [])
    |> io.debug

  }
pub type Element = #(Int,Int,Int)
pub type Matrix =set.Set(Element) 

pub fn find_paths(matrix:Matrix,stack:List(Element),located) {
    io.debug(stack)
    case stack{
      [#(9,x,y),..tail] ->  find_paths(matrix, tail,[#(9,x,y),..located])
      [#(n,x,y),..tail] -> { let new = search(matrix, x,y,n + 1)
              find_paths(matrix, list.flatten( [new, tail] ),located) }
      [] -> located
      }
  }

pub fn search(matrix,x,y,count){
    let candidates = [#(count,x-1,y),
                      #(count,x,y-1),
                      #(count,x+1,y),
                      #(count,x,y+1)]
    let k = list.filter(candidates,fn(x) {set.contains(matrix,x)})
    // |> io.debug
    k
  }

// pub fn search_rec(matrix,candidates,count){
//     case candidates{
//         [h,t] -> []
//         _ -> []
//       }
//   }

pub fn find_zeros(e){
    case e{
        [#(0,x,y),..rest] -> [#(0,x,y),..find_zeros(rest)]
        [_,..rest] -> find_zeros(rest)
        [] -> []
      }
  }

pub type GridLookup = dict.Dict(#(String,Int,Int),Bool)

fn parse_grid(d:String){
    parse_grid_rec(d,0,0)
  }

fn parse_grid_rec(d:String, x,y) -> List(Element){
  case string.pop_grapheme(d){
    Ok( #("\n",rest) ) -> parse_grid_rec(rest, 0, y+1)
    Ok( #("\r\n",rest) ) -> parse_grid_rec(rest, 0, y+1)
    Ok( #(char,rest) ) -> case int.parse(char) {
          Ok(num) -> [#(num,x,y),..parse_grid_rec(rest, x+1, y)]
          Error(_a) -> panic as "cant parse int"
          }
    Error(_) -> []
    }
}

// fn parse_data(d:String){
//     string.replace(d,"\r\n","\n")
//     |> string.split("\n")
//     |> list.map(string.to_graphemes)
//     |> list.map(list.map(_, int.parse ))
//     |> list.map(result.all)
//     |>result.all
//   }
