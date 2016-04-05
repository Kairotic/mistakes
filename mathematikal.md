# Mathematickal arts workshop (foam brussels)

Plain or tabby weave is the simplest form of weaving, but when combined
with sequences of colour it can produce many different types of pattern.

Some of these patterns when combined with muted colours, have in the
past been used as a type of camouflage – and are classified into
District Checks[] for use in hunting in Lowland Scotland. 

A few lines of Scheme calculate and print the colours of an arbitrarily
sized weave, by using lists of warp and weft as input.

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

We can visualising the weaves with single characters representing
colours for ascii previewing, here are some examples:

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

This looked quite promising as ascii art, but I didn’t really know how
it would translate into a textile. I also wanted to look into ways of
generating new patterns algorithmically, using formal grammars. The idea
is that you begin with an axiom, or starting state, and do a 'search
replace' on it repeatedly following one or more simple rules:

Axiom: O
Rule 1: O => O : O :
Rule 2: : => : O :
Run for 3 generations

![](figures/IMAG0376.jpg)

![](figures/IMAG0378-2.jpg)

This technique draws comparisons with Jacquard looms, but obviously it’s
far simpler as the weave itself is the same, we are only changing
between 2 colours (and a human is very much required to do the weaving
in this case). 

Failures: 
- no kernel matrix
- no selvedge
