import gleam/option.{Some}
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
    |> day7.all_comb(3,0)
    |> should.equal(Some(3))

    [1,2]
    |> day7.all_comb(2,0)
    |> should.equal(Some(2))

    [1,2]
    |> day7.all_comb(4,0)
    |> should.not_equal(Some(4))

    [2,3,4]
    |> day7.all_comb(9,0)
    |> should.equal(Some(9))

    //2 * 3 + 4 == 10
    [2,3,4]
    |> day7.all_comb(10,0)
    |> should.equal(Some(10))
  }

pub fn short_test(){
    [10,19]
    |> day7.try_comb(190)
    |> should.be_some

    [81, 40, 27]
    |> day7.try_comb(3267)
    |> should.be_some

    [17,5]
    |> day7.try_comb(83)
    |> should.be_none

    [15,6]
    |> day7.try_comb(156)
    |> should.be_none

    [6,8,6,15]
    |> day7.try_comb(7290)
    |> should.be_none

    [16,10,13]
    |> day7.try_comb(161011)
    |> should.be_none
  }
