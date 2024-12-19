import gleam/result
import gleam/int
import gleam/io
import gleam/list
import simplifile.{read}
import gleam/string

pub fn run(){
 // let data =  parse_file()
 io.debug("better idea")
 part1()
}


fn part1(){
   // result.try(data.0, fn(x) {
   //     result.map(data.1, fn(y){
   //         list.map2(x, y, fn(a,b) {int.absolute_value(a-b)})
   //         |> io.debug
   //       })
   //   })
  let data =  parse_file()
  let r = {
    use x <- result.map(data.0)
    use y <- result.map(data.1)
      // list.fold(x, from: 0,  with:int.add)
      list.map2(x,y, fn(a,b) {int.absolute_value(a-b)})
  }
  result.unwrap(r, Ok([]))
  |> result.unwrap([])
  |> int.sum
  |>io.debug
}

fn parse_file() {
  // parses input file into two lists of integers
  let filename = "aoc24-d1.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  let pairs = read(from:filename)
  // |> result.map(string.is_empty)
  |> result.map(string.split(_, "\r\n"))
  // |> io.debug()
  |> result.map(list.filter_map(_, string.split_once(_, "   ")))
  // now we have a result with a list of results in it
  // |> io.debug()

  // make lists of each side
  let left = result.map(pairs, list.filter_map(_, fn(x) {int.parse(x.0)}))
  let right = result.map(pairs, list.filter_map(_, fn(x) {int.parse(x.1)}))

  let left = result.map(left, list.sort(_, by:int.compare))
  let right = result.map(right, list.sort(_, by:int.compare))
  #(left, right)

  // We should handle all errors here and just return a OK tuple

  // let left = result.unwrap(left, [])
  // let right = result.unwrap(right, [])
  // Ok(#(left, right))

}
