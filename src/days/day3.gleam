import gleam/result
import gleam/io
import gleam/string
import simplifile.{read}
import gleam/list

pub fn run(){
  get_data()
  |> list.map(string.to_graphemes)
  |> list.first
  // |> list.chunk(by: filter_chars)
  |> result.map(fn(x) {list.chunk(x, by:filter_chars)})
  |> io.debug
    
  }

pub fn get_data() {// -> List(List(Int)){
  let filename = "data\\aoc24-d3-short.txt"
  // let filename = "data\\day2-short.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  case read(from:filename){
    Ok( x ) -> parse_data(x)
    _ -> panic as "cannot open file"
   }
}


pub fn parse_data(text: String) ->List(String){
    let _r: List(String)= string.replace(text, "\r\n", "\n")
    |> string.split(")")
    // let d: List(List(String)) = 
    //return
}



fn filter_chars(d:String) {
    case d{
        "1" -> True
        "2" -> True
        "3" -> True
        "4" -> True
        "5" -> True
        "6" -> True
        "7" -> True
        "8" -> True
        "9" -> True
        "0" -> True
        "m" -> True
        "u" -> True
        "l" -> True
        "(" -> True
        ")" -> True
        "," -> True
        _ -> False
      }
  }

// idea
// use list.chunk to split on consecutive good chars
