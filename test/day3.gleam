import gleam/list
import gleam/string
import gleam/io
import gleeunit
import gleeunit/should
import days/day3alt

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn token_test() {
  let r = "mul(123,234)"
  |> string.to_graphemes()
  |> day3alt.tokenizer()

  r
  |> list.first
  |> should.equal(Ok(day3alt.Start))

  r
  |> list.contains(day3alt.End)
  |> should.be_true
  
  r
  |> list.contains(day3alt.Digits("4"))
  |> should.be_true

}

pub fn combine_digits_test() {
  let r = 
  "mul(123,234)"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()

  r|> list.contains(day3alt.Digits("123")) |> should.be_true
  r|> list.contains(day3alt.Digits("234")) |> should.be_true
}
pub fn parse_test() {
  "mul(123,234)"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(123*234)


  "mul(3,4)mul(2,1)"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(14)

  "mul(3,4)mul(2,1!)"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(12)
}

pub fn aoc_test(){

  "xmul(2,4)%&mul[3,7]!@^"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(8)

  "do_not_mul(5,5)+"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(25)

  "mul(32,64]then(mul(11,8)mul(8,5))"
  |> string.to_graphemes()
  |> day3alt.tokenizer()
  |> day3alt.combine_digits()
  |> day3alt.parse_good
  |> should.equal(88 + 40)
  
}
