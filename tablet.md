# Tablet weaving simulation

Tablet weaving (also known as card weaving) is an ancient form of
textile pattern production, using cards which are rotated to provide
different sheds between warp threads. This technique produces long
strips of fabric, which in antiquity were used as the starting bands
and that form the borders of a larger warp weighted weaving.

Tablet weaving is extremely complex, so in a similar manner to the 4
shaft loom, we devised a language/notation to help better understand
it. As before, this language can be used either to drive a computer
simulation, or can be followed when weaving. The following shows the
output for a simple program written in this language, consisiting of
the single-instruction procedure `(weave-forward 16)`.

\begin{center}
\mbox{
\includegraphics[width=0.5\textwidth]{figures/06-forward16.png}
}
\end{center}

The language consists of such simple instructions to represent the
movement of the cards to create each shed. The previous example shows
a simple case where cards are moved a quarter-turn to create each of
16 sheds. The card rotations are shown on the left for each of 8
cards, the simulated weaving is on the right for the top and bottom of
the fabric. `(weave-forward 16)` turns all the cards a quarter turn,
adds one weft and repeats this 16 times.

In our simulation, the cards are set up with a double face weave on
square cards: black, black, white, white clockwise from the top right
corner. We can offset these cards from each other first, to change the
pattern. The `rotate-forward` instruction turns only the specified
cards a quarter turn forward without weaving a weft, illustrated in
the following code and simulated output:

\begin{center}
\begin{minipage}[c]{0.25\linewidth}
\includegraphics[width=1\textwidth]{figures/07-diagonal.png}
\end{minipage}
\hspace{0.5cm}
\begin{minipage}[c]{0.60\linewidth}
\lstset{language=Lisp}
\lstinputlisting{code/diagonal.scm}
\end{minipage}
\end{center}

One interesting limitation of tablet weaving is that it is not
possible to weave 32 forward quarter rotations without completely
twisting up the warp, so we need to go forward and backwards to make
something physically weavable. However as the below demonstrates, if we
do so, then a 'zig zag' pattern results.


\begin{center}
\begin{minipage}[c]{0.25\linewidth}
\includegraphics[width=1\textwidth]{figures/08-zigzag1.png}
\end{minipage}
\hspace{0.5cm}
\begin{minipage}[c]{0.60\linewidth}
\lstset{language=Lisp}
\lstinputlisting{code/zigzag.scm}
\end{minipage}
\end{center}

The following shows that a different starting pattern better matches the
stitch direction.


\begin{center}
\begin{minipage}[c]{0.25\linewidth}
\includegraphics[width=1\textwidth]{figures/09-zigzag2.png}
\end{minipage}
\hspace{0.5cm}
\begin{minipage}[c]{0.60\linewidth}
\lstset{language=Lisp}
\lstinputlisting{code/zigzag2.scm}
\end{minipage}
\end{center}

As an alternative to specifying rotation offsets as above, we can use
*twist* to form patterns. Accordingly, the `twist` command takes a
list of cards to twist, and results in these cards effectively
reversing their turn direction compared to the others, as demonstrated
below. With double faced weave, the twist needs to take place
when the cards are in the right rotation, otherwise we get an 'error',
such as that shown below:

\begin{center}
\begin{minipage}[c]{0.25\linewidth}
\includegraphics[width=1\textwidth]{figures/10-mip.png}
\end{minipage}
\hspace{0.5cm}
\begin{minipage}[c]{0.60\linewidth}
\lstset{language=Lisp}
\lstinputlisting{code/mip.scm}
\end{minipage}
\end{center}

If we put our encoded twists into repeating loops, we can make small
programs with complex results. You can see a comparison with the woven
form below, created by following the program by hand.
	  
\begin{center}
\begin{minipage}[c]{0.5\linewidth}
\includegraphics[width=1\textwidth]{figures/12-twistpat-comb.jpg}
\end{minipage}
\hspace{0.5cm}
\begin{minipage}[c]{0.35\linewidth}
\lstset{language=Lisp}
\lstinputlisting{code/twistpat-comb.scm}
\end{minipage}
\end{center}

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
