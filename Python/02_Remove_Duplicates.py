def remove_duplicates(s):
    result = ""
    for ch in s:
        if ch not in result:
            result += ch
    return result
strd=input("Enter a string: ")
print(remove_duplicates(strd))  