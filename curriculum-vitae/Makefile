all:    once

once: 
	latexmk -halt-on-error cv.tex > /dev/null

alert: 
	latexmk -halt-on-error cv.tex

clean: 
	rm -f *.log *.nlo *.idx cv.synctex* *.aux *.toc *.out ./misc/*.aux *.bbl *.bcf *.xml *.blg *.fdb* *.fls

clobber: 
	rm -f *.log *.nlo *.idx cv.synctex* *.aux *.toc *.out ./misc/*.aux *.bbl *.bcf *.xml *.blg *.fdb* *.fls *.pdf

#
#biber: (used when xelatex was used instead of latexmk)
#	make once
#	biber cv
#	make once
#	make once
#
