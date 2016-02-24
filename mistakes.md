


## Mathematickal arts workshop (foam brussels)

plain weave kernel
- used for lsystem colour pattern simulation

     ; return warp or weft, dependant on the position
     (define (stitch x y warp weft)
       (if (eq? (modulo x 2)
                (modulo y 2))
           warp weft))

this function prints plain weave given warp and weft, and returns lists where characters represent colours.
eg...

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


- pretty good, minimal

Failures: 
- no kernel matrix
- no selvedge

## flotsam raspberry pi simulation

Python, hardware integration - adding a matrix:

    # return warp or weft, dependant on the position
    def stitch(self, x, y, warp, weft):
        #if x % 2 == y % 2:
        if self.structure[x%self.width+(y%self.height)*self.width]==1:
            return warp
        else:
            return weft

self.structure is an array width*height that determines the pattern
structure can be read from block pattern in tangible hardware or preset with tangible hardware controlling the colour sequence

Failures
- tangible hardware (lsystem) not representing how weavers think
- visualisation is cellular rather than representing continuous thread

## Dyadic browser weaving
compiled scheme code and rendering based on camouflage pattern research
\cite{4dfb7697-399b-4aed-aac9-4a5b1e40677d} \cite{1e5bb01b-81de-4c67-9664-eee0cf0b5c31}

# Four shaft loom simulation

- reverse of matrix, input looms state, outputs structure
- colour pattern is side effect of thread rendering order
ee


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
         
     ;; return a weave description for one weft
     ;; provides a list of warp/weft yarn ordered for drawing
     (define (loom-weave-yarn l weft-yarn lift-counter)
       (map2
        (lambda (lift warp-yarn)
          (if (eq? lift 1)
             (list (string-append "warp-" warp-yarn)
                   (string-append "weft-" weft-yarn))
             (list (string-append "weft-" weft-yarn)
                   (string-append "warp-" warp-yarn))))
        (loom-shed l lift-counter)
        (loom-warp l)))`

Represents weaving via the shed operation, rather than a cellular matrix - closer to continuous form
 
Failures
- no selvedge
- floats failure mode not obvious (example meander) 
- impossible warping (double hookup) relies on loom knowledge to get right

# tablet weaving simulation

More complex due to braiding, resulting topmost thread is a function of turn direction, twist orientation and the previous turn direction.

    (define (flip a)
      (if (equal? a "s") "z" "s"))

    (define (card angle a b d c) (list angle a b d c "f" "f"))
    (define (card-angle c) (list-ref c 0))
    (define (card-a c) (list-ref c 1))
    (define (card-b c) (list-ref c 2))
    (define (card-d c) (list-ref c 3))
    (define (card-c c) (list-ref c 4))
    (define (card-memory c) (list-ref c 5))
    (define (card-previous-memory c) (list-ref c 6))
    
    (define (card-forward c)
      (list
       (card-angle c)
       (card-d c) (card-a c)
       (card-c c) (card-b c)
       "f"
       (card-memory c)))

    (define (card-back c)
      (list
       (card-angle c)
       (card-b c) (card-c c)
       (card-a c) (card-d c)
       "b"
       (card-memory c)))
    
    (define (card-flip c)
      (list
       (flip (card-angle c))
       (card-b c) (card-a c)
       (card-c c) (card-d c)
       (card-memory c)
       (card-previous-memory c)))

    (define (card-weave c)
      (if (equal? (card-memory c) "f")
          (list (card-b c) (card-d c))
          (list (card-a c) (card-c c))))
   
Intermediate weaving language....
   
Failures:

- can't be combined with warp weighted loom
- doesn't calculate reverse weave properly

# Pattern matrix warp weighted loom simulation

first attempt at including selvedge

uses 'jellyfish', a language compiled to bytecode for procedural 3D rendering

more tangible thoughts... magnets...

continous weft threads (multiple in the case of complex colour pattern) weave over/under straight warp threads

            (when (eq? weaving 1)
                  (calc-weft-z)
                  (set! weft-position (+ weft-position weft-direction))

                  ;; selvedge time?
                  (cond
                   ((> weft-count weft-total)
                    (set! weft-count 0)
                    (set! weft-position (- (+ weft-position selvedge-gap)
                                           weft-direction))
                    (set! weft-direction (* weft-direction -1))
                    (if (> 0 weft-direction)
                        (right-selvedge selvedge-gap)
                        (left-selvedge selvedge-gap))
                    (set! weaving 0)
                    (set! weft-position (- weft-position weft-direction)))
                   (else
                    (write! vertex
                            (+ weft-z weft-position)
                            (+ weft-position (+ weft-z (vector 2 1.3 0)))
                            (+ weft-position (+ weft-z (vector 2 0 0)))
                            (+ weft-z weft-position)
                            (+ weft-position (+ weft-z (vector 2 1.3 0)))
                            (+ weft-position (+ weft-z (vector 0 1.3 0))))
                    (set! vertex (+ vertex 6)))))


multiple weft threads/selvedge combination points towards a need to encode these properly

Failures

- threads are 2 dimensional ribbons
- reads from a matrix
- complexity in selvedge calculation

# Toothpaste

Extruding a profile according to instructions stored in texture coordinate memory, reading from behaviour language

            ;; advance position
            (set! pos (+ pos dir))
            ;; update direction with current rotation matrix
            (set! dir (tx-proj (addr cur-tx-a) (vector 1 0 0)))
            ;; read current sequence
            (set! seq-cur (read (+ seq-pos texture-start)))
            (cond
             ((eq? seq-cur 0)
              (init-mat)
              (trace dir)
              (set! pos (+ pos (* dir (- segments 1))))
              (set! t segments)
              )
             ((eq? seq-cur 1) (rotate-mat-y (/ 90 segments)))
             ((eq? seq-cur 2) (rotate-mat-y (/ -90 segments)))
             ((eq? seq-cur 3)
              (set! pos
                    (+ pos (*v (sincos (* (/ t (- segments 1)) 180))
                               (vector 0 1 0)))))
             ((eq? seq-cur 4)
              (set! pos
                    (+ pos (*v (sincos (* (/ t (- segments 1)) 180))
                               (vector 0 -1 0)))))
              )

            ;; apply to current
            (*m (addr tx-a) (addr cur-tx-a) (addr cur-tx-a))



Citation test \cite{Cocker_2013}
