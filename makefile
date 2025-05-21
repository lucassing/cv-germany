.PHONY: lucas bianca

all: lucas bianca

lucas:
	mkdir -p lucas && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	biber --input-directory=lucas lucas && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	xelatex -interaction=nonstopmode -output-directory=lucas lucas.tex && \
	mv lucas/lucas.pdf "lucas/Lucas Martin Sing CV.pdf"

bianca:
	mkdir -p bianca && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	biber cv.bcf && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	xelatex -interaction=nonstopmode -output-directory=bianca bianca.tex && \
	mv bianca/bianca.pdf "bianca/Bianca Eugenia Sozzi CV.pdf"
	mv bianca.pdf "Bianca Eugenia Sozzi CV.pdf"