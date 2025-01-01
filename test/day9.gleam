import gleeunit
import gleeunit/should
import days/day9


pub fn main() {
    gleeunit.main()
  }

pub fn twolist_test(){
  [1,8,2,8,3,8,4]
  |> day9.two_lists
  |> should.be_ok
  |> should.equal(#([1,2,3,4],[8,8,8,0]))

  }

pub fn fill_test(){
    day9.fill_holes_rec([1],[#(11,1)],[],[],0)
    |> should.equal([ [11] ])

    // note that the rec function returns data in backwards order
    day9.fill_holes_rec([2],[#(11,1), #(22,1)],[],[],0)
    |> should.equal([ [22,11] ])

    day9.fill_holes_rec([1,1],[#(11,1), #(22,1)],[],[],0)
    |> should.equal([ [22],[11] ])

  }
pub fn tricky_fill_test(){
    day9.fill_holes([1,3,2],[#(11,4),#(33,2)])
    |> should.equal([ [33],[33,11,11], [11,11]])
}
