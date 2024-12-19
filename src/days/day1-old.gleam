import gleam/result
import gleam/int
import gleam/io
import gleam/list
import simplifile.{read}
import gleam/string
import days/day1
import days/day2


fn day1solution(){

  parse_file()
  // |> io.debug()
  // |> take_two([],[])
  // |> list.map(list.length)
  // list.map(dlists, sort_int)
  // |> list.sort(by:int.compare)
  // |> list.map(list.length)
  // |> io.debug()
  // |> apply_first_two(cmp_two_lists)
  // |> int.sum
  // |> io.debug()

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
      [_] -> panic as "list must be not odd length"
    }
  }

fn parse_file() {
  // parses input file into a flat list of integers
  let filename = "aoc24-d1.txt"
  // result.unwrap(read(from:filename), "File not found")
  
  let pairs = read(from:filename)
  |> result.unwrap("File not found")
  |> string.split("\r\n")
  // |> list.map(fn(a) {string.split(a,"   ")}) // best to use filter_map as it wont return Errors
  |> list.filter_map(split_parse)
  // not needed due to filter_map
  let #(a,b) = pairs |> list.unzip

  let k =  list.map([a,b], list.sort(_,by:int.compare))
  |> list.split(1) // make a list of lists into a tuple of lists
  // |> io.debug
  let k = #(list.flatten(k.0), list.flatten(k.1))

  list.map2(k.0,k.1, fn(x,y) {int.absolute_value(x-y)})
  |> int.sum
  |> io.debug
  // |> list.map() 
  // |> list.flatten
  // |> list.reverse
  // |> list.rest
  // |> result.unwrap(["a"])
  // |> list.reverse
  // |> list.map(fn(x){result.unwrap( int.parse(x), 0 )})
}


fn abs_diff(a:Int,b) {
    int.absolute_value(a-b)
  }

fn split_parse(data:String)  -> Result(#(Int,Int),Nil){
  use #(a,b) <- result.try(string.split_once(data, on:"   "))
  use inta <- result.try(int.parse(a))
  use intb <- result.try(int.parse(b))
  Ok(#(inta,intb))
}

fn understand_try(a:Result(String, Nil)) -> Result(Int,Nil){
  // take a result do something with the data and return a result
  result.try(a, int.parse)
  // try(Aresult, fnthatcanfail)
}

fn understand_use(a:Result(String, Nil)) -> Result(Int,Nil){
  
  // use a <- result.try(simpleparse(a))
  // Ok(a)
  result.try(a, simpleparse)

  // use k <- result.try(a, simpleparse) 
}

fn simpleparse(a:String) -> Result(Int,Nil){
    Ok(1)
  }


// this is an anti-pattern
fn fix(a) {
  let assert Ok(z) = a
  z
}


fn compare(a,b) -> Int{
  // sort the lists
  // compare
  3
}

