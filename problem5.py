from typing import Iterable, Tuple, List, NewType, TypeVar, Callable, Any
from functools import reduce
import operator

# prereq functions
# myFoldl function
def myFoldl(f: Callable[[Any, Any], Any], accInit: Any, values: List[Any]) -> Any:
    """foldl using 10 as our initializer and add the numbers in the list
    >>> myFoldl(operator.add, 10, [1, 2, 3, 4, 5])
    25
    """
    return reduce(lambda x, y: f(f(accInit, x), y) if x == values[0] else f(x,y), values)

#
def reverse(values: List[int]) -> List[int]:
    return values[::-1]

# define a sequence
Section = NewType('Section', Tuple[int, int, int])
Path = NewType('Path', List[Tuple[str, int]])
RoadSystem = NewType('RoadSystem', List[Section])

# define heathrow to london as a group of sections
heathrowToLondon = RoadSystem([Section((50, 10, 30)), Section((5, 90, 20)), Section((40, 2, 25)), Section((10, 8, 0))])

# define our roadStepFast function
def roadStepFast(pathData: Tuple[Path, Path, int, int], sectionData: Section, debug: bool = True) -> Tuple[Path, Path, int, int]:
    sectionM = {"a" : sectionData[0], "b" : sectionData[1], "c" : sectionData[2]}
    forwardPriceToA = pathData[2] + sectionM['a']
    crossPriceToA = pathData[3] + sectionM['b'] + sectionM['c']
    forwardPriceToB = pathData[3] + sectionM['b']
    crossPriceToB = pathData[2] + sectionM['a'] + sectionM['c']
    if forwardPriceToA <= crossPriceToA:
        newPathToA = Path([("A", sectionM['a']), *pathData[0]])
        newPriceA = forwardPriceToA
    else:
        newPathToA = Path([("C", sectionM['c']), ("B", sectionM['b']), *pathData[0]])
        newPriceA = crossPriceToA
    if forwardPriceToB <= crossPriceToB:
        newPathToB = Path([("B", sectionM['b']), *pathData[1]])
        newPriceB = forwardPriceToB
    else: 
        newPathToB = Path([("C", sectionM['c']), ["A", sectionM['a']], *pathData[0]])
        newPriceB = crossPriceToB
    if debug:
        print(f'PathToA: {newPathToA}\nPathToB: {newPathToB} \nPriceA: {newPriceA} \nPriceB: {newPriceB}')
    return (newPathToA, newPathToB, newPriceA , newPriceB)

# define our optimalPath function
def optimalPath(system: RoadSystem, debug: bool = False) -> Path:
    (bestAPath, bestBPath, priceA, priceB) = myFoldl(roadStepFast, ([], [], 0, 0), system)
    if priceA <= priceB:
        return reverse(bestAPath)
    else:
        return reverse(bestBPath)

if __name__ == "__main__":
    print(optimalPath(heathrowToLondon, True))