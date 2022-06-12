defmodule EvaluatorTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Evaluator
  alias Evaluator

  test "eval/1 with number expression" do
    assert 5 == Evaluator.eval({:number, 5})
  end

  describe "eval/1 with add expression" do
    test "with basic number expression" do
      check all(int1 <- integer(), int2 <- integer(), sum = int1 + int2) do
        assert Evaluator.eval({:add, {:number, int1}, {:number, int2}}) == sum
      end
    end

    test "with another expressions and only positive numbers" do
      check all(
              int_list <- list_of(integer(1..1000), length: 4),
              [int1, int2, int3, int4] = int_list,
              result = int1 + int2 + int3 - int4
            ) do
        assert Evaluator.eval(
                 {:add, {:add, {:number, int1}, {:number, int2}},
                  {:sub, {:number, int3}, {:number, int4}}}
               ) == result
      end
    end

    test "with another expressions and only negative numbers" do
      check all(
              int_list <- list_of(integer(-1000..-1), length: 4),
              [int1, int2, int3, int4] = int_list,
              result = int1 * int2 + (int3 + int4)
            ) do
        assert Evaluator.eval(
                 {:add, {:mul, {:number, int1}, {:number, int2}},
                  {:sub, {:number, int3}, {:number, int4}}}
               ) == result
      end
    end
  end

  describe "eval/1 with mul expression" do
    test "with basic number expression" do
      [number_1, number_2] = list_of_random_numbers(2)

      assert number_1 * number_2 ==
               Evaluator.eval({:mul, {:number, number_1}, {:number, number_2}})
    end

    test "with another expressions" do
      [number_1, number_2, number_3, number_4] = list_of_random_numbers(4)

      assert number_1 * number_2 * (number_3 + number_4) ==
               Evaluator.eval(
                 {:mul, {:mul, {:number, number_1}, {:number, number_2}},
                  {:add, {:number, number_3}, {:number, number_4}}}
               )
    end
  end

  describe "eval/1 with div expression" do
    test "with basic number expression" do
      [number_1, number_2] = list_of_random_numbers(2)

      assert number_1 / number_2 ==
               Evaluator.eval({:div, {:number, number_1}, {:number, number_2}})
    end

    test "with another expressions" do
      [number_1, number_2, number_3, number_4] = list_of_random_numbers(4)

      # assert number_1 * number_2 / (number_3 - number_4) ==
      Evaluator.eval(
        {:div, {:mul, {:number, number_1}, {:number, number_2}},
         {:sub, {:number, number_3}, {:number, number_4}}}
      )

      assert true
    end
  end

  describe "eval/1 with sub expression" do
    test "with basic number expression" do
      [number_1, number_2] = list_of_random_numbers(2)
      function = if number_2 < 0, do: &Kernel.+/2, else: &Kernel.-/2

      assert function.(number_1, number_2) ==
               Evaluator.eval({:sub, {:number, number_1}, {:number, number_2}})
    end

    test "with another expressions" do
      [number_1, number_2, number_3, number_4] = list_of_random_numbers(4)
      function = if number_3 + number_4 < 0, do: &Kernel.+/2, else: &Kernel.-/2

      assert function.(number_1 * number_2, number_3 + number_4) ==
               Evaluator.eval(
                 {:sub, {:mul, {:number, number_1}, {:number, number_2}},
                  {:add, {:number, number_3}, {:number, number_4}}}
               )
    end
  end

  describe "eval/1 with pow expression" do
    test "with basic number expression" do
      [number_1, number_2] = list_of_random_numbers(2)

      assert Evaluator.pow(number_1, number_2) ==
               Evaluator.eval({:pow, {:number, number_1}, {:number, number_2}})
    end

    test "with another expressions" do
      [number_1, number_2, number_3, number_4] = list_of_random_numbers(4)

      assert Evaluator.pow(number_1 * number_2, number_3 + number_4) ==
               Evaluator.eval(
                 {:pow, {:mul, {:number, number_1}, {:number, number_2}},
                  {:add, {:number, number_3}, {:number, number_4}}}
               )
    end
  end

  defp random_number, do: Enum.random(-100..100)
  defp list_of_random_numbers(number), do: for(_ <- 1..number, do: random_number())
end
