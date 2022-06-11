defmodule EvaluatorTest do
  use ExUnit.Case
  doctest Evaluator
  alias Evaluator

  test "eval/1 with number expression" do
    assert 5 == Evaluator.eval({:number, 5})
  end

  describe "eval/1 with add expression" do
    test "with basic number expression" do
      assert 2 == Evaluator.eval({:add, {:number, 1}, {:number, 1}})
    end

    test "with another expressions" do
      assert 10 ==
               Evaluator.eval(
                 {:add, {:add, {:number, 1}, {:number, 3}}, {:add, {:number, 3}, {:number, 3}}}
               )
    end
  end
end
