
-- Name: problem4.hs
-- Author: Austin Vargason
-- Description: Pretty version of My Luhn in Haskell


-- Python version
-- from itertools import cycle
-- def myLuhn(n: int) -> bool:
-- fn = lambda c: sum(divmod(2*int(c), 10))
-- checksum = sum(f(c) for (f, c) in zip(cycle([int, fn]), reversed(str(n))))
-- return checksum % 10 == 0
-- print(list(map(myLuhn, [1234567890123456, 1234567890123452])))
-- # => [False, True]

-- Haskell version
myLuhn :: Int -> Bool
myLuhn n =
    let sumTuple (x, y) = x + y
        fn = sumTuple . \c -> divMod (2 * c) 10
        checksum = sum [ if f == 1 then read [c] else fn (read [c]) | (f, c) <- zip (cycle [1, 0]) (reverse (show n))]
    in (mod checksum 10) == 0

testCC :: [Bool]
testCC = map myLuhn [49927398716, 49927398717, 1234567812345678, 1234567812345670, 91]
