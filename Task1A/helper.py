def sum_of_subsets(arr, i, set, sos, tar, res):
    # print(arr, i, set, sos, tar, type(set))
    if i == len(arr):
        if sos == tar:
            print("set", set)
            res.append(set)
        print(f"i before return {i}")
        return
    # print(type(str(arr[0])))
    sum_of_subsets(arr, i+1, set, sos, tar, res)
    if(res != []):
        print(f"i after return {i} in included")
    sum_of_subsets(arr, i+1, set + [arr[i]], sos + arr[i], tar, res)
    if(res != []):
        print(f"i after return {i} in not included")

    return res

if __name__ == "__main__":
    arr = [3, 5, 2, 7, 4, 2, 3]
    tar = 10
    a = sum_of_subsets(arr, 0, [], 0, tar, [])
    print("a", a)