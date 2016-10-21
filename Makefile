all: mistakes.pdf

mistakes.pdf: 01_introduction.md 02_dyadic.md 03_toothpaste.md 04_tablet.md 05_flotsam.md 06_fourshaft.md 07_mathematikal.md 08_wwl.md
	pandoc 01_introduction.md 02_dyadic.md 03_toothpaste.md 04_tablet.md 05_flotsam.md 06_fourshaft.md 07_mathematikal.md 08_wwl.md -o mistakes.pdf

mistakes.doc: 01_introduction.md 02_dyadic.md 03_toothpaste.md 04_tablet.md 05_flotsam.md 06_fourshaft.md 07_mathematikal.md 08_wwl.md
	pandoc 01_introduction.md 02_dyadic.md 03_toothpaste.md 04_tablet.md 05_flotsam.md 06_fourshaft.md 07_mathematikal.md 08_wwl.md -o mistakes.doc

clean:
	rm -f mistakes.pdf mistakes.doc

