{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, ExistentialQuantification #-}

module Dyadic where

import Data.Maybe

data Unit a = forall a. Unit

data Multitude a = Pair (Unit a) (Unit a)
                 | Next (Unit a) (Multitude a)

two = Pair Unit Unit
three = Next Unit two
four = Next Unit three
five = Next Unit four
six = Next Unit five
seven = Next Unit six
eight = Next Unit seven
nine = Next Unit eight
ten = Next Unit nine

instance Show (Unit a) where
  show x = "x"

instance Show (Multitude a) where
  show (Pair u u') = show u ++ show u'
  show (Next u n) = show u ++ show n

fromInt 2 = Pair Unit Unit
fromInt n | n < 2 = error "There are no multitudes < 2"
          | otherwise = Next Unit $ fromInt (n-1)

lesser (Pair _ _) (Next _ _) = True
lesser (Next _ a) (Next _ b) = lesser a b
lesser _ _ = False

greater a b = lesser b a

instance Eq (Multitude a) where
  (==) (Pair _ _) (Pair _ _) = True
  (==) (Next _ a) (Next _ b) = a == b
  (==) _ _ = False

measureAgainst :: Multitude a -> Multitude a -> Maybe (Multitude a)
measureAgainst (Next _ x) (Next _ y) = measureAgainst x y
measureAgainst (Pair _ _) (Next _ (Next _ x)) = Just x
measureAgainst _ _ = Nothing

add m (Pair u u') = Next u (Next u' m)
add m (Next u m') = add (Next u m) m'

isPart :: Multitude a -> Multitude a -> Bool
isPart a b = lesser a b && measures a b

measures :: Multitude a -> Multitude a -> Bool
measures a b | a == b = True
             | isJust remaining = measures a (fromJust remaining)
             | otherwise = False
  where remaining = (measureAgainst a b)

measure :: Multitude a -> Multitude a -> Maybe (Multitude a)
measure a b = do m <- measureAgainst a b
                 if m == a
                   then (return two)
                   else do m' <- measureAgainst a m
                           measure' two a m' 
  where measure' m a b | a == b = Just (addUnit m)
                       | otherwise = do b' <- measureAgainst a b
                                        measure' (addUnit m) a b'

isParts :: Multitude a -> Multitude a -> Bool
isParts a b = lesser a b && not (measures a b)

isMultiple :: Multitude a -> Multitude a -> Bool
isMultiple a b = greater a b && not (measures a b)

removeUnit (Pair _ _) = error "Cannot remove a unit from two"
removeUnit (Next _ n) = n

addUnit n = Next Unit n

balance :: Multitude a -> Multitude a -> Maybe (Multitude a)
balance a b | a == b = Just a
            | lesser a b = Nothing
            | a == (Pair Unit Unit) = Nothing
            | otherwise = balance (removeUnit a) (addUnit b)

isEven (Next u (Next u' a)) = isJust (balance a (Pair u u'))
isEven _ = False

isOdd a = partOne a || partTwo a
  where partOne (Next u (Next u' a)) = (isNothing (balance a (Pair u u')))
        partOne _ = False
        partTwo a = (isEven $ addUnit a)

lessers :: Multitude a -> [Multitude a]
lessers (Pair _ _) = []
lessers (Next u m) = m : (lessers m)

isFTimesF f f' m = or $ catMaybes [(f <$> measure a m) | a <- filter f' (lessers m)]

isEvenTimesEven = isFTimesF isEven isEven

isEvenTimesOdd = isFTimesF isEven isOdd

isOddTimesEven = isFTimesF isOdd isEven

