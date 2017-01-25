EMACS=emacs
EMACSFLAGS=--batch -l ~/.emacs.d/org-export-init.el
LATEXMK=latexmk
LATEXMKFLAGS=-xelatex

all: sage-introduction.pdf

%.pdf: %.tex
	$(LATEXMK) $(LATEXMKFLAGS) $<

%.tex: %.org
	$(EMACS) $(EMACSFLAGS) $< -f org-latex-export-to-latex

clean:
	rm -f *.bbl *.aux *.out *.synctex.gz *.log *.run.xml *.blg *-blx.bib *.fdb_latexmk *.fls *.toc *.vrb *.snm *.nav

.PHONY: clean all
.PRECIOUS: %.tex
