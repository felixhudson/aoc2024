import gleam/bool
import gleam/int
import gleam/string
import gleam/list
import gleam/io
import simplifile.{read}

pub fn run() {
    io.debug("day2")
    // process(test_data())
    list.length(get_data())
    |> io.debug
    io.debug("use fold and map2")
    process(get_data())
    |> list.count(fn(x) {x== True})
    |> io.debug
    // debug(get_data())
    // io.debug("single run")
    // io.debug([1,2,5,4,6])
    // |> setuprec
    // |> io.debug

    io.debug("use investigate with list.all")
    list.map(get_data(), investigate)
    |> list.count(fn(x) {x==True})
    |>io.debug

}

pub fn get_data() {// -> List(List(Int)){
  let filename = "aoc24-d2.txt"
  // let filename = "day2-short.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  case read(from:filename){
    Ok( x ) -> parse_data(x)
    _ -> panic as "cannot open file"
   }
}

pub fn investigate(data) -> Bool{
  let diff = list.map(list.window(data,2), fn(x) { case x{ 
            [x,y] -> x-y
            _ -> panic as "no good"}})
  let smallmoves = list.all(diff, fn(x){int.absolute_value(x) < 4})
  let nonzero = list.all(diff, fn(x) { x != 0})
  let constant = case diff {
      [x,..] if x > 0 -> list.all(diff, fn(x){x>0})
      [x,..] if x < 0 -> list.all(diff, fn(x){x<0})
      [0,..] -> False
      [_,..] -> False
      [] -> True
  }

  // io.debug(#(smallmoves, nonzero, constant, data,diff))
  let r = smallmoves && nonzero && constant 
  case r {
      False -> io.debug(data)
      True -> [1]
    }
  r

  }

pub fn setuprec(data){
  // let diff = list.map(list.window(data,2), fn(x) { case x{ x -y }})
  let diff = list.map(list.window(data,2), fn(x) { case x{ 
            [x,y] -> x-y
            _ -> panic as "no good"}})
  // io.debug(diff)
  case diff {
      [x,..] if x > 0 -> withrec(diff, True)
      [x,..] if x < 0 -> withrec(diff, False)
      [0,..] -> False
      [_] | _ -> True
    }
  }

pub fn withrec(data, incr:Bool){
  // io.debug("withrec")
  // io.debug(data)
  // io.debug(incr)
  let r = case data{

      [0, _] | [0]-> False
      [x,_ ] if incr && x > 4 -> False
      [x,_ ] if !incr && x < -4 -> False
      [x] if incr && x < 4 -> True
      [x] if !incr && x > -4 -> True
      [_, ..rest] -> withrec(rest, incr)
       
      _ -> panic as "not matched"

    }
    // io.debug(r)

  }

pub fn process(data) -> List(Bool) {
    
    let smooth = data
    |> list.map(size_of_change)

    let single_direction =  
    data
    |> list.map(const_direction)

    list.map2(single_direction, smooth, bool.and)

}


pub fn debug(data){
    list.each(data, fn(x) {
      case size_of_change(x) && const_direction(x){
        False -> {
          io.debug(x)
          io.debug(size_of_change(x))
          io.debug(list.map(list.window(x,2), fn(x) { case x{ 
            [x,y] -> int.absolute_value(x-y)
            _ -> panic as "no good"}}))
          io.debug(" ")
          }
        _ -> "nothing" 
        }
      })
  }

pub fn test_data() -> List(List(Int)){
    "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
    |> parse_data
}

pub fn parse_data(text: String) -> List(List(Int)){
    let r: List(String)= string.replace(text, "\r\n", "\n")
    |> string.split("\n")
    // let d: List(List(String)) = 
    //return
    list.map(r, fn (x) { 
      list.filter_map(string.split(x, " "), int.parse)
    })
}

pub fn size_of_change(d: List(Int)){
    // if the largest or smallest change are within 0 and 3
    // return True

    // can we find abs diff between each pair then max them
    // list.map(list.window(d,2), int.absolute_value(int.subtract))
    let diff = list.window(d,2)
    |> list.map(fn(x) { 
      case x{
          [] -> 0
          [x,y] -> int.absolute_value(x-y )
          _ -> panic as "too many elements to diff"
        }
      })
    // |> io.debug
    // |> list.fold(0,int.max) 
    let r = #(list.fold(diff, 0, int.max),
              list.fold(diff, 999,int.min)) 
    case r {
        x if x.0 <= 3 && x.1 > 0-> True
        _ -> False
    }
  }

pub fn const_direction (d:List(Int)) -> Bool {
    // if the sequence either always increases or decreases return True

  let up = list.window(d,2)
  |> list.map(fn(x)  {
      case x{
          [x,y] -> x < y
          _ -> panic as "wrong number of elements"
        }
  })
  
  let always_up = list.all(up, fn(x) {x})
  let always_down = {list.count(up, fn(x) {x == False}) == list.length(up)}

  {always_up || always_down}
}
