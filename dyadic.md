
# Dyadic arithmetic in the book of elements

Discrete mathematics is often now thought about in the technological
context of modern computers, and we struggle to understand the
connection with weaving. However, if we look back, we realise that the
birth of discrete mathematics took place when weaving was the
predominant technology. The hypothesis of Ellen Harlizius-Klück, which
lies at the core of the present special issue, is that discrete
mathematics in some sense *began* with thought processes of weavers,
and that this is implicit in the system of counting defined and
applied in Euclid's Elements.  To engage with this hypothesis, we here
attempt to implement this system of counting in a contemporary
programming language.

We will make this attempt using the Haskell programming language,
known for its very strong focus on *types*. We will approach the
definitions given in book VII of Euclid's Elements in turn, in the
following, to see how far we can get, and what problems arise.

## Definition 1: A unit is that by virtue of which each of the things that exist is called one.

~~~~{.haskell .colourtex}
data Unit = Unit
~~~~

The first definition appears straightforward, but allows us to
introduce our first piece of Haskell code, which simply defines a
*data type*. On the left is given the name of the data type, in this
case `Unit`, and on the right all the possible instances of that type,
which here is again called `Unit`.

[comment]: <> (Ellen - A reference to ancient Greeks non-abstract conception of a unit?)

However, the above already has an error, in that in ancient Greece, a
unit would not be thought of as abstract in this way; you could think
about a sheep unit, or a cow unit, but ancient Greeks would find it
nonsensical to think of a unit as being independent of such a
category. Haskell allows us to model this as this by adding a
parameter `a` for the type:

~~~~{.haskell .colourtex}
data Unit a = forall a. (Unit a)
~~~~

As the `forall` suggests, the type `a` can represent any other type
that we might define, such as `Sheep` or `Cow`. In practice this type
parameter does nothing, apart from indicate that a `Unit` is thought
about with reference to a concrete type of thing. So to model an unit
of white Sheep, we could do the following:

~~~~{.haskell .colourtex}
data Sheep = Sheep {colour :: String}

sheep = Unit (Sheep "white")
~~~~

However we are not interested in `Unit`s having a particular identity
here, so we will use a definition which specifies a type parameter,
but does not require a value when a Unit instance is being created:

~~~~{.haskell .colourtex}
data Unit a = forall a. Unit

sheep :: Unit Sheep
sheep = Unit
~~~~

Our sheep here still has the type of `Unit Sheep`, but does not define
anything about a particular sheep.

## Definition 2: A number is a multitude composed of units.

The second definition also appears straightforward; in code terms, we
can think of a *multitude* as a list, which is denoted by putting the
`Unit` datatype in square brackets:

~~~~{.haskell .colourtex}
type Multitude a = [Unit a]
~~~~

Note that the same type parameter is used in `Unit a` and `Multitude a`, which means that you for example can't mix `Sheep` and `Cow`s in the same multitude.

However, there is awkward detail at play. Firstly, in Haskell it is
valid to have an empty list, whereas the number *zero* is not defined by
Euclid. Indeed, neither is the number *one* -- a multitude begins with
*two*, the number *one* is not considered to be a number, but simply a
unit. A representation that truly represents a multitude should
neither admit the numbers *zero* or *one*.

A way around this is to define a multitude relative to the number two,
as a pair of units:

~~~~{.haskell .colourtex}
data Multitude a = Pair (Unit a) (Unit a)
	| Next (Unit a) (Multitude a)
~~~~

The number *four* would then be constructed with the following:

~~~~{.haskell .colourtex}
four = Next Unit (Next Unit (Pair Unit Unit))
~~~~

It would be nice if we could 'see' this multitude more clearly.  We
can visualise it by telling Haskell to show a `Unit` with an `x` and
by stringing together the units across instances of `Pair` and
`Next`:

~~~~{.haskell .colourtex}
instance Show (Unit a) where
  show x = "x"

instance Show (Multitude a) where
  show (Pair u u') = show u ++ show u'
  show (Next u n) = show u ++ show n
~~~~{.haskell .colourtex}

Then the number `four` is shown like this (here the `> ` prefixes the
expression `four`, and the result is shown in the following line):

~~~~{.haskell .colourtex}
> four
xxxx
~~~~

Here is a handy function for turning the integer numbers that we are
familiar with into multitudes, which first defines the conversion from
`2`, and then the general case, based upon that.

~~~~{.haskell .colourtex}
fromInt 2 = Pair Unit Unit
fromInt n | n < 2 = error "There are no multitudes < 2"
          | otherwise = Next Unit $ fromInt (n-1)
~~~~

## Definition 3. A number is a part of a number, the less of the greater, when it measures the greater

Definition 3 is a little more complex, and because a single unit is
not a number, awkward to express in contemporary programming
languages. Lets begin by defining the cases where `lesser` is true, by
following two multitudes, and returning `True` if we get to the end of
the left hand multitude first. We may also define `greater` by simple
swapping the two parameters:

~~~~{.haskell .colourtex}
lesser (Pair _ _) (Next _ _) = True
lesser (Next _ a) (Next _ b) = lesser a b
lesser _ _ = False

greater a b = lesser b a
~~~~

We may define the equality operator `==` by taking the same approach:

~~~~{.haskell .colourtex}
instance Eq (Multitude a) where
  (==) (Pair _ _) (Pair _ _) = True
  (==) (Next _ a) (Next _ b) = a == b
  (==) _ _ = False
~~~~

We can then define a function `isPart` in terms of `lesser` and
another function `measures` which returns True if it is able to
repeatedly subtract one multitude from another (using
`measureAgainst`), until they are equal.

~~~~{.haskell .colourtex}
measureAgainst :: Multitude a -> Multitude a -> Maybe (Multitude a)
measureAgainst (Next _ x) (Next _ y) = measureAgainst x y
measureAgainst (Pair _ _) (Next _ (Next _ x)) = Just x
measureAgainst _ _ = Nothing

measures :: Multitude a -> Multitude a -> Bool
measures a b | a == b = True
             | isJust remaining = measures a (fromJust remaining)
             | otherwise = False
  where remaining = (measureAgainst a b)

isPart :: Multitude a -> Multitude a -> Bool
isPart a b = lesser a b && measures a b
~~~~

## Definition 4. But parts when it does not measure it.

This is now straightforward to represent:

~~~~{.haskell .colourtex}
isParts :: Multitude a -> Multitude a -> Bool
isParts a b = lesser a b && not (measures a b)
~~~~

The usefulness of the definition of *parts* comes in later
definitions, particularly where ratios are dealt with.

## Definition 5. The greater number is a multiple of the less when it is measured by the less.

Again, straightforward to represent in terms of what we have defined already:

~~~~{.haskell .colourtex}
isMultiple :: Multitude a -> Multitude a -> Bool
isMultiple a b = greater a b && not (measures a b)
~~~~

## Definition 6. An even number is that which is divisible into two equal parts.

This definition of even seems straightforward, but from a contemporary
perspective, is made awkward by the exclusion of the number *one* from
the class of numbers. In particular, the number two cannot be divided
into two parts, if we assume from definition 3 that a part must be a
multitude. The approach we take below then is to attempt to divide a
number into equal parts by first taking two units from it, and then
further successive units until either we have taken a number equal to
what we are left with, in which case the number is even, or greater
than what we are left with, in which case it is not. This excludes the
number `2` from the class of even numbers, but nonetheless is true to
Euclid's definition, at least according to the English translation we
are using.

~~~~{.haskell .colourtex}
removeUnit (Pair _ _) = error "Cannot remove a unit from two"
removeUnit (Next _ n) = n

addUnit n = Next Unit n

balance :: Multitude a -> Multitude a -> Maybe (Multitude a)
balance a b | lesser a b = Nothing
            | a == (Pair _ _) = Nothing
            | a == b = Just (a, b)
            | otherwise = balance (removeUnit a) (addUnit b)

isEven (Next u (Next u' a)) = isJust (balance a (Pair u u'))
isEven _ = False
~~~~

## Definition 7. An odd number is that which is not divisible into two equal parts, or that which differs by a unit from an even number.

The definition of odd numbers is in two parts. It is debatable whether
the number `3` meets the first part; in a sense, `3` is not divisible
into parts at all, as a unit is not a multitude. However it is clear
that it does meet the second part, and so according to boolean logic,
this amiguity is removed.

~~~~{.haskell .colourtex}
isOdd a = partOne a || partTwo a
  where partOne (Next u (Next u' a)) = (isNothing (balance a (Pair u u')))
        partOne _ = False
        partTwo a = isEven (addUnit a)
~~~~

## Definition 8. An even-times-even number is that which is measured by an even number according to an even number.

We first need to find the number of times that a number measures
another number. This is done by the following function `measure`,
which is a little awkward to define without the number one.

~~~~{.haskell .colourtex}
measure :: Multitude a -> Multitude a -> Maybe (Multitude a)
measure a b = do m <- measureAgainst a b
                 if m == a
                   then (return two)
                   else do m' <- measureAgainst a m
                           measure' two a m' 
  where measure' m a b | a == b = Just (addUnit m)
                       | otherwise = do b' <- measureAgainst a b
                                        measure' (addUnit m) a b'
~~~~

We can then find the even-times-even numbers using an exhaustive search:

~~~~{.haskell .colourtex}
isFTimesF f f' m = or $ catMaybes [(f <$> measure a m) | a <- filter f' (lessers m)]

isEvenTimesEven = isFTimesF isEven isEven
isEvenTimesOdd = isFTimesF isEven isOdd
isOddTimesEven = isFTimesF isOdd isEven
~~~~

We have also defined odd-times-even and even-times-odd numbers, which are definitions 9 and 10.
