import gleam/io
import simplifile
import gleam/string
import gleam/list
import gleam/dict


pub fn main() {
    let loc = get_data()
    |> split_file()
    |> string.to_graphemes
    |>parseall(C([],[],[],[]), 0,0)

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
      m:List(Loc),
      a:List(Loc),
      s:List(Loc))
  }

pub fn parseall(d:List(String), loc : XMAS, row:Int, count:Int) -> XMAS{
  case d{
      ["\n", ..rest] -> parseall(rest, loc, row+1, 0)
      ["X", ..rest] -> parseall(rest, C(x: list.append(loc.x, [ #(row,count) ]), m: loc.m, a: loc.a, s: loc.s), row, count +1) 
      ["M", ..rest] -> parseall(rest, C(m: list.append(loc.m, [ #(row,count) ]), x: loc.x, a: loc.a, s: loc.s), row, count +1) 
      ["A", ..rest] -> parseall(rest, C(a: list.append(loc.a, [ #(row,count) ]), x: loc.x, m: loc.m, s: loc.s), row, count +1) 
      ["S", ..rest] -> parseall(rest, C(s: list.append(loc.s, [ #(row,count) ]), x: loc.x, m: loc.m, a: loc.a), row, count +1) 
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
  let l = list.contains(xmas.m ,#(x,y+1)) && list.contains(xmas.a, #(x,y+2)) && list.contains(xmas.s, #(x,y+3))
  let r = list.contains(xmas.m ,#(x,y-1)) && list.contains(xmas.a, #(x,y-2)) && list.contains(xmas.s, #(x,y-3))
  // up down
  let u =   list.contains(xmas.m ,#(x+1,y+0)) && list.contains(xmas.a, #(x+2,y+0)) && list.contains(xmas.s, #(x+3,y+0))
  let d =   list.contains(xmas.m ,#(x-1,y+0)) && list.contains(xmas.a, #(x-2,y+0)) && list.contains(xmas.s, #(x-3,y+0))
  //diags
  let zig =   list.contains(xmas.m ,#(x+1,y+1)) && list.contains(xmas.a, #(x+2,y+2)) && list.contains(xmas.s, #(x+3,y+3))
  let zag =   list.contains(xmas.m ,#(x-1,y-1)) && list.contains(xmas.a, #(x-2,y-2)) && list.contains(xmas.s, #(x-3,y-3))
  // alt
  let altzig =   list.contains(xmas.m ,#(x+1,y-1)) && list.contains(xmas.a, #(x+2,y-2)) && list.contains(xmas.s, #(x+3,y-3))
  let altzag =   list.contains(xmas.m ,#(x-1,y+1)) && list.contains(xmas.a, #(x-2,y+2)) && list.contains(xmas.s, #(x-3,y+3))
  [u,d,l,r,zig,zag,altzig,altzag]
}
