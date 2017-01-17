# tablet weaving simulation

Tablet weaving (also known as card weaving) is an ancient form of
textile pattern production, using cards which are rotated to provide
different sheds between warp threads. This technique produces long
strips of fabric, which in antiquity were used as the starting bands
and that form the borders of a larger warp weighted weaving.

Tablet weaving is extremely complex, so in a similar manner to the 4
shaft loom, we devised a language/notation to help better understand
it. In the same way as before, this language can be used either to
drive a computer simulation, or can be followed when weaving.

![Simulated tablet weave for the single instruction `(weave-forward 16)`.](figures/06-forward16.png)

The language consists of simple instructions to represent the movement
of the cards to create each shed. For example, Figure 6 shows a simple
case where cards are moved a quarter-turn to create each of 16
sheds. The card rotations are shown on the left for each of 8 cards,
the simulated weaving is on the right for the top and bottom of the
fabric. `(weave-forward 16)` turns all the cards a quarter turn, adds
one weft and repeats this 16 times.

In our simulation, the cards are set up with a double face weave on
square cards: black, black, white, white clockwise from the top right
corner. We can offset these cards from each other first, to change the
pattern. The `rotate-forward` instruction turns only the specified
cards a quarter turn forward without weaving a weft, illustrated in Figure 7.

![Simulated tablet weave for the following:
```
(rotate-forward 0 1 2 3 4 5)
(rotate-forward 0 1 2 3)
(rotate-forward 0 1)
(weave-forward 32)
```
](figures/07-diagonal.png)

One interesting limitation of tablet weaving is that it is not
possible to weave 32 forward quarter rotates without completely
twisting up the warp, so we need to go forward and backwards to make
something physically weavable. However as Figure 8 demonstrates, if we
do so then a 'zig zag' pattern results. Figure 9 shows that a
different starting pattern that better matches the stitch direction.

![```
    (rotate-forward 0 1 2 3 4 5)
    (rotate-forward 0 1 2 3)
    (rotate-forward 0 1)
    (repeat 4
      (weave-forward 4)
      (weave-back 4))
```
](figures/08-zigzag1.png)

![```
    (rotate-forward 0 1 2 3 4 5 6)
    (rotate-forward 0 1 2 3 4 5) 
    (rotate-forward 0 1 2 3 4)
    (rotate-forward 0 1 2 3)
    (rotate-forward 0 1 2)
    (rotate-forward 0 1)
    (rotate-forward 0)
    (repeat 4
      (weave-forward 4)
      (weave-back 4))
```
](figures/09-zigzag2.png)

As an alternative to specifying rotation offsets as above, we can use
*twist* to form patterns. Accordingly, the `twist` command takes a
list of cards to twist, and results in these cards effectively
reversing their turn direction compared to the others, as demonstrated
by Figure 10. With double faced weave, the twist needs to take place
when the cards are in the right rotation, otherwise we get an 'error',
such as that shown in Figure 11.


![
```
(weave-forward 7)
    (twist 0 1 2 3)
    (weave-back 1)
    (repeat 2
      (weave-forward 2)
      (weave-back 2))
    (weave-forward 1)
    (twist 2 3 4 5)
    (weave-back 1)
    (repeat 2
      (weave-forward 2)
      (weave-back 2))
    (weave-forward 1)
    (twist 1 2 5 6)
    (weave-back 1)
    (repeat 2
      (weave-forward 2)
      (weave-back 2))
```
](figures/10-mip.png)

![Following the same instructions as in Fig. 10, but where the first `(weave-forward 7)` is changed to `(weave-forward 6)` showing very different results.](figures/11-miperror.png)

If we put our encoded twists into repeating loops, we can make small
programs with complex results. You can see a comparison with the woven
form below, created by following the program by hand.
	  
![The following code, executed both by the simulation and by hand.```
```
(weave-forward 1)
    (twist 0 2 4 6)
    (repeat 4
      (twist 3)
      (weave-forward 4)
      (twist 5)
      (weave-back 4))
```
](figures/11-twistpat-comb.jpg)
   
This language was the first we created that describes the actions and
movement of the weaver. It was mainly of use in understanding the
complexities of tablet weaving, indeed some of this remains a mystery
-- the calculation of the inverse side of the weaving is not correct,
probably due to the double twining of the weave. In some cases it has
very different results, in others it matches perfectly. Further
experimentation is needed.

This language also started investigations into combining the tablet
and warp weighted weaving techniques into a single notation
system. This remains a challenge, but pointed in the direction of a
more general approach being required - rather than either a loom
or weaver-centric view.
