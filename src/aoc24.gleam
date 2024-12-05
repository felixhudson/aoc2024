import gleam/result
import gleam/int
import gleam/io
import gleam/list
import simplifile.{read}
import gleam/string

pub fn main() {
  io.println("Hello from aoc24!")
  let a = [3,4,2,1,3,3]
  let b = [4,3,5,3,9,3]
  let example = list.zip(a,b)
  |> list.unzip
  |> io.debug()

  let filename = "aoc24-d1.txt"
  let d = result.unwrap(read(from:filename), "File not found")
  |> string.split("\r\n")
  |> list.map(fn(a) {string.split(a,"   ")})
  |> list.flatten
  |> list.reverse
  |> list.rest
  |> result.unwrap(["a"])
  |> list.reverse
  |> list.map(fn(x){result.unwrap( int.parse(x), 0 )})
  |> list.sized_chunk(2)

  list.zip(example.0, example.1)
  |> io.debug
  // |> list.map(subtract)
  // |> int.sum
  // |> io.debug
  io.debug(" better idea")
  "234   444"
  |> parse2
  |> io.debug
  // |> list.map(subtract)
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
    [a,b] -> a - b
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
