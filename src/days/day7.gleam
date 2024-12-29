import gleam/int
import gleam/string
import gleam/io
import gleam/list
import gleam/result
import gleam/option.{type Option, None, Some}

pub fn main(){
    [2,3,4]
    |> all_comb(9, 0)

    "1234: 1 2 3 4\r\n222: 3 4 5s"
    |> parse_text
    |> io.debug
  }

pub fn try_comb (d:List(Int), target:Int) -> Option(Int){
  case all_comb(d,target, 0) {
      Some(x) if x == target -> Some(x)
      _ -> None
    }
}

pub fn all_comb(d:List(Int), target:Int, curr:Int) -> Option(Int){
    let plus = case d{
        [] if curr == target -> Some(curr)
        [] -> None
        // return Some h + rec
        [h,..t] -> all_comb(t, target, h + curr)
    }
    case plus, d{
        // above has worked, just return
        Some(x), _ if x == target -> Some(x)
        // Plus didnt work list is empty, return None
        _ , [] -> None 
        // special case for first number in list
        _, [h,..t] if curr == 0 -> all_comb(t,target, 1 * h)
        _, [h,..t] -> all_comb(t,target, curr * h) 
    }
}


fn parse_int_list(d:String) {
    string.trim(d)
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all
  }

fn make_element(d:#(String, String) ){
  case d{
    #(a,b) -> case int.parse(a), parse_int_list(b){
      Ok(x), Ok(y) -> Ok(#(x,y))
      Error(x),_ -> Error(x)
      _, Error(y) -> Error(y)
    }
  }
}
 

fn parse_text(d:String){
    let r = string.replace(d,"\r\n","\n")
    |> string.split("\n")
    |> list.map(string.split_once(_,":") )
    // if all splits were good
    |> result.all
    |> result.map(list.map(_,make_element))
    |> result.try(fn(x) {
       result.all(x)
    })

    // |> result.map(fn(x) {
    //   case x{
    //       Ok(a) -> result.all(a)
    //       Error(e) -> Error(e)
    //     }

    // })
    // |> io.debug
}
