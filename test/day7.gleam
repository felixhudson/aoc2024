import gleam/option.{Some,None}
import gleeunit
import gleeunit/should
import days/day7


pub fn main(){
    gleeunit.main()
  }


pub fn q_test(){
    True|> should.be_true
  }

pub fn comb_test(){
    [1,2]
    |> day7.all_comb(3)
    |> should.equal(Some(3))

    [1,2]
    |> day7.all_comb(2)
    |> should.equal(Some(2))
  }
