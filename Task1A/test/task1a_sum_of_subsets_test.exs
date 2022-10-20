defmodule Task1aSumOfSubsetsTest do
  use ExUnit.Case
  doctest Task1aSumOfSubsets

  #checking condition 1 for valid subset
  def checkForSum(solution,val) do
    Enum.each(solution, fn list_sum -> assert Enum.sum(list_sum) == val end)
  end

  #checking condition 2 for valid subset
  def checkForCount(solution,array_of_digits) do
    list = Enum.to_list(1..9)
    list_of_sub_list = Enum.map(solution, fn sub_list -> Enum.map(list, fn val -> {val, Enum.count(sub_list, fn val_in -> val == val_in end)} end) end)
    list_of_check_list = Enum.map(list, fn val -> {val, Enum.count(array_of_digits, fn val_in -> val == val_in end)} end)
    Enum.map(list_of_sub_list, fn sub_list_count -> Enum.map(list, fn index -> assert Enum.at(list_of_check_list, index-1) >= Enum.at(sub_list_count, index-1) end) end)
  end

  #checking condition 2 for valid solution
  def checkForExistenceOfAllUnique(solution,expected_solution) do
    list = Enum.to_list(1..9)
    list_of_sub_list = Enum.map(solution, fn sub_list -> Enum.map(list, fn val -> Enum.count(sub_list, fn val_in -> val == val_in end) end) end)
    uniq_stud_sol= Enum.uniq(list_of_sub_list)

    list_of_sub_list1= Enum.map(expected_solution, fn sub_list -> Enum.map(list, fn val -> Enum.count(sub_list, fn val_in -> val == val_in end) end) end)
    uniq_exp_sol=Enum.uniq(list_of_sub_list1)

    results= Enum.map(uniq_exp_sol,fn list -> Enum.any?(uniq_stud_sol,&(list == &1)) end)

    assert(Enum.all?(results, &(true == &1))," One of the expected subset is not found in your solution ")
  end

  def checkThreeCondtions(solution,val,array_of_digits,expected_solution) do
    checkForSum(solution,val)
    checkForCount(solution,array_of_digits)
    checkForExistenceOfAllUnique(solution,expected_solution)
  end



  test "check valid sum for the given matrix" do
    matrix_of_sum = [
      [21 ,"na", "na", "na", 12],
      ["na", "na", 12, "na", "na"],
      ["na", "na", "na", "na", "na"],
      [17, "na", "na", "na", "na"],
      ["na", 22, "na", "na", "na"]
    ]
    expected_list_of_valid_sums = [21, 12, 12, 17, 22]
    assert Task1aSumOfSubsets.valid_sum(matrix_of_sum) == expected_list_of_valid_sums
  end

  test "check valid sum for an empty matrix" do
    matrix_of_sum = [ [] ]
    expected_list_of_valid_sums = []
    assert Task1aSumOfSubsets.valid_sum(matrix_of_sum) == expected_list_of_valid_sums
  end

  test "check the expected sum of subsets of matrix for given array" do
    array_of_digits = [3, 5, 2, 7, 4, 2, 3]


    #Getting "sum_of_one" from the solution function
    sum_of_one_matrix = Task1aSumOfSubsets.sum_of_one(array_of_digits, 10)

    #Checking if the sum of each list is 10 or not
    Enum.each(sum_of_one_matrix, fn list_sum -> assert Enum.sum(list_sum) == 10 end)

  end


  test "check if the occurences of the numbers in the subset are less than equal to the occurences in array_of_digits" do
    array_of_digits = [3, 5, 2, 7, 4, 2, 3]

    #Getting "sum_of_one" from the solution function
    sum_of_one_matrix = Task1aSumOfSubsets.sum_of_one(array_of_digits, 10)

    #Checking if the count of each element of lists
    list = Enum.to_list(1..9)
    list_of_sub_list = Enum.map(sum_of_one_matrix, fn sub_list -> Enum.map(list, fn val -> {val, Enum.count(sub_list, fn val_in -> val == val_in end)} end) end)
    list_of_check_list = Enum.map(list, fn val -> {val, Enum.count(array_of_digits, fn val_in -> val == val_in end)} end)
    Enum.map(list_of_sub_list, fn sub_list_count -> Enum.map(list, fn index -> assert Enum.at(list_of_check_list, index-1) >= Enum.at(sub_list_count, index-1) end) end)

  end

  test "check if the all unique entries are available in solution" do
    array_of_digits = [3, 5, 2, 7, 4, 2, 3]

    #Getting "sum_of_one" from the solution function
    sum_of_one_matrix = Task1aSumOfSubsets.sum_of_one(array_of_digits, 10)

    #Checking if the count of each element of lists
    list = Enum.to_list(1..9)
    list_of_sub_list = Enum.map(sum_of_one_matrix, fn sub_list -> Enum.map(list, fn val -> {val, Enum.count(sub_list, fn val_in -> val == val_in end)} end) end)
    assert Enum.count(Enum.uniq(list_of_sub_list)) == 4

  end

  test "check the expected sum of subsets of matrix for sum as 0" do
    array_of_digits = [0, 3, 5, 2, 7, 4, 2, 3]
    expected_sum_of_one_matrix = [ ]
    assert Task1aSumOfSubsets.sum_of_one(array_of_digits, 0) == expected_sum_of_one_matrix
  end

  test "check the expected sum of subsets of matrix for array containing no element" do
    array_of_digits = []
    expected_sum_of_one_matrix = [ ]
    assert Task1aSumOfSubsets.sum_of_one(array_of_digits, 10) == expected_sum_of_one_matrix
  end

  test "check all expected sum of subsets for given array and matrix of sum" do
    matrix_of_sum = [
      [21 ,"na", "na", "na", 12],
      ["na", "na", 12, "na", "na"],
      ["na", "na", "na", "na", "na"],
      [17, "na", "na", "na", "na"],
      ["na", 22, "na", "na", "na"]
    ]
    array_of_digits = [3, 5, 2, 7, 4, 2, 3]
    expected_sum_of_all_matrix = %{
      12 => [
        [3, 7, 2],
        [3, 4, 5],
        [7, 5],
        [3, 2, 2, 5],
        [3, 2, 4, 3],
        [2, 7, 3],
        [3, 4, 2, 3],
        [7, 2, 3],
        [4, 5, 3],
        [2, 2, 5, 3]
      ],
      17 => [
        [3, 2, 7, 5],
        [3, 7, 2, 5],
        [3, 4, 7, 3],
        [3, 2, 7, 2, 3],
        [3, 2, 4, 5, 3],
        [2, 7, 5, 3],
        [3, 4, 2, 5, 3],
        [7, 2, 5, 3]
      ],
      21 => [
        [3, 2, 4, 7, 5],
        [3, 4, 7, 2, 5],
        [3, 2, 4, 7, 2, 3],
        [2, 4, 7, 5, 3],
        [4, 7, 2, 5, 3]
      ],
      22 => [[3, 4, 7, 5, 3], [3, 2, 7, 2, 5, 3]]
    }

    sum_of_all_result= Task1aSumOfSubsets.sum_of_all(array_of_digits, matrix_of_sum)



    Enum.map(expected_sum_of_all_matrix,  fn ({k, v}) -> checkThreeCondtions(sum_of_all_result[k],k,array_of_digits,v) end)



  end

  test "checks all the expected sum of subsets for given array with one element as zero and matrix of sum" do
    matrix_of_sum = [
      [21 ,"na", "na", "na", 12],
      ["na", "na", 12, "na", "na"],
      ["na", "na", "na", "na", "na"],
      [17, "na", "na", "na", "na"],
      ["na", 22, "na", "na", "na"]
    ]
    array_of_digits = [0, 3, 5, 2, 7, 4, 2, 3]
    expected_sum_of_all_matrix = %{
      12 => [
        [3, 2, 7],
        [3, 7, 2],
        [3, 4, 5],
        [7, 5],
        [3, 2, 2, 5],
        [3, 2, 4, 3],
        [2, 7, 3],
        [3, 4, 2, 3],
        [7, 2, 3],
        [4, 5, 3],
        [2, 2, 5, 3]
      ],
      17 => [
        [3, 2, 7, 5],
        [3, 7, 2, 5],
        [3, 4, 7, 3],
        [3, 2, 7, 2, 3],
        [3, 2, 4, 5, 3],
        [2, 7, 5, 3],
        [3, 4, 2, 5, 3],
        [7, 2, 5, 3]
      ],
      21 => [
        [3, 2, 4, 7, 5],
        [3, 4, 7, 2, 5],
        [3, 2, 4, 7, 2, 3],
        [2, 4, 7, 5, 3],
        [4, 7, 2, 5, 3]
      ],
      22 => [[3, 4, 7, 5, 3], [3, 2, 7, 2, 5, 3]]
    }
    sum_of_all_result= Task1aSumOfSubsets.sum_of_all(array_of_digits, matrix_of_sum)

    Enum.map(expected_sum_of_all_matrix,  fn ({k, v}) -> checkThreeCondtions(sum_of_all_result[k], k , array_of_digits,v) end)

  end
end
