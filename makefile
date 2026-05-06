.PHONY: lucas bianca lucas_html bianca_html all all_html clean

# Tools
PANDOC ?= pandoc

# Common flags for HTML output
HTML_FLAGS = --from=latex --to=html5 --standalone --citeproc --mathjax

all: lucas bianca

all_html: lucas_html bianca_html


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


# ===== HTML (new) =====
lucas_html:
	mkdir -p lucas && \
	$(PANDOC) lucas.tex \
	  $(HTML_FLAGS) \
	  --metadata=title:"Lucas Martin Sing — Resume" \
	  --bibliography=bibliography.bib \
	  --output=lucas/lucas.html

bianca_html:
	mkdir -p bianca && \
	ln -sf ../bibliography.bib bianca/bibliography.bib && \
	$(PANDOC) bianca.tex \
	  $(HTML_FLAGS) \
	  --metadata=title:"Bianca Eugenia Sozzi — Resume" \
	  --bibliography=bianca/bibliography.bib \
	  --output=bianca/bianca.html

clean:
	rm -rf lucas bianca