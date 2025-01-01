import gleam/io
import gleam/result
import gleam/string
import gleam/int
import gleam/list
import simplifile

pub fn main() {
  io.debug("hello from day9")
  // short data
  // let input = "2333133121414131402"
  let input = get_data()
  |> parse_to_ints
  |> result.all()
  // |> io.debug

  use two <- result.map(input)
  let a = two_lists(two)

  use diskmap <- result.map(a)
  let sectors = find_ids(diskmap.0)
  // |> io.debug
  let filledholes = fill_holes(diskmap.1,sectors)
  // |> io.debug

  // expand sector data
  let newsectors = list.map(sectors, fn(x) { list.repeat(x.0,x.1)})

  // merge sectors with new holes
  let new_data = list.interleave([newsectors, filledholes])
  // |> io.debug
  |> list.flatten
  // |> result.all
  // |> io.debug


  // find length of all data on disk
  let data_length = int.sum(diskmap.0)

  let final_data = list.take(new_data, data_length)
  // |>io.debug
  //
  list.index_map(final_data, fn(x,y) {x*y})
  |> int.sum
  |>io.debug

}

/// turn sector counts into id and sector count
pub fn find_ids(sectors) {
    list.index_map(sectors, fn(data,index) {
          #(index,data)
      })
  }



// fill_holes hole_sizes sector_counts
// hole == 3 sector == 2 
// subtract the sector count from both
//
//

/// fill_holes hole_sizes sector_counts
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

type Sector = #(Int,Int)

pub type Diskmap{
    Diskmap(empty:List(Int), sectors:List(Sector))
  }

/// splits a list of ints into [size of each file] [empty space between each]
pub fn two_lists(input) {
  let lists = two_lists_rec(input, [],[])
  use disk <- result.map(lists)
  #(list.reverse(disk.0), list.reverse(disk.1))
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

  case string.pop_grapheme(string.replace(d,"\n","")){
      Ok(#(h,t)) -> [int.parse(h), ..parse_to_ints(t)]
      Error(_) ->  []
    }
  }


fn get_data() -> String {
  let filename = "data\\aoc24-d9.txt"
  case simplifile.read(filename){
      Ok(x) -> string.replace(x,"\r\n","\n")
      Error(_) -> panic as "Cannot open file"
   }

}
