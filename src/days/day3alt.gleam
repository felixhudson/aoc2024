import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile.{read}

pub type Token {
    Start
    Digits(String)
    Comma
    End
    Empty
    Bad
  }


pub fn main(){
  get_data()
  |> list.map(one_line)
  |> int.sum
  |> io.debug


  }

fn one_line(d:String) -> Int {
  d
  |> string.to_graphemes
  |> tokenizer
  |> combine_digits
  |> parse_good

  }

pub fn get_data() {// -> List(List(Int)){
  let _filename = "data\\aoc24-d3-short.txt"
  let filename = "data\\aoc24-d3.txt"
  // let filename = "day2-short.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  case read(from:filename){
    Ok( x ) -> parse_data(x)
    _ -> panic as "cannot open file"
   }
}


pub fn parse_data(text: String) ->List(String){
    let _r: List(String)= string.replace(text, "\r\n", "\n")
    |> string.split("\n")
    // let d: List(List(String)) = 
    //return
}

pub fn tokenizer(d: List(String)) -> List(Token){
  case d {
      ["m","u","l","(", ..rest] -> list.flatten([[Start] , tokenizer(rest)])
      [")", ..rest] -> list.flatten([[End] , tokenizer(rest)])
      [",", ..rest] -> list.flatten([[Comma] , tokenizer(rest)])
      [x, ..rest] -> {
                  case is_digit(x) {
                      True -> list.flatten([[Digits(x)] , tokenizer(rest)])
                      False -> list.flatten([[Bad] , tokenizer(rest)])}
                    }
      _ -> []
    }

  }

fn is_digit(a:String) -> Bool {
    case a{
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
        "," -> True
        _ -> False
      }
  }


pub fn combine_digits(d:List(Token)) -> List(Token) {
  rec_combine_digits(d, "")

  }


fn rec_combine_digits(d:List(Token), acc:String) -> List(Token) {
  case d, acc {
      [Digits(x),..rest] , num -> rec_combine_digits(rest, num<>x)
      [x,..rest], "" -> list.flatten([[x], rec_combine_digits(rest, "")])
      [x,..rest], num -> list.flatten([[Digits(num)], [ x ], rec_combine_digits(rest, "")] )
      _,_  -> []

    }
}

pub fn parse_good(d:List(Token)){
  case d {
      [Start, Digits(x), Comma, Digits(y),End, ..rest] -> mult(x,y) + parse_good(rest)
      [_, ..rest] -> parse_good(rest)
      _ -> 0
    }

  }

fn mult(x:String,y) -> Int {
  let a = int.parse(x)
  let b = int.parse(y)
  case a,b{
      Ok(a), Ok(b) -> a*b
      _ , _ -> panic as "error parsing"
    }
  }
