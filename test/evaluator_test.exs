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
      check all(int1 <- integer(), int2 <- integer(), mul = int1 * int2) do
        assert Evaluator.eval({:mul, {:number, int1}, {:number, int2}}) == mul
      end
    end

    test "with another expressions" do
      check all(
              int_list <- list_of(integer(-1000..1000), length: 4),
              [int1, int2, int3, int4] = int_list,
              result = int1 * int2 * (int3 + int4)
            ) do
        assert Evaluator.eval(
                 {:mul, {:mul, {:number, int1}, {:number, int2}},
                  {:add, {:number, int3}, {:number, int4}}}
               ) == result
      end
    end
  end

  describe "eval/1 with div expression" do
    test "with basic positive numbers expression" do
      check all(int1 <- integer(0..10000), int2 <- integer(0..10000), div = int1 / int2) do
        assert Evaluator.eval({:div, {:number, int1}, {:number, int2}}) == div
      end
    end

    test "with basic negative numbers expression" do
      check all(int1 <- integer(-10000..0), int2 <- integer(-10000..0), div = int1 / int2) do
        assert Evaluator.eval({:div, {:number, int1}, {:number, int2}}) == div
      end
    end

    test "with basic positive and negative numbers expression" do
      check all(int1 <- integer(-1000..1000), int2 <- integer(-1000..1000), div = int1 / int2) do
        assert Evaluator.eval({:div, {:number, int1}, {:number, int2}}) == div
      end
    end

    test "with another expressions" do
      check all(
              int_list <- list_of(integer(-1000..1000), length: 4),
              [int1, int2, int3, int4] = int_list,
              result = (int1 + int2) / (int3 * int4)
            ) do
        assert Evaluator.eval(
                 {:div, {:add, {:number, int1}, {:number, int2}},
                  {:mul, {:number, int3}, {:number, int4}}}
               ) == result
      end
    end
  end

  describe "eval/1 with sub expression" do
    test "with basic positive integers number expression" do
      check all(int1 <- integer(0..10000), int2 <- integer(0..10000), sub = int1 - int2) do
        assert Evaluator.eval({:sub, {:number, int1}, {:number, int2}}) == sub
      end
    end

    test "with second expression returning positive number" do
      check all(int1 <- integer(1000..1000), int2 <- integer(1000..1000), sub = int1 - int2) do
        assert Evaluator.eval({:sub, {:number, int1}, {:number, int2}}) == sub
      end
    end

    test "with second expression returning negative number" do
      check all(int1 <- integer(1000..1000), int2 <- integer(-10000..0), sub = int1 + int2) do
        assert Evaluator.eval({:sub, {:number, int1}, {:number, int2}}) == sub
      end
    end

    test "with another expressions" do
      check all(
              int_list <- list_of(integer(-1000..1000), length: 4),
              [int1, int2, int3, int4] = int_list,
              expected_operation = if(int3 + int4 < 0, do: &Kernel.+/2, else: &Kernel.-/2),
              result = expected_operation.(int1 * int2, int3 + int4)
            ) do
        assert Evaluator.eval(
                 {:sub, {:mul, {:number, int1}, {:number, int2}},
                  {:add, {:number, int3}, {:number, int4}}}
               ) == result
      end
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
