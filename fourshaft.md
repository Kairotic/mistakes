
# Four shaft loom simulation

Instead of defining the pattern you want directly, you are describing
the set up of a 4 shaft loom – so the warp threads that each of 4 shafts
pick up in the top row of toggle boxes, then which shafts are picked up
for each weft thread as the fabric is woven on the right.

This involved writing a program that is based closely on how a loom
functions – for example calculating a shed (the gap between ordered warp
thread) by folding over each shaft in turn and or-ing each warp thread
to calculate which ones are picked up. This really turns out to be the
core of the algorithm – here’s a snippet:

    ;; 'or's two lists together:
    ;; (list-or (list 0 1 1 0) (list 0 0 1 1)) => (list 0 1 1 1)
    (define (list-or a b)
      (map2
       (lambda (a b)
         (if (or (not (zero? a)) (not (zero? b))) 1 0))
       a b))
    
    ;; calculate the shed, given a lift plan position counter
    ;; shed is 0/1 for each warp thread: up/down
    (define (loom-shed l lift-counter)
      (foldl
       (lambda (a b)
         (list-or a b))
       (build-list (length (car (loom-heddles l))) (lambda (a) 0))
       (loom-heddles-raised l lift-counter)))

I’ve become quite obsessed with this program, spending quite a lot of
time with it trying to understand how the loom setup corresponds to the
patterns. Here are some example weaves that you can try. Colour wise, in
all these examples the order is fixed – both the warp and the weft
alternate light/dark yarns.

![](figures/boxy.png)

After writing the 4 shaft loom simulation the next job was to try
weaving the structures with real threads. Would I be able to replicate
the predicted patterns and structures? Ellen warned me that the meander
weave would result in unstable fabric, but it would depend on the nature
of the material used so was worth trying. Originally I planned to warp
up the Harris loom but I need to work up to that as it’s a big and
complex job, so I quickly built a frame loom with some bits of wood and
nails at 5mm intervals to hold the warp in place.

![](figures/frame-loom.jpg)

Here I’m sleying the shafts using threads to pick up the warp as defined
by the simulation toggle buttons. The threads (which form heddles) are
tied on to wooden poles which are pulled in different combinations
during weaving. This is the approach we saw on the warp weighted looms
in Copenhagen, I’m not sure if it’s usually used on frame looms – it was
cumbersome but much faster than counting threads manually each
time. It’s important to use thinner threads than the warp, but you need
to put quite a bit of tension on them so they need to be strong. There
is something very appropriate in the context of this project about
coding threads with threads in this way.

In relation to livecoding, I was surprised to the extent that
improvisation is required when weaving even based on a predefined
pattern. There is a lot of reasoning required in response to issues of
structure that cannot be defined ahead of time. You need to respond to
the interactions of the materials and the loom itself, the most obvious
problem you need to think about and solve ‘live’ is the selvedge – the
edges of the fabric. In order to keep the weave from falling apart you
need to ‘tweak’ the first and last warp thread based on which weft yarn
colour thread you are using. The different weft threads also need to go
over/under each other in a suitable manner which interacts with
this. This will be important to include in the simulation properly, but
this will only give an early indication of problematic decisions, rather
than a failsafe solution.

![](figures/comp.jpg)

Here’s a closeup of the meander pattern compared to the simulation. The
yarn is cheap and a bit fuzzy, but hopefully you can see the structure –
the differences are interesting. I’m not sure how this will distort
further when I remove it from the loom and the tension is gone.

There are three types of limitation that I’d like to note and think
about (especially in terms of incorporating them in a programming
language). One is the selvedge, as I mentioned earlier – another is
floats, which cause the problems on the meander pattern (long threads
not incorporated into the fabric). The third is more subtle, some
sequences of sheds cause problems when packing down the weft, for
example if you are not too careful you can cause the ordering of the
weft colours to be disrupted in some situations.

- reverse of matrix, input looms state, outputs structure
- colour pattern is side effect of thread rendering order
ee

Represents weaving via the shed operation, rather than a cellular matrix - closer to continuous form
 
Failures
- no selvedge
- floats failure mode not obvious (example meander) 
- impossible warping (double hookup) relies on loom knowledge to get right
