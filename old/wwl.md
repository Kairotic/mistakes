# Pattern matrix warp weighted loom simulation

One of the main objectives of our project was to provide a simulation
of the warp weighted loom to use in demonstrations, in order to
explore and share ancient weaving techniques. Beyond our previous
simulations we needed to show the actual weaving process, rather than
the end result, in order to explain how the structures and patterns
emerge. Weaving is very much a 3-dimensional process, and our previous
visualisations failed to show this well.

\begin{figure}
\begin{center}
\subfloat[Sketch by Ellen Harlizius-Klück while explaining the warp weighted loom (left) and resulting simulation (right).]{\includegraphics[width=0.5\textwidth]{figures/15-twin.jpg}}
\hspace{0.5em}
\subfloat[The \emph{pattern matrix} design.]{\includegraphics[width=0.4\textwidth]{figures/16-pm1.jpg}}
\end{center}
\caption{Design sketches that lead to the \emph{Pattern Matrix}}
\end{figure}

We built a 3D simulation of a warp weighted loom which ran on a
Raspberry Pi computer, which allows for easy integration with our
experimental hardware.


Following our experience with the Flotsam prototype, we decided to
explore tangible programming further. The pattern matrix was the next
step, specialised for weaving and built by Makernow (Oliver Hatfield,
Andrew Smith, Justin Marshall; <http://www.makernow.co.uk/>) and FoAM
Kernow. The pattern matrix was initially designed for use in Miners
Court, an extra care housing scheme in Redruth, Cornwall alongside
other crafts and technology workshops as part of the Future Thinking
for Social Living (<http://ft4sl.tumblr.com/>) project with Falmouth
University. This interface was developed further in a public setting,
during a project residency at Museum für Abgüsse Klassischer Bildwerke
(Museum of Casts of Classical Sculpture) in Munich.

A technical challenge for the pattern matrix was to remove the need
for physical plugs, which proved problematic with the Flotsam
prototype. The affordability of the programming blocks themselves was
also important constraint, partly due to the need for use in public
places. We therefore designed the blocks as disks with no physical
connections, painted white and black on different sides, and
containing magnets so that the orientation and position of the disks,
via *hall effect* sensors in the base. The hall effect sensors detect
the polarity of nearby magnetic fields, and even with fairly weak
magnets we found we could put the sensors right next to each other and
still determine the difference between two opposed or aligned fields.

For the warp/weft weave pattern structure, we only need a single 'bit'
value to be detected per block, where on / off corresponds to over or
under. However for other features, such as yarn colour selection, we
needed to be able to represent more information, so allowed for four
bits to be encoded through the magnet alignments. Accordingly, we used
four hall effect sensors in a square, allowing us to detect rotation
and flipping of the blocks. At this point, we noticed that this has
parallels with tablet weaving -- both in terms of the notation, and
the flipping and rotation actions required to use the device. We found
that we can represent all sixteen possible states with only four
blocks -- if negative is `0` and positive is `1`, and we read the code
as binary numbers, clockwise from top left. The following shows the
four different magnet configurations we used in the blocks, how they
change their states with twisting and flipping, and the decimal
numbers these states represent:-

Starting state - decimal values: 0,1,5,6

    - -   + -   + -   - +
    - -   - -   - +   - +

Rotate clockwise - decimal values: 0,2,10,12

    - -   - +   - +   - - 
    - -   - -   + -   + +

Horizontal flip - decimal values: 15,11,10,12

    + +   + +   - +   - - 
    + +   + -   + -   + +

Rotate counter-clockwise - decimal values: 15,13,5,6

    + +   + -   + -   - + 
    + +   + +   - +   - +

Vertical flip - decimal values: 0,4,5,6

    - -   - -   + -   - + 
    - -   - +   - +   - +

\begin{figure}
\begin{center}
\includegraphics[width=0.5\textwidth]{figures/17-DSC_1064.jpg}
\caption{A member of staff at Miners Court extra care housing scheme trying the first working version of the tangible weavecoding. The Raspberry Pi displays the weave structure on the simulated warp weighted loom, with a single colour for each warp and weft thread.}
\end{center}
\end{figure}

The 3D warp weighted loom simulation was our first to include selvedge
calculation, as well as animating the shed lift and weft thread
movement. The inclusion of the selvedge, along with multiple weft
threads for the colour patterns meant that the possibilities for the
selvedge structure was very high. We don't yet have a way to notate
these possibilities, but at least we could finally visualise this, and
the simulation could be used to explain complexities in this ancient
weaving technique.

