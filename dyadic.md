
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

**Definition 1**: A unit is that by virtue of which each of the things
that exist is called one.

~~~~{.haskell .colourtex}
data Unit = Unit
~~~~

