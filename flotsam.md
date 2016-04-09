# flotsam raspberry pi simulation

Flotsam is a prototype screenless tangible programming language largely
built from driftwood. It is a declarative style L system for describing
weave structure and pattern with yarn width and colour. It uses physical
blocks that represent blue and pink yarn in two widths, with rules to
produce a warp/weft yarn sequence based on the rows the blocks are
plugged into on a custom interface:

![](figures/flotsam.jpg)

The weaving simulation is written in pygame, and is deliberately
designed to make alternative weave structures than those possible with
Jacquard looms by including yarn properties. The version in the video is
plain weave, but more complex structures can be defined as below – in
the same way as Alex’s gibber software:

![](figures/star.png)

    # return warp or weft, dependant on the position
    def stitch(self, x, y, warp, weft):
        #if x % 2 == y % 2:
        if self.structure[x%self.width+(y%self.height)*self.width]==1:
            return warp
        else:
            return weft

self.structure is an array width*height that determines the pattern
structure can be read from block pattern in tangible hardware or preset
with tangible hardware controlling the colour sequence

Failures
- tangible hardware (lsystem) not representing how weavers think
- visualisation is cellular rather than representing continuous thread
