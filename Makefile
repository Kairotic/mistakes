all: mistakes.pdf

mistakes.pdf: introduction.md mathematikal.md fourshaft.md tablet.md flotsam.md wwl.md representations.md dyadic.md dyadic-browser.md toothpaste.md
	pandoc introduction.md mathematikal.md fourshaft.md tablet.md flotsam.md wwl.md representations.md dyadic.md dyadic-browser.md toothpaste.md -o mistakes.pdf

clean:
	rm -f mistakes.pdf mistakes.doc

