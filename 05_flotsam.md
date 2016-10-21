# Flotsam Raspberry Pi Simulation

Flotsam is a prototype screenless tangible programming language largely
built from driftwood. Constructed in order to experiment with tangible
hardware for teaching children programming, it is based on the same L
system as used for the mathematickal arts workshop. It describes weave
structure and patterns with wooden blocks representing yarn width and
colour. The L system production rules for the warp/weft yarn sequences
are constructed from the the positions the blocks are plugged into using
a custom hardware interface.

![](figures/flotsam.jpg)

The weaving simulation is running on a Raspberry Pi computer which is
simultaneously reading the yarn token block hardware. The system is
designed to describe different weave patterns than those possible with
Jacquard looms, by including simple additional yarn properties beyond
colour. The version shown in the figure above is restricted to plain
weave, but more complex structures can be created as shown below:

![](figures/star.png)

The flotsam tangible hardware was used in primary schools and private
tutoring with children, and was designed so the blocks could be used in
many different ways. Experiments beyond weaving included an interface
with the Minecraft 3D game and a live music synthesiser.

As in the Mathematickal Arts workshop, the L system approach is good for
quick exploration of the huge variety of weaving patterns. However, one
of the core goals for the weavingcodes project was to develop artefacts
and interfaces for understanding how weavers think, and this was a
markedly different approach - so proved challenging for this aim.

The visualisation technique also demonstrated an interesting limitation,
as in common with many similar models does not take into account the
selvedge of the fabric - it is conceptually an infinite grid of cellular
elements rather than representing a continuous thread.

During use we observered the findings of
["Comparing the Use of Tangible and Graphical Programming Languages for Informal Science Education": http://cci.drexel.edu/faculty/esolovey/papers/chi09.horn.pdf]
in that the tangible interace proved better for collaborative learning
than a wholly screen based system. The design of the system itself
needed further development, which we followed up in the 'pattern matrix'
- a tangible system designed specifically for weaving.

