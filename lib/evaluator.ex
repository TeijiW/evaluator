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
  def eval({:div, _a_expr, 0}), do: raise("Invalid div operation")

  def eval({operation, a_expr, b_expr}),
    do: handle_operation_function(operation).(eval(a_expr), eval(b_expr))

  def eval(_invalid_expr), do: raise("Invalid expression")

  defp handle_operation_function(:add), do: &Kernel.+/2
  defp handle_operation_function(:mul), do: &Kernel.*/2
  defp handle_operation_function(:div), do: &Kernel.//2
  defp handle_operation_function(:sub), do: &sub/2
  defp handle_operation_function(:pow), do: &pow/2
  defp handle_operation_function(_invalid_operation), do: raise("Invalid expression")

  defp sub(a_number, b_number) when b_number < 0, do: a_number + b_number
  defp sub(a_number, b_number), do: a_number - b_number

  def pow(a_number, b_number)
      when is_integer(a_number) and is_integer(b_number) and a_number >= 0 and b_number >= 0,
      do: Integer.pow(a_number, b_number)

  def pow(a_number, b_number) do
    a_number_float = a_number / 1
    b_number_float = b_number / 1
    Float.pow(a_number_float, b_number_float)
  end
end
