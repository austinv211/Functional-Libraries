-- Name: problem2.hs
-- Description: Commented Haskell Code from assignment document
-- Author: Austin Vargason

-- many of these functions are written in point-free notation
-- point free style is when you define functions as a composition
-- of functions where we never mention the actual arguments the function may be applied to
-- point-free style is considered cleaner and more compact

-- toDigit function: In this function we take in a character c as an argument and provide it as an arg to the read function
-- which takes in a string, we can convert c to a string by making it a single element array containing c
-- the read function will parse the character c into a integer digit
toDigit :: Char -> Int
toDigit c = read [c]

-- toDigits function: this function takes in an Int and produces and Int array.
-- In this function we use a function composition to take the result of the show function on the Int to convert to a string
-- and use the map function to map toDigit to each char in the string
toDigits :: Int -> [Int]
toDigits = map toDigit . show

-- doubleEveryOther function: this function takes in an Int array and produces an Int array
-- this function uses function composition to reverse the Int array and passes the result to the zipWith function that multiplies every number by the number in the list created by cycle (either 1 or 2)
-- this will double every other number in the array
doubleEveryOther :: [Int] -> [Int]
doubleEveryOther = zipWith (*) (cycle [1,2]) . reverse

-- sumDigits function: this function takes in an Int array and produces an Int result
-- this function uses function composition to take the result of mapping an Int array to the toDigits function, then concattenating the lists together in a single list, then summing the elements in that list
sumDigits :: [Int] -> Int
sumDigits = sum . concat . map toDigits

-- checkSum function: takes in an Int and produces an Int
-- this function uses function composition to take the result of ToDigits called on the Int provided and pass it to the doubleEveryOther function, which then gets passes to the sumDigits function to produce a single sum
checkSum :: Int -> Int
checkSum = sumDigits . doubleEveryOther . toDigits

-- isValid function: this function takes an Int and produces a Bool
-- this function uses function composition to pass the result of the checksum function called on the Int provided to the (flip mod) 10 call (flip flips the argument order for the function), this takes the the mod 10 of the result,
-- then passes it to the (==) function to check whether the result is equal to 0.
-- overall this function does a checksum on the Int and checks whether that number is equally divisible by 10 to determine a valid result
isValid :: Int -> Bool
-- This simple version:
-- isValid n = checkSum n `mod` 10 == 0
-- can be tortured into this point-free form:
isValid = (==) 0 . (flip mod) 10 . checkSum
-- Can you explain the point-free form?
-- (This is an exercise, not a claim that it’s better code.)

-- flip is defined in the Prelude, but it can be defined as follows.
myFlip :: (a -> b -> c) -> (b -> a -> c)
myFlip f = \x y -> f y x

-- testCC function: this function produces an array of Bools
-- this function maps the isValid function to two credit card numbers to determine whether they are valid
testCC :: [Bool]
testCC = map isValid [1234567890123456, 1234567890123452]
-- => [False, True]