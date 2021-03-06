{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, ExistentialQuantification #-}

module Dyadic where

import Data.List
import Data.Maybe

{- Def. 1 A unit (monas) is that by virtue of which each of the things that
   exist is called one. -}

data Unit a = forall a. Unit


{- Def. 2 A number is a multitude composed of units. -}
data Multitude a = Pair (Unit a) (Unit a)
                 | Next (Unit a) (Multitude a)


fromInt :: Integral a => a -> Multitude b
fromInt 2 = Pair Unit Unit
fromInt n | n < 2 = error "There are no numbers < 2"
          | otherwise = Next Unit $ fromInt (n-1)

instance Show (Unit a) where
  show x = "x"

instance Show (Multitude a) where
  show (Pair u u') = show u ++ show u'
  show (Next u n) = show u ++ show n


-- instance Eq (Unit a) where
--   (==) _ _ = True

{- Def 3. A number is a part of a number, the less of the greater,
   when it measures the greater -}

instance Eq (Multitude a) where
  (Pair _ _) == (Pair _ _) = True
  (Next _ a) == (Next _ b) = a == b
  (_) == (_) = False

lesser :: Multitude a -> Multitude a -> Bool
lesser (Pair _ _) (Next _ _) = True
lesser (Next _ a) (Next _ b) = lesser a b
lesser _ _ = False

greater a b = lesser b a

measureAgainst :: Multitude a -> Multitude a -> Maybe (Multitude a)
measureAgainst (Next _ x) (Next _ y) = measureAgainst x y
measureAgainst (Pair _ _) (Next _ (Next _ x)) = Just x
measureAgainst _ _ = Nothing

(+) a (Pair u u') = Next u (Next u' m)
(+) a (Next u b) = (Next u a) b

-- measure :: Multitude a -> Multitude a -> 
measure a b = lesser a b && measure' a a 

remaining :: Multitude a -> Multitude a -> Multitude a
remaining (Next _ a) (Next _ b) = remaining x y
remaining a@(Pair _ _) (Next _ (Next _ (Pair _ _))) = a
          
measure :: Multitude a -> Multitude a -> Maybe (Multitude a)
measure (Pair _ _) (Next _ (Next _ (Pair _ _))) = Just (Pair Unit Unit)
measure x y = do a <- remaining x y
                 b <- measure x a
                 return (Next Unit b)


-- in other words, a number a is part of another number b if there exists some number n such that n a = b


-- isPart l g = isJust (measure l g)

{-
{- Def. 5 The greater number is a multiple of the less when it is
   measured by the less. -}

isMultiple g l = isJust (measure l g)

{- Def. 6 An even number is that which is divisible into two equal parts. -}
isEven :: Number -> Bool
isEven (Unit:Unit:[]) = True
isEven (Unit:[]) = False
isEven [] = False -- ?
isEven (Unit:Unit:n) = isEven n

{- Def. 7 An odd number is that which is not divisible into two equal
   parts, or that which differs by a unit from an even number.-}
isOdd :: Number -> Bool
isOdd = isEven . (Unit:)

findIn :: (Number -> Bool) -> Number -> [Number]
findIn f n = filter f (tails n)

evensIn :: Number -> [Number]
evensIn = findIn isEven

{- Def. 8 An even-times-even number is that which is measured by an
   even number according to an even number. -}

-- Had to take tail of n..
isFTimesF :: (Number -> Bool) -> (Number -> Bool) -> Number -> Bool
isFTimesF f f' n = or [maybe False f' (measure x n) | x <- findIn f (tail n)]

isEvenTimesEven :: Number -> Bool
isEvenTimesEven = isFTimesF (isEven) (isEven)

isEvenTimesOdd :: Number -> Bool
isEvenTimesOdd = isFTimesF (isEven) (isOdd)

isOddTimesOdd :: Number -> Bool
isOddTimesOdd = isFTimesF (isOdd) (isOdd)

addUnit = (Unit:)

{-
fromInt :: Integral a => a -> Multitude b
fromInt 2 = Pair Unit Unit
fromInt n | n < 2 = error "There are no numbers < 2"
          | otherwise = Next Unit $ fromInt (n-1)
-}
-}
