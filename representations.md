# Representing thread

A central puzzle to our project is how to represent thread within
code. A naive approach would be to represent it as a two-dimensional
grid or raster, for example as a list of lists of boolean values,
representing ups and downs:

````
data Weave = Weave {draft :: [[Bool]]}
````

This allows the woven structure within a weaver's draft to be
represented, and fits the affordances of a programming language very
well, which is well suited to the processing of lists. But this is
only one point of view, and this grid-like view of a weave does not
consider the path of a thread, including at the selvedge. What happens
if we attempt to take the point of view of a thread?

The below lists just some of the different ways we thought about
representing a weave. Each represents a different point of view or way
of thinking, in terms of movement of thread, loom and weaver.

````
-- Thread properties as a list?
type Thread a = [a]

-- Thread properties as behaviour over its length?
type Thread a = Int -> a

-- Construction of a weave as change of state?
type Pick = Weave -> Weave

-- Construction of a weave as a sequence of movements (turtle)?
data Move = Over | Under | TurnLeft | TurnRight
type Weave = [Move]

-- Weave as path - coordinate based
data Weave = Weave {thread :: [(Int,Int,Bool)]}

-- Structure of weft relative to state
data Change = Up | Down | Toggle | Same Int | Different Int
data Weave = Weave [Change]
tabby = Weave (Up:repeat Toggle)

-- Lift plan
data Pull = Up | Down
data HeddleRod = HeddleRod [Pull]
data Weave = Weave [[HeddleRod]]

-- Unweave
data Untangle = Pull | Unloop
data Unweave = [Untangle]

-- Discrete thread
data Direction = Left | Right
data Thread = Straight | Turn Direction | Loop Direction | Over | Under

-- Weave as action
data Direction = Left90 | Right90 | Left180 | Right180
data Action = Pull Int | Turn Direction | Over | Under
````

The representation that we found ourselves most drawn to was that
which focussed on the actions of a thread:

````
data Action = Over | Under | Pull Int | TurnIn | TurnOut
type Weave = [Action]
````

The first two actions represent a thread going *over* and *under* a
thread (which may be itself, in the case where it has turned back upon
itself). The third represents a thread being *pulled* a discrete
number of measures, or in other words, a thread being under tension
over a distance. We felt this important, as tension is an important
part of the structure of a weave, at least while it is on a loom.

The final actions are of the thread turning an assumed 90 degrees,
either *in* or *out*. In practice, *in* means turn in the same
direction as the last turn, and *out* in the opposite direction. A
more obvious approach would be to explicitly represent left and right
turns, but this does not make sense from the perspective of a
thread. Because a thread itself continually twists relative to the
weave, it has little purchase on a left/right orientation. The concept
of *in* and *out* operates relative to what has been woven before.

The concept of *in* and *out* fits well with the back-and-forth
structure of a weave. Rather than thinking in terms of turning left on
one side and right on the other, we can think of both turns in terms
of the thread first turning *out* from the weave, and then back *in*
to turn back on itself on the next row. Accordingly the creation of a
warp of `n` threads and `l` length can be represented as a repeating
cycle of just three steps:

````
warp n l = take (n*3) $ cycle [Pull l,TurnOut,TurnIn]
````

Similarly, we can represent a plain or tabby weave with a single
thread, by composing together a warp, with a turn inward, and a
repeating over/under:

````
tabby h w = warp h w ++ [TurnIn] ++ threadWeftBy (rot 1) ([Over,Under]) h w
````

Following this weave produces the following:

''''
 .-    .--.  .--.  .--.  .--.                                           
 `--#--+--#--+--#--+--#--+--#--.                                        
 .--+--#--+--#--+--#--+--#--+--'                                        
 `--#--+--#--+--#--+--#--+--#--.                                        
 .--+--#--+--#--+--#--+--#--+--'                                        
 `--#--+--#--+--#--+--#--+--#--.                                        
 .--+--#--+--#--+--#--+--#--+--'                                        
 `--#--+--#--+--#--+--#--+--#--.                                        
 .--+--#--+--#--+--#--+--#--+--'                                        
 `--#--+--#--+--#--+--#--+--#--.                                        
    `--'  `--'  `--'  `--'  `--'                                        
''''

An advantage of this approach is that it is able to represent a case
where the weft threads of a weave are pulled, in order to become a
warp for a later stage of the weave. This of particular interest to
our project, in relation to the ancient method of starting with a
tablet woven band, with an extended weft which later becomes the warp
on a warp-weighted loom. The following composition demonstrates such a
proof of concept, where a the weft of a four-twill later becomes the
warp of a tabby pattern.

````
[TurnOut,TurnIn,TurnOut,Pull 8, TurnIn,Pull 1] ++ warp 8 9 ++ [TurnIn] ++ (weftToWarp 6 $ threadWeftBy'' Odd (rot 1) [Over,Over,Under,Under] 8 9) ++ [TurnOut,TurnIn,TurnIn] ++ threadWeftBy'' Odd (rot 1) [Over,Under] 10 6
````

       .--------------------------.                         
    `--'        .--.  .--.  .--.  |  .--.  .--.  .--.  .--. 
             .--+--#--+--#--+--#--+--+--#--#--+--+--#--#--' 
             `--#--+--#--+--#--+--#--+--+--#--#--+--+--#--. 
             .--+--#--+--#--+--#--#--#--+--+--#--#--+--+--' 
             `--#--+--#--+--#--+--+--#--#--+--+--#--#--+--. 
             .--+--#--+--#--+--#--+--+--#--#--+--+--#--#--' 
             `--#--+--#--+--#--+--#--+--+--#--#--+--+--#--. 
             .--+--#--+--#--+--#--#--#--+--+--#--#--+--+--' 
             `--#--+--#--+--#--+--+--#--#--+--+--#--#--+--. 
             .--+--#--+--#--+--#--+--+--#--#--+--+--#--#--' 
             `--#--+--#--+--#--+--. -'  `--'  `--'  `--'    
             `--'  `--'  `--'  `--'                         
