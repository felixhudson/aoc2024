import gleam/io
import gleam/result
import gleam/string
import gleam/int
import gleam/list

pub fn main() {
  let input = "2333133121414131402"
  |> parse_to_ints
  |> result.all()
 
  use two <- result.map(input)
  two_lists(two)
  |> io.debug
}

// fill_holes hole_sizes sector_counts
// hole == 3 sector == 2 
// subtract the sector count from both
//
//

pub fn fill_holes(holes, sectors){
    fill_holes_rec(holes, list.reverse( sectors ), [],[],0)
    |> list.map(list.reverse)
    |> list.reverse
  }


// I am confusing hole sizes with sectors
// holes = #(id, size) sectors = #(id, size)
pub fn fill_holes_rec(holes:List(Int), sectors:List(#(Int,Int)), acc:List(List(Int)), curr:List(Int), count){
    let _readme = " the idea here is that we know how large each hole is.
                  make a list of ids to fill the hole"
    case holes, sectors, curr{
        // our accumulated block is now the right size for the hole  add the
        // curr into the acc reset the count
        [h,..t], y, _  if count == h -> fill_holes_rec(t, y, [curr,..acc], [], 0) 
        //[#(id,h),..t], [#(secid,s),..others]  if count == h -> fill_holes_rec(t, [s-1,..others], [curr,..acc], [], 0) 
        // if our sector is exhausted move to next sector
        x , [#(_id,0),..others], _  -> fill_holes_rec(x, others, acc, curr, count) 
        // if we have space free, move a secid in
        _ , [#(secid,s),..others], _ -> fill_holes_rec(holes, [#(secid,s-1),..others], acc, [secid, ..curr], count +1) 
        // run out of holes: return the acc with the curr
        [] , _, []  -> acc 
        [] , _, _clist  -> [curr, ..acc]
        _, [], _ -> panic as "run out of sectors"
        // _,_ -> {io.debug(#(holes, sectors, acc, curr,count)) panic as todo}

      }
  }




pub fn two_lists(input){
  two_lists_rec(input, [],[])
}

fn two_lists_rec(d:List(Int),a,b){
    case d{
        [x,y,..rest] -> two_lists_rec(rest,[x,..a],[y,..b])
        // last sector of disk we dont care about free space
        [one] -> Ok(#([one,..a],[0,..b])) 
        [] -> Error("list needs to be odd length") 
      }
  }


pub fn parse_to_ints(d:String) -> List(Result(Int,Nil)){
  case string.pop_grapheme(d){
      Ok(#(h,t)) -> [int.parse(h), ..parse_to_ints(t)]
      Error(_) ->  []
    }
  }
