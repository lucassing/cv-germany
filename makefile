.PHONY: lucas bianca

all: lucas bianca

lucas:
	mkdir -p lucas && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	biber --input-directory=lucas lucas && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	mv lucas/lucas.pdf "lucas/Lucas Martin Sing Resume.pdf"

bianca:
	mkdir -p bianca && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	ln -sf ../bibliography.bib bianca/bibliography.bib && \
	biber --input-directory=bianca bianca && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	mv bianca/bianca.pdf "bianca/Bianca Eugenia Sozzi Resume.pdf"