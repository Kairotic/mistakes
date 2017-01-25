{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, ExistentialQuantification #-}

module Dyadic where

import Data.Maybe

data Unit a = forall a. Unit

data Multitude a = Dyad (Unit a) (Unit a)
                 | Next (Unit a) (Multitude a)

two = Dyad Unit Unit
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
  show (Dyad u u') = show u ++ show u'
  show (Next u n) = show u ++ show n

fromInt 2 = Dyad Unit Unit
fromInt n | n < 2 = error "There are no multitudes < 2"
          | otherwise = Next Unit $ fromInt (n-1)

lesser (Dyad _ _) (Next _ _) = True
lesser (Next _ a) (Next _ b) = lesser a b
lesser _ _ = False

greater a b = lesser b a

instance Eq (Multitude a) where
  (==) (Dyad _ _) (Dyad _ _) = True
  (==) (Next _ a) (Next _ b) = a == b
  (==) _ _ = False

measureAgainst :: Multitude a -> Multitude a -> Maybe (Multitude a)
measureAgainst (Next _ x) (Next _ y) = measureAgainst x y
measureAgainst (Dyad _ _) (Next _ (Next _ x)) = Just x
measureAgainst _ _ = Nothing

add m (Dyad u u') = Next u (Next u' m)
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

removeUnit (Dyad _ _) = error "Cannot remove a unit from two"
removeUnit (Next _ n) = n

addUnit n = Next Unit n

balance :: Multitude a -> Multitude a -> Maybe (Either (Multitude a) (Unit a))
balance a b | a == b = Just (Left a)
            | lesser a b = Nothing
            | a == (Dyad Unit Unit) && b ==  = Just (Right Unit)
            | otherwise = balance (removeUnit a) (addUnit b)

isEven (Next u (Next u' a)) = isJust (balance a (Dyad u u'))
isEven _ = False

isOdd a = partOne a || partTwo a
  where partOne (Next u (Next u' a)) = (isNothing (balance a (Dyad u u')))
        partOne _ = False
        partTwo a = (isEven $ addUnit a)

lessers :: Multitude a -> [Multitude a]
lessers (Dyad _ _) = []
lessers (Next u m) = m : (lessers m)

isFTimesF f f' m = or $ catMaybes [(f <$> measure a m) | a <- filter f' (lessers m)]

isEvenTimesEven = isFTimesF isEven isEven

isEvenTimesOdd = isFTimesF isEven isOdd

isOddTimesEven = isFTimesF isOdd isEven

