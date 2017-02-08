all: mistakes.tex mistakes.pdf

mistakes.tex: mistakes.md
	~/.cabal/bin/pandoc --bibliography=cite.bib --csl chicago-author-date.csl --listings mistakes.md -o mistakes.tex

mistakes.pdf: mistakes.tex master.tex
	pdflatex master.tex ; pdflatex master.tex

clean:
	rm -f mistakes.pdf mistakes.doc *log *aux mistakes.tex

