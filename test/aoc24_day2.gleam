import gleeunit
import gleeunit/should
import days/day2

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn smooth_test() {
    day2.size_of_change([7,6,4,2,1])
    |> should.equal(True)
    day2.size_of_change([1,2,7,8,9])
    |> should.equal(False)
    day2.size_of_change([9,7,6,2,1])
    |> should.equal(False)

    day2.size_of_change([1,3,2,4,5])
    |> should.equal(True)
    day2.size_of_change([8,6,4,4,1])
    |> should.equal(False)
    day2.size_of_change([1,3,6,7,9])
    |> should.equal(True)

  }
pub fn up_down_test() {
    day2.const_direction([7,6,4,2,1])
    |> should.equal(True)
    day2.const_direction([1,2,7,8,9])
    |> should.equal(True)
    day2.const_direction([9,7,6,2,1])
    |> should.equal(True)

    day2.const_direction([1,3,2,4,5])
    |> should.equal(False)
    day2.const_direction([8,6,4,4,1])
    |> should.equal(True)
    day2.const_direction([1,3,6,7,9])
    |> should.equal(True)

  }

pub fn direction_test(){
    day2.const_direction([1,2,5,4,6])
    |> should.equal(False)
    day2.const_direction([1,2,5,3,1])
    |> should.equal(False)
    day2.const_direction([1,2,3,4,5])
    |> should.equal(True)
  }

pub fn single_test(){
    day2.investigate([1,2,5,4,6])
    |> should.equal(False)

  }

pub fn rec_test(){
    day2.investigate([7,6,4,2,1])
    |> should.equal(True)
    day2.investigate([1,2,7,8,9])
    |> should.equal(False)
    day2.investigate([9,7,6,2,1])
    |> should.equal(False)

    day2.investigate([1,3,2,4,5])
    |> should.equal(False)
    day2.investigate([8,6,4,4,1])
    |> should.equal(False)
    day2.investigate([1,3,6,7,9])
    |> should.equal(True)

    // day2.setuprec([1,2,5,4,6])
    // |> should.equal(False)
    // day2.setuprec([1,2,5,3,1])
    // |> should.equal(False)
    // day2.setuprec([1,2,3,4,5])
    // |> should.equal(True)
  }

