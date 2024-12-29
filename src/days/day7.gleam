import gleam/io
import gleam/option.{type Option, None, Some}

pub fn main(){
    [2,3,4]
    |> all_comb(9, 0)
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
        [h,..t] -> case all_comb(t, target, h + curr){
            // the tail of this is not a solution -> None
            Some(x) -> Some(x) 
            None -> None
        }
    }
    // 2 3 4
    // 2 + failed
    case plus, d{
        // above has worked, just return
        Some(x), _ if x == target -> Some(x)
        // Plus didnt work list is empty, return None
        _ , [] -> None 
        // return Some h * rec
        _, [h,..t] if curr == 0 -> all_comb(t,target, 1 * h)
        _, [h,..t] -> case all_comb(t,target, curr * h){
            Some(x) -> Some(x)
            _ -> None
        }
    }

    // case plus, d {
    //   _, [x] -> Some(x)
    //   // plus is working for now return 
    //   Some(x), _ if x < target -> Some(x) 
    //   _, [h,..t] -> case all_comb(t,target){
    //         Some(x) if x > target -> None
    //         Some(x) -> Some( x * h )
    //         None -> None
    //     }
    //   _ , [_] -> None
      
      

      // larger than target return None
      // return h * rec

} 
