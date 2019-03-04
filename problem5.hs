-- import trace
import Debug.Trace
    
-- define our data and types
data Section = Section { getA :: Int, getB :: Int, getC :: Int } deriving (Show)  
type RoadSystem = [Section]
data Label = A | B | C deriving (Show)  
type Path = [(Label, Int)]  

-- define the heathrow to london path as a road system
heathrowToLondon :: RoadSystem  
heathrowToLondon = [Section 50 10 30, Section 5 90 20, Section 40 2 25, Section 10 8 0]

-- define our roadStepFast function, this function is has an optimization by having int parameters storing the price of a path
roadStepFast ::(Path, Path, Int, Int) -> Section -> (Path, Path, Int, Int)
roadStepFast (pathA, pathB, priceA, priceB) (Section a b c) =
    let forwardPriceToA =  (priceA + a)
        crossPriceToA =  (priceB + b + c)
        forwardPriceToB =  (priceB + b)
        crossPriceToB =  (priceA + a + c)
        newPathToA = if forwardPriceToA <= crossPriceToA  
            then (A,a):pathA  
            else (C,c):(B,b):pathB  
        newPathToB = if forwardPriceToB <= crossPriceToB  
            then (B,b):pathB  
            else (C,c):(A,a):pathA
        newPriceA = if forwardPriceToA <= crossPriceToA
            then forwardPriceToA
            else crossPriceToA
        newPriceB = if forwardPriceToB <= crossPriceToB
            then forwardPriceToB
            else crossPriceToB
    in (newPathToA, newPathToB, newPriceA, newPriceB)

-- define a wrapper for roadstep fast to perform debugging
roadStepFast' ::(Path, Path, Int, Int) -> Section -> (Path, Path, Int, Int)
roadStepFast' (pathA, pathB, priceA, priceB) (Section a b c) =
    let (pathAResult, pathBResult, priceAResult, priceBResult) = roadStepFast (pathA, pathB, priceA, priceB) (Section a b c)
    in trace ("PathToA: " ++ show pathAResult ++ "\n" ++ "PathToB: " ++ show pathBResult ++ "\n")
        (pathAResult, pathBResult, priceAResult, priceBResult)

-- define our roadStep function, this gets the lowest price path to A or B, not optimized since we calculate the price everytime
roadStep :: (Path, Path) -> Section -> (Path, Path)  
roadStep (pathA, pathB) (Section a b c) =   
    let priceA = sum $ map snd pathA  
        priceB = sum $ map snd pathB 
        forwardPriceToA = priceA + a  
        crossPriceToA = priceB + b + c  
        forwardPriceToB = priceB + b  
        crossPriceToB = priceA + a + c  
        newPathToA = if forwardPriceToA <= crossPriceToA  
                        then (A,a):pathA  
                        else (C,c):(B,b):pathB  
        newPathToB = if forwardPriceToB <= crossPriceToB  
                        then (B,b):pathB  
                        else (C,c):(A,a):pathA  
    in (newPathToA, newPathToB)  

-- define a wrapper for roadstep to perform debugging
roadStep' ::(Path, Path) -> Section -> (Path, Path)
roadStep' (pathA, pathB) (Section a b c) =
    let (pathAResult, pathBResult) = roadStep (pathA, pathB) (Section a b c)
    in trace ("PathToA: " ++ show pathAResult ++ "\n" ++ "PathToB: " ++ show pathBResult ++ "\n")
        (pathAResult, pathBResult)
       
-- define the optimal path function which foldl's the results of roadStep
-- the Bool parameter is to enable or disable debugging
optimalPath :: RoadSystem -> Bool -> Path  
optimalPath roadSystem debug
    | debug =  
        let (bestAPath, bestBPath) = foldl roadStep' ([],[]) roadSystem  
        in  if sum (map snd bestAPath) <= sum (map snd bestBPath)  
                then reverse bestAPath  
                else reverse bestBPath
    | otherwise =
        let (bestAPath, bestBPath) = foldl roadStep ([],[]) roadSystem  
        in  if sum (map snd bestAPath) <= sum (map snd bestBPath)  
                then reverse bestAPath  
                else reverse bestBPath

-- define the optimal path function which foldl's the results of roadStepFast
-- the Bool parameter is to enable or disable debugging
optimalPathFast :: RoadSystem -> Bool -> Path  
optimalPathFast roadSystem debug
    | debug =
        let (bestAPath, bestBPath, priceA, priceB) = foldl roadStepFast' ([],[], 0, 0) roadSystem  
        in  if priceA <= priceB  
                then reverse bestAPath  
                else reverse bestBPath
    | otherwise =
        let (bestAPath, bestBPath, priceA, priceB) = foldl roadStepFast ([],[], 0, 0) roadSystem  
        in  if priceA <= priceB  
                then reverse bestAPath  
                else reverse bestBPath

