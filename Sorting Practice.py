import random

def genRandom(data):
    for a in range(0,20):
        n = random.randint(1,50)
        data.append(n) 
    return data  


#Quicksort Method

#Selection Sort

def selectionSort(data):
    for i in range(len(data)):
        minIndx = i
        for j in range(i + 1, len(data)):
            if data[minIndx] > data[j]:
                minIndx = j
        (data[i], data[minIndx]) = (data[minIndx], data[i])
    return data

data = []
genRandom(data)
print("Unsorted: ", data)
selectionSort(data)
print("Sorted: ", data)

