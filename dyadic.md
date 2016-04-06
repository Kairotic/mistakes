
# Dyadic arithmetic in the book of elements

Now discrete mathematics is thought about in the technological context
of modern computers, and we struggle to understand the connection with
weaving. However, if we look back, we realise that the birth of
discrete mathematics took place when weaving was the predominant
technology. The hypothesis of Klück (TODO: cross ref Ellen's article),
which lies at the core of the present special issue, is that discrete
mathematics began with thought processes of weavers, and that this is
implicit in the system of counting defined and applied in Euclid's
Elements.  To engage with this hypothesis, we attempted to implement
this system of counting in a contemporary programming language.

We will make this attempt using the Haskell programming language,
known for its very strong focus on defining the types of things in
clear way. We will approach the definitions given in book VII in turn,
in the following, to see how far we can get, and what problems arise.

## Definition 1: A unit is that by virtue of which each of the things
that exist is called one.

~~~~{.haskell .colourtex}
data Unit = Unit
~~~~

The first definition appears straightforward, but allows us to
introduce our first piece of Haskell code, which simply defines a
*data type*. On the left is given the name of the data type, in this
case `Unit`, and on the right all the possible instances of that type,
which here is again called `Unit`.

However, the above already has an error, in that in ancient Greece, a
unit would not be thought of as abstract in this way; you could think
about a sheep unit, or a cow unit, but ancient Greeks would find it
nonsensical to think of a unit as being independent of such a
category. Haskell allows us to model this as this by adding a
parameter `a` for the type:

~~~~{.haskell .colourtex}
data Unit a = forall a. Unit
~~~~

As the `forall` suggests, the type `a` can represent any other type
that we might define, such as `Sheep` or `Cow`. In practice this type
parameter does nothing, apart from indicate that a `Unit` is thought
about with reference to a concrete type of thing. For simplicity, we
will continue with the simpler definition of `data Unit = Unit` as the
basis of the rest of this section.

## Definition 1: A unit is that by virtue of which each of the things that exist is called one.

