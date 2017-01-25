# Four shaft loom simulation

Our four shaft loom simulation takes a different approach to that of
most weaving simulation software. One of our core aims is to gain
knowledge about the computational processes involved in weaving, and
so need to gain deep understanding of how a loom works. In much
contemporary weaving software, you 'draw' a two-dimensional image, and
the software then generates instructions for how it may be woven.
However our simulation does almost the exact inverse - you describe
the set up of the loom first, and it tells you what visual patterns
result. Our latter approach brings the three-dimensional structure of
a weave to the fore, allowing us to investigate the complex
interference patterns of warp and weft, only considering the visual
result in terms of the underlying structure it arises from.

Our model of a four-shaft loom calculates the *shed* (the gap between
ordered warp threads), processing each shaft in turn and using a
logical "OR" operation on each warp thread to calculate which ones are
picked up. This turns out to be the core of the algorithm -- an
excerpt of which is shown below:

~~~~ {.scheme}
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
~~~~
   
This code provides understanding of how the warping of a loom
corresponds to the patterns it produces, and may be quickly
experimented and played with in a way that is not possible on a
physical loom which would require time consuming re-warping with each
change. Here follow some example weaves. Colour wise, in all these
examples the order is fixed – both the warp and the weft alternate
light/dark yarns.

\begin{figure}[h]
\begin{center}
\includegraphics[width=0.5\textwidth]{figures/03-boxy.png}

\caption{\label{boxy}The interface for our four shaft loom simulation, showing heddles (above), lift plan (to the right) and simulated weave.}
\end{center}
\end{figure}

As with testing our understanding of plain weave as described in the
previous section, our next step was to try weaving the structures with
a real loom and threads, in order to test the patterns produced were
correct. A frame loom was constructed to weave these patterns, shown
in Figure \ref{frame-loom}. Here the shafts are sleyed to pick up the warp as defined
by the simulation's input (the checkboxes) seen in Fig. \ref{boxy}). The
threads (which form heddles) are tied on to wooden poles which are
pulled in different combinations during weaving. This is a similar
approach as that used in warp weighted looms, much faster than
counting threads manually each time. It is important to use thinner
threads than the warp for the heddles, but as they are put under
tension during the weaving process they do need to be
strong. Fittingly for this project, configuring the warp with heddles
felt very much like coding threads, with threads.

\begin{figure}[h]
\begin{center}
\subfloat[\label{frame-loom}Frame loom constructed to test our simulation]{\includegraphics[width=0.45\textwidth]{figures/04-frame-loom.jpg}}
  \hspace{1em}\subfloat[\label{meander}Close-ups of a simulated \emph{meander} pattern, and its actual weave (with floating threads)]{\includegraphics[width=0.45\textwidth]{figures/05-meander.jpg}}
  \caption{\label{four-shaft-loom}Testing our simulation of a four-shaft loom}
\end{center}
\end{figure}

Often a form of improvisation is required when weaving, even when
using a predefined pattern. There is a lot of reasoning required in
response to issues of structure that cannot be defined ahead of
time. You need to respond to the interactions of the materials and the
loom itself. The most obvious problem you need to think about and
solve ‘live’ as you go, is the selvedge – the edges of the fabric. In
order to keep the weave from falling apart you need to ‘tweak’ the
first and last warp thread based on which weft yarn colour thread you
are using. The different weft threads also need to go over/under each
other in a suitable manner which interacts with this.

In relation to computer programming, this improvisation at the loom is
analogous to *live coding*, where code is written 'on the fly', often
as a performing art such as music making. See Emma Cocker's article in
the present issue of Textile for deep investigation into the relation
between between live weaving and live coding.

Figure \ref{meander} shows close-ups of the simulated *meander* pattern and its
actual weave. There are clear differences visible between them, due to
the behaviour of the long 'floating' threads; the pattern would be
distorted further if the fabric were removed from the loom and the
tension lost. The extent to which it is possible, or even desirable to
include such material limitations into a weaving language or model was
one of our main topics of inquiry when talking to our advisers
(particularly esteemed industrial weaver Leslie Downes). Through
discussion, we came to understand that simulating such physical
interaction between threads is beyond even the even the most expensive
simulation software.

We have already mentioned two aspects of weaving which do not feature
in weaving software; the structure of selvedge, and the behaviour of
floats. We also noted a third, more subtle limitation: some sequences
of sheds cause problems when packing down the weft, for example if you
are not too careful you can cause the neat ordering of the weft
colours to be disrupted in some situations, where in practice they
overlap.

[//]: # Don't understand this bit, taken it out for now: This was a step in the right direction, as the model represents weaving via the shed operation rather than a cellular matrix, it brings it closer to a continuous form.
 
