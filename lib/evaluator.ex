defmodule Evaluator do
  @type expr ::
          {:number, number()}
          | {:add, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | {:sub, expr(), expr()}
          | {:pow, expr(), expr()}

  @spec eval(expr()) :: number()
  def eval({:number, number}), do: number
  def eval({:add, a_expr, b_expr}), do: eval(a_expr) + eval(b_expr)
  def eval({:mul, a_expr, b_expr}), do: eval(a_expr) * eval(b_expr)
  def eval({:div, _a_expr, 0}), do: raise("Invalid div operation")
  def eval({:div, a_expr, b_expr}), do: eval(a_expr) / eval(b_expr)
  def eval({:sub, a_expr, b_expr}), do: sub(eval(a_expr), eval(b_expr))
  def eval({:pow, a_expr, b_expr}), do: pow(eval(a_expr), eval(b_expr))
  def eval(_invalid_expr), do: raise("Invalid expression")

  def sub(a_number, b_number) when b_number < 0, do: a_number + b_number
  def sub(a_number, b_number), do: a_number - b_number

  def pow(a_number, b_number)
      when is_integer(a_number) and is_integer(b_number) and a_number >= 0 and b_number >= 0,
      do: Integer.pow(a_number, b_number)

  def pow(a_number, b_number) do
    a_number_float = a_number / 1
    b_number_float = b_number / 1
    Float.pow(a_number_float, b_number_float)
  end
end
