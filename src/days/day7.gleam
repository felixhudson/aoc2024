import gleam/io
import gleam/option.{type Option, None, Some}

pub fn main(){
    [2,3,4]
    |> all_comb(9)
  }

pub fn all_comb(d:List(Int), target:Int) -> Option(Int){
    let plus = case d{
        [x] -> Some(x)
        // return Some h + rec
        [h,..t] -> case all_comb(t,target){
            Some(x) if x > target -> None // not sure if I need this, shouldnt the recursive call deal with it?
            Some(x) -> Some(h + x)
            None -> None
        }
        _ -> panic as "not reachable"
    }

    let mult = case d{
        [x] -> Some(x)
        // return Some h * rec
        [h,..t] -> case all_comb(t,target){
            Some(x) if x > target -> None // not sure if I need this, shouldnt the recursive call deal with it?
            Some(x) -> Some(h * x)
            None -> None
        }
        _ -> panic as "not reachable"
    }

    case plus, mult {
        Some(x), _ if x == target -> Some(x)
        _ , Some(x) -> Some(x)
        _ , _ -> panic as "nothing worked"
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
