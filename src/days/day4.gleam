import gleam/io
import simplifile
import gleam/string
import gleam/list
import gleam/dict.{type Dict}


pub fn main() {
    let loc = get_data()
    |> split_file()
    |> string.to_graphemes
    |>parseall(C([], dict.new(), dict.new(), dict.new()), 0,0)

    io.debug("finished parsing input")

    list.map(loc.x, scan(loc,_))
    |> list.flatten
    |> list.count(fn(x) {x==True})
    |> io.debug
  }


// make 4 lists x m a s
// given a row and number add it to a list
//
pub type Loc = #(Int,Int)
pub type XMAS {
    C(x:List(Loc), 
      m:Dict(Loc, Bool),
      a:Dict(Loc, Bool),
      s:Dict(Loc, Bool)
      )
  }

pub fn parseall(d:List(String), loc : XMAS, row:Int, count:Int) -> XMAS{
  case d{
      ["\n", ..rest] -> parseall(rest, loc, row+1, 0)
      ["X", ..rest] -> parseall(rest, C(x: list.append(loc.x, [ #(row,count) ]), m: loc.m, a: loc.a, s: loc.s), row, count +1) 
      ["M", ..rest] -> parseall(rest, C(m: dict.insert(loc.m, #(row,count), True ), x: loc.x, a: loc.a, s: loc.s), row, count +1) 
      ["A", ..rest] -> parseall(rest, C(a: dict.insert(loc.a, #(row,count), True ), x: loc.x, m: loc.m, s: loc.s), row, count +1) 
      ["S", ..rest] -> parseall(rest, C(s: dict.insert(loc.s, #(row,count), True ), x: loc.x, m: loc.m, a: loc.a), row, count +1) 
      [x, ..] -> { io.debug("::err::") io.debug(x) panic as "invalid character"
        }      [] -> loc
    }
  }

fn test_data() {
    "XMASS
MMXXA
AXAMM
SAMSX
SAMXS"
}

fn get_data() {
    let filename = "day4-short.txt"
    let filename = "day4.txt"
    case simplifile.read(from:filename){
      Ok( x ) -> x
      _ -> panic as "cannot open file"
 }
}


fn split_file(data:String) {
  string.replace(data, "\r\n","\n")
}


fn scan(xmas:XMAS, start: #(Int,Int)){
  let x = start.0
  let y = start.1
  //left and right
  let l = dict.has_key(xmas.m ,#(x,y+1)) && dict.has_key(xmas.a, #(x,y+2)) && dict.has_key(xmas.s, #(x,y+3))
  let r = dict.has_key(xmas.m ,#(x,y-1)) && dict.has_key(xmas.a, #(x,y-2)) && dict.has_key(xmas.s, #(x,y-3))
  // up down
  let u =   dict.has_key(xmas.m ,#(x+1,y+0)) && dict.has_key(xmas.a, #(x+2,y+0)) && dict.has_key(xmas.s, #(x+3,y+0))
  let d =   dict.has_key(xmas.m ,#(x-1,y+0)) && dict.has_key(xmas.a, #(x-2,y+0)) && dict.has_key(xmas.s, #(x-3,y+0))
  //diags
  let zig =   dict.has_key(xmas.m ,#(x+1,y+1)) && dict.has_key(xmas.a, #(x+2,y+2)) && dict.has_key(xmas.s, #(x+3,y+3))
  let zag =   dict.has_key(xmas.m ,#(x-1,y-1)) && dict.has_key(xmas.a, #(x-2,y-2)) && dict.has_key(xmas.s, #(x-3,y-3))
  // alt
  let altzig =   dict.has_key(xmas.m ,#(x+1,y-1)) && dict.has_key(xmas.a, #(x+2,y-2)) && dict.has_key(xmas.s, #(x+3,y-3))
  let altzag =   dict.has_key(xmas.m ,#(x-1,y+1)) && dict.has_key(xmas.a, #(x-2,y+2)) && dict.has_key(xmas.s, #(x-3,y+3))
  [u,d,l,r,zig,zag,altzig,altzag]
}
