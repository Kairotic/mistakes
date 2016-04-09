# Flotsam Raspberry Pi Simulation

Flotsam is a prototype screenless tangible programming language largely
built from driftwood. Based on the same L system as used for the
mathematickal arts workshop, it describes weave structure and patterns
with wooden blocks representing yarn width and colour. The L system
production rules for the warp/weft yarn sequences are constructed from
the the positions the blocks are plugged into using a custom hardware
interface.

![](figures/flotsam.jpg)

The weaving simulation is written running on a Raspberry Pi computer
which is simultaneously reading the yarn token blocks. The system is
designed to describe different weave patterns than those possible with
Jacquard looms, by including additional yarn properties beyond
colour. The version shown in the figure above is restricted to plain
weave, but more complex structures can be created as shown below:

![](figures/star.png)

The L system was 

Failures
- tangible hardware (lsystem) not representing how weavers think
- visualisation is cellular rather than representing continuous thread
