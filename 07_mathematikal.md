# Mathematickal arts workshop (foam brussels)

Plain or tabby weave is the simplest form of weaving, but when combined
with sequences of colour it can produce many different types of pattern.

Some of these patterns when combined with muted colours, have in the
past been used as a type of camouflage – and are classified into
District Checks [citation needed] for use in hunting in Lowland
Scotland.

The first weaving codes prototype I made was during the Mathematickal
Arts workshop at FoAM Brussels [citation needed]. A few lines of Scheme
calculate and print the colours of an arbitrarily sized plain weave, by
using lists of warp and weft yarn as input.

    ; return warp or weft, dependant on the position
    (define (stitch x y warp weft)
      (if (eq? (modulo x 2)
               (modulo y 2))
      warp weft))

    ; prints out a weaving
    (define (weave warp weft)
      (for ((x (in-range 0 (length weft))))
         (for ((y (in-range 0 (length warp))))
            (display (stitch x y 
                             (list-ref warp y)
                             (list-ref weft x))))
       (newline)))

We visualised the weaves with single characters representing colours for
ascii text previewing, here are some examples:

Warp and weft all the same colour:

`(weave '(O O O O O O O) '(: : : : : : : : :))`

     O : O : O : O
     : O : O : O :
     O : O : O : O
     : O : O : O :
     O : O : O : O
     : O : O : O :
     O : O : O : O
     : O : O : O :
     O : O : O : O

2:2 alternating colour with an offset:

`(weave '(O O : : O O : : O O) '(O : : O O : : O O :))`

     : O : : : O : : : O
     O : : : O : : : O :
     O O O : O O O : O O
     O O : O O O : O O O
     : O : : : O : : : O
     O : : : O : : : O :
     O O O : O O O : O O
     O O : O O O : O O O
     : O : : : O : : : O

This looked quite promising as ascii art, but we didn’t really know how
it would translate into a textile. We also wanted to look into ways of
generating new patterns algorithmically, using formal grammars. The idea
is that you begin with an axiom, or starting state, and do a 'search
replace' on it repeatedly following one or more simple rules:

    Axiom: O
    Rule 1: O => O : O :
    Rule 2: : => : O :

So we begin with the axiom:

    O

Then run rule one on it - replacing `O` with `O : O :`

    O : O :

Then run rule two, replacing `:` with `: O :`:

    O : O : O : O :

And repeat both these steps one more time:

    O : O : O : O : : O : O : O : O : O : : O : O : O : O : O : : O : O : O : O : O : : O :

The pattern grows like a cellular or plant structure - this technique
was first developed for modelling plant growth.

We run the rules one more time, then read off the pattern replacing `O` for red and `:` as orange to warp a frame loom:

![](figures/IMAG0376.jpg)

When weaving, we follow the same sequence for the weft threads:

![](figures/IMAG0378-2.jpg)

The idea of this technique was twofold, firstly to begin to understand
weaving by modelling plain weave, and confirming a hypothesis by
following instructions produced by the language by actually weaving
them.

The other aspect was to use a generative formal grammar to explore the
patterns possible given the restriction of plain weave, perhaps in a
different manner to that used by weavers - but one that starts to treat
weaving as a computational medium.

This system was restricted by only working with plain weave, although
given the range of patterns possible, this didn't seem too much of a
problem. What was more problematic was the abstract nature of the
symbols and text modelling, in future developments we addressed both of
these issues.
