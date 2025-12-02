
def convert_minutes(n):
    hrs = n // 60
    mins = n % 60
    return f"{hrs} hr{'s' if hrs != 1 else ''} {mins} minutes"
tmins=int(input("Enter minutes to convert: "))
print(convert_minutes(tmins))  



