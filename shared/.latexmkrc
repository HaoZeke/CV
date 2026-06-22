# Shared latexmk config. Compile from build/<variant>/ so paths reach ../../shared/.
$pdflatex = "xelatex -interaction=nonstopmode -halt-on-error %O %S";
$pdf_mode = 5;  # xelatex
$biber = 'biber %O %S';
$clean_ext = 'bbl bcf run.xml';
$ENV{'TEXINPUTS'} = '../../shared/:' . ($ENV{'TEXINPUTS'} || '');
$ENV{'BIBINPUTS'} = '../../shared/:' . ($ENV{'BIBINPUTS'} || '');
