import gleam/result
import gleam/int
import gleam/io
import gleam/list
import simplifile.{read}
import gleam/string

pub fn main() {
  io.println("Hello from aoc24!")
  // let a = [3,4,2,1,3,3]
  // let b = [4,3,5,3,9,3]
  // let example = list.zip(a,b)
  // |> io.debug()
  // |> list.unzip
  // |> io.debug()

  let dlists = parse_file()
  // |> io.debug()
  |> take_two([],[])
  // |> list.map(list.length)
  list.map(dlists, sort_int)
  // |> list.sort(by:int.compare)
  // |> list.map(list.length)
  // |> io.debug()
  |> apply_first_two(cmp_two_lists)
  |> int.sum
  |> io.debug()


  // |> list.sized_chunk(2)
  // list.zip(example.0, example.1)
  // |> io.debug
  // |> list.map(subtract)
  // |> int.sum
  // |> io.debug

  // io.debug(" better parse idea")
  // "234   444"
  // |> parse2
  // |> io.debug
  // |> list.map(subtract)
}

fn apply_first_two(a:List(List(Int)), func){
  case a{
      [a,b,.._] -> func(a,b,[])
      _ -> []
    }
  }

fn cmp_two_lists(a,b,acc){
    case a,b{
        [x,..rest],[y,..tail] -> cmp_two_lists(rest,tail,[difference(x,y),..acc])
        _,_ -> acc
      }
  } 

fn difference(a,b){
    case a,b{
      x,y if x > y -> x-y
      x,y if x < y -> y-x
      _,_ -> 0

      }
  }


fn sort_int(a:List(Int)){
    list.sort(a,by: int.compare)
  }

fn take_two(d, acc1: List(Int), acc2: List(Int)){
  case d{
      [x,y,..rest] -> take_two(rest, [x,..acc1], [y,..acc2])
      [] -> [acc1, acc2]
      [_] -> panic("list must be not odd length")
    }
  }

fn parse_file() {
  // parses input file into a flat list of integers
  let filename = "aoc24-d1.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  read(from:filename)
  |> result.unwrap("File not found")
  |> string.split("\r\n")
  |> list.map(fn(a) {string.split(a,"   ")})
  // |> io.debug
  |> list.flatten
  |> list.reverse
  |> list.rest
  |> result.unwrap(["a"])
  |> list.reverse
  |> list.map(fn(x){result.unwrap( int.parse(x), 0 )})
}

fn parse2(a:String){
  string.split(a, "   ")
  |> list.map(int.parse)
  |> list.map(fix)
}

fn fix(a) {
    let assert Ok(z) = a
    z
  }

fn subtract(a:List(Int)){
  case a{
    [a,b] if a> b -> a - b
    [a,b] if b > a -> b - a
    _ -> 0
  }
}

fn compare(a,b) -> Int{
    // sort the lists
    // compare
    3
  }

fn simple(a: List(Int),b:List(Int)) -> Int {
  int.sum(b) - int.sum(a)
}
