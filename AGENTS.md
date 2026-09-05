# Project Overview

This is a LaTeX-based CV/resume project used to generate professional PDF (and HTML) resumes for two people: **Lucas Martin Sing** and **Bianca Eugenia Sozzi**. The project is based on the Friggeri CV template (MIT licensed) and is tailored for German job-market conventions (A4 paper, clean typography, structured sections).

The project is not a software application in the traditional sense; it is a document-generation codebase. There is no runtime server, no package manager, and no test suite. The "build artifacts" are PDF and HTML files.

# Technology Stack

| Component | Technology |
|-----------|------------|
| Document engine | XeLaTeX |
| Bibliography engine | Biber ( BibLaTeX backend ) |
| Template class | `friggeri-cv.cls` (custom LaTeX class) |
| Fonts | Roboto family (Roboto, Roboto Thin, Roboto Condensed Bold) |
| Graphics / layout | TikZ, `textpos`, `geometry` |
| HTML conversion | Pandoc |
| Build orchestration | GNU Make |

# Project Structure

```
cv-germany/
├── friggeri-cv.cls          # Custom LaTeX class that defines the CV layout,
│                              # colors, fonts, header, aside (sidebar), entrylist,
│                              # bibliography drivers, and social-media logos.
├── lucas.tex                  # CV source for Lucas Martin Sing
├── bianca.tex                 # CV source for Bianca Eugenia Sozzi
├── bibliography.bib           # Shared BibTeX database (publications)
├── makefile                   # Build targets for PDF and HTML output
├── resources/                 # Logo icons (PDF format) used in the sidebar
│   ├── pin.pdf
│   ├── f_logo.pdf
│   ├── twitter_logo.pdf
│   ├── linkedin_logo.pdf
│   ├── vk_logo.pdf
│   └── web_logo.pdf
├── lucas/                     # Build output directory for Lucas (generated)
│   └── Lucas Martin Sing Resume.pdf
├── bianca/                    # Build output directory for Bianca (generated)
│   └── Bianca Eugenia Sozzi Resume.pdf
├── lucas.bbl / bianca.bbl     # BibLaTeX auxiliary files (generated)
├── lucas.blg / bianca.blg     # Biber log files (generated)
├── .gitignore                 # Ignores LaTeX intermediates and PDFs at repo root
├── README.md                  # Human-facing documentation (fonts, manual compile)
└── LICENSE                    # MIT License
```

# Build System

All compilation is driven by `makefile`. The workflow follows the standard BibLaTeX four-pass compile: `xelatex → biber → xelatex → xelatex`.

## Build Commands

| Command | Description |
|---------|-------------|
| `make` or `make all` | Builds both PDFs (`lucas` + `bianca`) |
| `make lucas` | Builds `lucas/Lucas Martin Sing Resume.pdf` |
| `make bianca` | Builds `bianca/Bianca Eugenia Sozzi Resume.pdf` |
| `make all_html` | Builds both HTML versions |
| `make lucas_html` | Builds `lucas/lucas.html` via Pandoc |
| `make bianca_html` | Builds `bianca/bianca.html` via Pandoc |
| `make clean` | Deletes `lucas/` and `bianca/` directories |

## Manual Compile (without Make)

```bash
xelatex -interaction=nonstopmode lucas.tex
biber lucas
xelatex -interaction=nonstopmode lucas.tex
xelatex -interaction=nonstopmode lucas.tex
```

Repeat for `bianca.tex`. Output directories must be created manually if you want the same layout as the Makefile.

## Requirements

- **XeLaTeX** (must support `fontspec` and `unicode-math`)
- **Biber** ( BibLaTeX backend; do not use classic `bibtex` )
- **Roboto fonts** installed system-wide (Roboto, Roboto Thin, Roboto Condensed Bold)
- **Pandoc** (only if building HTML targets)

# Code Organization & Template Architecture

## `friggeri-cv.cls` — The Layout Engine

This is the heart of the project. It is a LaTeX class file that:

1. **Loads base class** `article` with custom paper-size support (`a4paper` option).
2. **Defines colors** — a palette of grays and accent colors (blue, red, orange, green, purple). The `nocolors` option collapses all accents to gray. `lightheader` inverts the header background.
3. **Configures fonts** via `fontspec`:
   - Body: Roboto Light
   - Headings: Roboto Condensed Bold
   - Thin decorative text: Roboto Thin
4. **Renders the header** as a TikZ rectangle with name and job title.
5. **Provides the `aside` environment** — a right-aligned sidebar block positioned with `textpos` for contact info, languages, and skills.
6. **Defines list environments**:
   - `entrylist` — a `longtable`-based two-column list for education, awards, etc.
   - `\entry{date}{title}{subtitle}{description}` — generic entry.
   - `\entryexperience{from}{to}{company}{location}{details}{skills}` — work experience.
   - `\entryproject{from}{to}{name}{org}{description}{url}` — project entries.
7. **Implements bibliography formatting** for BibLaTeX with custom drivers for `article`, `book`, `inproceedings`, `misc`, and `report` that hyperlink titles and print author lists in light gray.
8. **Adds social-media glyph commands** (`\pin`, `\flogo`, `\tlogo`, `\llogo`, `\vklogo`, `\weblogo`) that insert small PDF logos from `resources/`.
9. **Sets page geometry** — wide left margin (6.1 cm) to accommodate the sidebar, no headers/footers.

## Individual `.tex` Files

Each CV is a standalone document that:

- Declares `\documentclass[a4paper,nocolors]{friggeri-cv}`
- Loads `marvosym` for phone/email glyphs
- Loads `graphicx` and `hyperref` as needed
- Calls `\addbibresource{bibliography.bib}` if publications are used
- Uses `\header{First }{Last}{Job Title}` to render the top banner
- Fills the `aside` environment with contact details, languages, and skill dots
- Fills `entrylist` blocks for experience, education, awards, and projects

# Development Conventions

- **Paper size**: Always use `a4paper` option (German standard).
- **Color mode**: Both CVs currently use `nocolors` for a conservative, grayscale look suitable for German employers.
- **Skill rating**: Five-dot scale using `\filleddot` (black square) and `\emptydot` (empty square).
- **Date formatting**: Free-form text in the left column of entries (e.g., `Aug 2024`, `2012--2019`).
- **Multiline descriptions**: Inside `\entryexperience` and `\entryproject`, use `•` bullet characters or `\\` line breaks. Keep blank lines minimal to avoid spurious paragraph breaks inside the `longtable` cells.
- **Logo assets**: All icons in `resources/` are PDFs (vector), ensuring crisp rendering at any resolution.
- **Shared bibliography**: `bibliography.bib` lives at the repository root. The `bianca` build target creates a symlink inside `bianca/` because Biber expects the `.bib` file to be reachable from the working directory or input directory.

# Git Hygiene

`.gitignore` is configured to ignore LaTeX auxiliary files and PDFs at the repository root:

```
*.aux
*.bbl
*.bcf
*.blg
*.log
*.out
*.run.xml
*.pdf
```

However, generated files inside `lucas/` and `bianca/` are **not** ignored by `.gitignore` at this time. If you do not want build artifacts committed, add `lucas/` and `bianca/` to `.gitignore`.

# Testing & Quality Assurance

There is no automated test suite. Quality assurance is manual:

1. Run `make clean && make` and verify that both PDFs are created without errors.
2. Inspect the PDF for overflow, misaligned sidebar, or broken hyperlinks.
3. Check that Biber resolved bibliography entries correctly (if publications are cited).
4. For HTML output, open the generated `.html` files in a browser and verify Pandoc conversion fidelity.

# Security Considerations

- The project processes only local `.tex`, `.bib`, and `.pdf` logo files. There is no network I/O during compilation.
- `xelatex` and `biber` execute with the privileges of the user running `make`. As with any LaTeX project, avoid compiling untrusted `.tex` sources because LaTeX can execute shell commands via `\write18` if enabled.
- No secrets, credentials, or API keys are present in the source files.

# Common Pitfalls for Agents

- **Do not switch to `pdflatex`**: The template relies on `fontspec` and system fonts (Roboto), which require XeLaTeX or LuaLaTeX.
- **Do not use `bibtex`**: The class configures BibLaTeX with `backend=biber`. Using `bibtex` will fail.
- **Do not delete `resources/`**: The logo commands hard-code paths like `resources/pin`. Moving or renaming these files breaks the sidebar icons.
- **Watch out for special characters in URLs**: `hyperref` is loaded, but URLs with `%`, `#`, `&`, etc., should be properly escaped or wrapped in `\url{}`.
- **Keep the wide left margin**: The `aside` environment is absolutely positioned. Changing `geometry` margins without updating the `textblock` coordinates in `friggeri-cv.cls` will misplace the sidebar.
