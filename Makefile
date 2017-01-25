all: mistakes.tex mistakes.pdf

mistakes.tex: introduction.md mathematikal.md fourshaft.md tablet.md flotsam.md wwl.md representations.md dyadic.md
	~/.cabal/bin/pandoc --listings introduction.md mathematikal.md fourshaft.md tablet.md flotsam.md wwl.md representations.md dyadic.md -o mistakes.tex

mistakes.pdf: mistakes.tex master.tex
	pdflatex master.tex

clean:
	rm -f mistakes.pdf mistakes.doc *log *aux mistakes.tex

