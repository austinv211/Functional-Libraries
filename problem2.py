# Name: problem2.py
# Author: Austin Vargason
# Description: Implementing problem 2 Haskell code in Python

from typing import TypeVar, List, Callable, Any, Iterable
from pyrsistent import pvector
from toolz import flip, compose, curry, concat
from functools import wraps
from itertools import cycle
import operator

#type variables
A = TypeVar('A')
B = TypeVar('B')
C = TypeVar('C')

#necessary prereq functions
# zipWith function in python
# zipWith takes a function and 2 lists and zips the list using the operation provided
@curry
def myZipWith(f: Callable[[Any, Any], Any], listA: List[Any], listB: List[Any]) -> List[Any]:
    """Return two lists added together
    >>> listA = [1, 2, 3, 4, 5]
    >>> listB = [6, 7, 8, 9, 10]
    >>> myZipWith(operator.add, listA, listB)
    [7, 9, 11, 13, 15]
    """
    return [(f(x[0],x[1])) for x in zip(listA, listB)]
    #alternative
    #return list(map(f, zip(listA, listB)))

#
def reverse(values: List[int]) -> List[int]:
    return values[::-1]

# toDigit function
def toDigit(digit: str) -> int:
    return int(digit)

# to Digits function
@curry
def toDigits(n: int) -> Iterable[int]:
    return pvector(map(toDigit, str(n)))

# doubleEveryOther function
@curry
def doubleEveryOther(values: Iterable[int]) -> Iterable[int]:
    return compose(myZipWith(operator.mul, cycle([1, 2])), reverse)(values)

# sumDigits function
@curry
def sumDigits(values: Iterable[int]) -> int:
    curryMap = curry(map)
    return compose(sum, concat, curryMap(toDigits))(values)

#checkSum function
@curry
def checkSum(n: int) -> int:
    return compose(sumDigits, doubleEveryOther, toDigits)(n)

#isValid function
@curry
def isValid(n: int) -> bool:
    curryEquals = curry(operator.eq)
    curryMod = curry(operator.mod)
    return compose(curryEquals(0), flip(curryMod, 10), checkSum)(n)

# myFlip function
def myFlip(f: Callable[[A, B], C]) -> Callable[[B, A], C]:
    @wraps(f)
    def newF(*args):
        return f(*args[::-1])
    return newF

# testCC function
def testCC() -> Iterable[bool]:
    return list(map(isValid, [1234567890123456, 1234567890123452]))


if __name__ == "__main__":
    print(testCC())
