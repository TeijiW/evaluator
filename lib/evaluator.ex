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
  def eval({:div, a_expr, b_expr}), do: eval(a_expr) / eval(b_expr)
  def eval({:sub, a_expr, b_expr}), do: eval(a_expr) - eval(b_expr)
  def eval({:pow, a_expr, b_expr}), do: :math.pow(eval(a_expr), eval(b_expr))
  def eval(_invalid_expr), do: raise("Invalid expression")
end
