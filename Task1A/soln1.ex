defmodule Task1aSumOfSubsets do
  @moduledoc """
    A module that implements functions for getting
    sum of subsets from a given 2d matrix and array of digits
    """



    @doc """
    #Function name:
           valid_sum
    #Inputs:
           matrix_of_sum   : A 2d matrix containing two digit numbers for which subsebts are to be created
    #Output:
           List of all vallid sums from the given 2d matrix
    #Details:
           Finds the valid sum values from the given 2d matrix
    #Example call:
      if given 2d matrix is as follows:
        matrix_of_sum = [
                          [21 ,"na", "na", "na", 12],
                          ["na", "na", 12, "na", "na"],
                          ["na", "na", "na", "na", "na"],
                          [17, "na", "na", "na", "na"],
                          ["na", 22, "na", "na", "na"]
                        ]

        iex(1)> matrix_of_sum = [
        ...(1)>       [21 ,"na", "na", "na", 12],
        ...(1)>       ["na", "na", 12, "na", "na"],
        ...(1)>       ["na", "na", "na", "na", "na"],
        ...(1)>       [17, "na", "na", "na", "na"],
        ...(1)>       ["na", 22, "na", "na", "na"]
        ...(1)>     ]
        iex(2)> Task1aSumOfSubsets.valid_sum(matrix_of_sum)
        [21, 12, 12, 17, 22]
    """
    def valid_sum(matrix_of_sum) do
         Enum.reduce(matrix_of_sum, [], fn(list, acc) -> acc ++ Enum.filter(list, fn(val) -> is_integer(val) end) end)
    end


    @doc """
    #Function name:
           sum_of_one
    #Inputs:
           array_of_digits : Array containing single digit numbers to satisty sum
           sum_val         : Any 2 digit value for which subsets are to be created
    #Output:
           List of list of all possible subsets
    #Details:
           Finds the all possible subsets from given array of digits for a 2 digit value
    #Example call:
      if given array of digits is as follows:
        array_of_digits = [3, 5, 2, 7, 4, 2, 3]
        and sum_val = 10

        iex(1)> array_of_digits = [3, 5, 2, 7, 4, 2, 3]
        iex(2)> Task1aSumOfSubsets.sum_of_one(array_of_digits, 10)
        [[3, 7],[3, 2, 5],[3, 2, 5],[3, 4, 3],[7, 3],[3, 2, 2, 3],[2, 5, 3],[2, 5, 3]]
    """


    def helper(_arr, _i, _set, _sum, tar, res) when tar == 0 do
         []
    end

  #   def helper(arr, i, set, sum, tar, res) when sum > tar do
  #        res
  #   end

    def helper(arr, i, set, sum, tar, res) when i == length(arr) and sum == tar do
         res = res ++ [Enum.reverse(set)]
         # IO.inspect(res)
         res
    end

    def helper(arr, i, _set, _sum, _tar, res) when i == length(arr) do

         # if Enum.sum(set) == tar do
         #        res = res ++ [set]
         #        IO.inspect(res)
         #        IO.inspect(Enum.reverse(set))
         #        # helper(arr, 0, Enum.drop(set, -1), tar, res)
         # end
         res
         # res ++ [set]
         # cond do
         #   Enum.sum(set) == tar -> res ++ [set]
         #   Enum.sum(set) != tar -> res
         # end
         # IO.inspect(["in when waala helper ", i, " --> ", res])
         # res
         # helper(arr, i, set, tar, res)
    end

    def helper(arr, i, set, sum, tar, res) do
         # IO.inspect(["At i = ", i, " set = ", set, "res = ", res])
         res = helper(arr, i+1, set ++ [Enum.at(arr, i)], sum + Enum.at(arr, i),tar, res)
         res = helper(arr, i+1, set, sum,tar, res)
         # IO.inspect([res1, res2])
         res
    end

    def sum_of_one(array_of_digits, _sum_val) when array_of_digits == [] do
         [ ]
    end

    def sum_of_one(array_of_digits, sum_val) do
         # IO.inspect(["in def", array_of_digits, "Sum_total = ", sum_val])
         # IO.inspect ["Calling helper recursion" ]
         res = helper(array_of_digits, 0, [], 0,sum_val, [])

         # IO.inspect(res)
         # IO.puts("Here")
         Enum.reverse(res)
    end


    @doc """
    #Function name:
           sum_of_all
    #Inputs:
           array_of_digits : Array containing single digit numbers to satisty sum
           matrix_of_sum   : A 2d matrix containing two digit numbers for which subsebts are to be created
    #Output:
           Map of each sum value and it's respective subsets
    #Details:
           Finds the all possible subsets from given array of digits for all valid sums elements of given 2d matrix
    #Example call:
      if given array of digits is as follows:
        array_of_digits = [3, 5, 2, 7, 4, 2, 3]
      and if given 2d matrix is as follows:
        matrix_of_sum = [
                          [21 ,"na", "na", "na", 12],
                          ["na", "na", 12, "na", "na"],
                          ["na", "na", "na", "na", "na"],
                          [17, "na", "na", "na", "na"],
                          ["na", 22, "na", "na", "na"]
                        ]

        iex(1)> array_of_digits = [3, 5, 2, 7, 4, 2, 3]
        iex(2)> matrix_of_sum = [
        ...(2)>                   [21 ,"na", "na", "na", 12],
        ...(2)>                   ["na", "na", 12, "na", "na"],
        ...(2)>                   ["na", "na", "na", "na", "na"],
        ...(2)>                   [17, "na", "na", "na", "na"],
        ...(2)>                   ["na", 22, "na", "na", "na"]
        ...(2)>                 ]
        iex(3)> Task1aSumOfSubsets.sum_of_all(array_of_digits, matrix_of_sum)
        %{
          12 => [[3, 2, 7],[3, 7, 2],[3, 4, 5],[7, 5],[3, 2, 2, 5],[3, 2, 4, 3],[2, 7, 3],[3, 4, 2, 3],[7, 2, 3],[4, 5, 3],[2, 2, 5, 3]],
          17 => [[3, 2, 7, 5],[3, 7, 2, 5],[3, 4, 7, 3],[3, 2, 7, 2, 3],[3, 2, 4, 5, 3],[2, 7, 5, 3],[3, 4, 2, 5, 3],[7, 2, 5, 3]],
          21 => [[3, 2, 4, 7, 5],[3, 4, 7, 2, 5],[3, 2, 4, 7, 2, 3],[2, 4, 7, 5, 3],[4, 7, 2, 5, 3]],
          22 => [[3, 4, 7, 5, 3], [3, 2, 7, 2, 5, 3]]
        }
    """
    def sum_of_all(array_of_digits, matrix_of_sum) do
         sum_list = valid_sum(matrix_of_sum)

         # IO.inspect(sum_list)
         # Enum.each(sum_list,
         # fn (sum) ->
         #        Map.update(res_map, "b", 1,
         #               fn (exists) -> exists
         #               end)
         # end)

         res_map = Enum.reduce(sum_list, %{}, fn (sum, acc) -> Map.update(acc, sum, sum_of_one(array_of_digits, sum), fn (e) -> e end) end)
         # IO.inspect(res_map)
         res_map
    end
  end
