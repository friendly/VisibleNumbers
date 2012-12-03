MAIN = MilestonesProject
MS=$(MAIN)
VERSION =
TGZFILE = $(MS)$(VERSION).tar.gz
ZIPFILE  = $(MS)${VERSION}.zip
ZIPSUPP = $(MS)-suppfiles.zip

# Stuff for making the archives
TEXDEPEND = texdepend
TAR = /bin/tar
ZIP = /usr/bin/zip
BIBTOOL = bibtool -- quiet=on -r ~/texmf/bibtex/bib/aux2bib.rsc

#  latex or  pdflatex?
LATEX = pdflatex
# name of BibTeX command
BIBTEX = bibtex

# LaTeX flags
LATEXFLAGS = -interaction=nonstopmode


##
# texdepend, v0.96 (Michael Friendly (friendly@yorku.ca))
# commandline: texdepend FriendlySigal2012
#
INCLUDES = intro.tex project.tex vistime.tex historiography.tex playfair.tex
#
PACKAGES = article.cls geometry.sty natbib.sty color.sty mdwlist.sty graphicx.sty url.sty comment.sty
#
FIGS = fig/langren-google-overlay2.pdf fig/mileyears4.png fig/datavis-schema-3.pdf fig/datavis-timeline2.png fig/timespan.pdf fig/Adams1881-5.pdf fig/milecatline.pdf fig/Playfair1821b.jpg fig/wheat1.pdf fig/lifespan3.pdf fig/authormap.png fig/milecats4.pdf

#BIB_FILES = ./references.bib
BIB_FILES = ${MAIN}.bib
#
STYLES = /usr/share/texmf-texlive/tex/latex/geometry/geometry.sty /usr/share/texmf-texlive/tex/latex/graphics/keyval.sty /usr/share/texmf-texlive/tex/generic/oberdiek/ifpdf.sty /usr/share/texmf-texlive/tex/generic/oberdiek/ifvtex.sty /usr/share/texmf-texlive/tex/latex/natbib/natbib.sty /usr/share/texmf-texlive/tex/latex/graphics/color.sty /usr/share/texmf-texlive/tex/latex/mdwtools/mdwlist.sty /usr/share/texmf-texlive/tex/latex/graphics/graphicx.sty /usr/share/texmf-texlive/tex/latex/graphics/graphics.sty /usr/share/texmf-texlive/tex/latex/graphics/trig.sty /usr/share/texmf-texlive/tex/latex/ltxmisc/url.sty /home/friendly/texmf/tex/latex/misc/epigraph.sty /usr/share/texmf-texlive/tex/latex/comment/comment.sty
#


SHIPSTYLES = styles/*

EXTRAS = $(MAIN:%=%.aux) $(MAIN:%=%.bbl)  Makefile \
 $(SHIPSTYLES) 
# FIGLIST

ALLFILES = $(MAIN).tex $(MAIN).pdf  $(INCLUDES) $(BIB_FILES) $(FIGS) $(ALTFIGS) $(EXTRAS)

# Dependencies
#
paper:	$(MAIN).tex $(INCLUDES)
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	-@egrep -c 'Citation .* undefined.' $(MAIN).log && ($(BIBTEX) $(MAIN);$(LATEX) $(MAIN))
ifeq ($(LATEX),latex)
	dvipdf $(MAIN)
endif

${ZIPFILE}: ${ALLFILES}

${TARFILE}: ${ALLFILES}

${ZIPSUPP}: ${SUPPFILES}

$(MAIN).dvi: $(MAIN).tex $(FIGS)

$(MAIN).ps: $(MAIN).dvi

#  BUG:  Preamble lines are not included in the new bib file
#references.bib : $(MAIN).aux
#	aux2bib $(MAIN)
# Switch to using bibtool
${MAIN}.bib: $(MAIN).tex $(INCLUDES)
	$(BIBTOOL) -x $(MAIN).aux -o $(MAIN).bib
	
bib: $(MAIN).tex $(INCLUDES)
	$(BIBTOOL) -x $(MAIN).aux -o $(MAIN).bib
	
## Hand edited FIGLIST because of multiple images/fig
#FIGLIST:
#	$(TEXDEPEND) -format=1 -print=f $(MAIN)  | perl -pe 'unless (/^#/){\$f++; s/^/Figure \$f: /}' > FIGLIST
	


# Targets for archives
# note
zip: ${ALLFILES}
	$(ZIP) -r -u  $(ZIPFILE) $(ALLFILES)

tar: ${ALLFILES}
	$(TAR) cvhf - $(ALLFILES) | $(GZIP) > $(TGZFILE) 

#supp: ${SUPPFILES}
#	$(ZIP) -r -u  $(ZIPSUPP) $(SUPPFILES)

git-push: 
	git push -u origin master

git-pull: 
	git pull origin master
	
