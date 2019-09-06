all:    once

once: 
	cd curriculum-vitae && latexmk -halt-on-error cv.tex > /dev/null && cp -f cv.pdf ../RG_Latest-cv.pdf && cd ../onePage && latexmk -pdfxe -halt-on-error rgOnePage.tex > /dev/null

alert: 
	cd curriculum-vitae && latexmk -halt-on-error cv.tex

clean: 
	cd curriculum-vitae && rm -f *.log *.nlo *.idx cv.synctex* *.aux *.toc *.out ./misc/*.aux *.bbl *.bcf *.xml *.blg *.fdb* *.fls

clobber: 
	cd curriculum-vitae && rm -f *.log *.nlo *.idx cv.synctex* *.aux *.toc *.out ./misc/*.aux *.bbl *.bcf *.xml *.blg *.fdb* *.fls *.pdf

continous:
	cd curriculum-vitae && latexmk -pvc -view=none cv.tex
#
#biber: (used when xelatex was used instead of latexmk)
#	make once
#	biber cv
#	make once
#	make once
#
