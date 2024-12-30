import gleam/int
import simplifile
import gleam/list
import gleam/io
import gleam/string
import gleam/set


// we have a matrix of dots hashes and carret
// place the x,y into a set for random lookups
//
// from the starting postion add or subtract x and y till we hit in the set of
// points
// record all places traversed in the set
//
//

pub fn main() {
  
    get_test()

    let data = get_data()
    let start = find_start(data)
    |> io.debug
    let count = parse_matrix(data)
    |> io.debug
    |> move_setup(start)
    |> io.debug
    |> set.size 

    let answer = int.to_string(count )
    io.println("number of cells " <> answer)
}

type Pair = #(Int,Int)
type Board {
    Grid(matrix:set.Set(Pair), width: Int, height:Int)
  }

fn get_data() -> String {
  let filename = "data\\aoc24-d6.txt"
  case simplifile.read(filename){
      Ok(x) -> x
      Error(_) -> panic as "Cannot open file"
    }
  
}

fn parse_matrix(d:String) -> Board{
    let data = string.replace(d, "\r\n","\n")
    // find width of first row
    let t = string.split_once(data, "\n")
    let width = case t {
        Ok(l) -> string.length(l.0)
        Error(_) -> panic as "can determine width of square"
    }
    // count number of rows
    let height = list.length(string.split(data, "\n"))

    let matrix = rec_parse(data, set.new(),0,0)
    Grid(matrix: matrix, width:width, height:height)
    // set.from_list([ #(1,1) ])
}

fn rec_parse(d:String, s:set.Set(Pair), x, y){
  case string.pop_grapheme(d){
      Ok(#(c, rest)) -> case c {
          "#" -> rec_parse(rest, set.insert(s,#(x,y)), x+1,y)
          "." | "^" -> rec_parse(rest, s, x+1,y)
          "\n" -> rec_parse(rest, s, 0,y+1)
          _ -> panic as "boo"
        }
      Error(_) -> s
    }
}

pub fn find_start(d:String) -> Pair{
  // let t = string.split_once(d,"^")
  let lines = case string.split_once(d,"^") {
    Ok(x) ->     string.split(x.0,"\n")
    Error(_) -> panic as "cant find start position"
  }


  let ypos = list.length(lines)
  let xpos = case list.last(lines){
      Ok(chars) -> string.length(chars)
      Error(_) -> panic as "cant access lines to find x postion"
    }

  #(xpos,ypos-1)
}

fn new_direction(old:Pair) -> Pair{
  case old{
      #(1,0) -> #(0,1)
      #(0,1) -> #(-1,0)
      #(-1,0) -> #(0,-1)
      #(0,-1) -> #(1,0)
      _ -> panic as "not a correct direction"
    }
  }

fn move_setup(matrix:Board, start) {
    move_along(matrix, start, #(0,-1), set.new())
}

fn move_along(matrix:Board, loc: Pair, dir:Pair, acc){
    // apply the dir to loc
    let new_loc = apply_dir(loc , dir)
    // io.debug( #( loc, acc, dir, new_loc ) )
    // check out of bounds
    let oob = out_of_bounds(matrix, loc)
    // case if in the set, and out of bounds 
    case set.contains(matrix.matrix, new_loc) , oob{
      _, True -> acc
      // True -> dont add into the acc, get new_direction recurse
      True, False -> move_along(matrix, loc, new_direction(dir), acc)
      // False -> add to acc
      False, False -> move_along(matrix, new_loc, dir, set.insert(acc, loc)) 
    }
}

fn out_of_bounds(matrix:Board, loc: Pair) -> Bool {
    let horizontal = case loc.0{
      x if x> matrix.width || x< 0 -> True  
      _ -> False

      }
    let vert = case loc.1{
      y if y> matrix.height || y< 0 -> True  
      _ -> False

      }
      horizontal || vert
}

fn apply_dir(a: Pair,b:Pair){
    #(a.0+b.0,a.1+b.1)
}
fn get_test() {
    "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."
  }
