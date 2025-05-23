SHELL := /bin/bash

.PHONY: all clean python lean coq

all: main.pdf

main.pdf: main.tex sections/example.tex references.bib
	docker-compose run --rm latex lualatex main.tex
	docker-compose run --rm latex bibtex main
	docker-compose run --rm latex lualatex main.tex
	docker-compose run --rm latex lualatex main.tex

clean:
	rm -f *.aux *.bbl *.blg *.log *.out *.pdf

python:
	docker-compose run --rm python python $(filter %.py,$(MAKECMDGOALS))

lean:
	docker-compose run --rm lean lean $(filter %.lean,$(MAKECMDGOALS))

coq:
	docker-compose run --rm coq coqc $(filter %.v,$(MAKECMDGOALS))

# Example: make python SCRIPT=myscript.py
# Example: make lean FILE=myfile.lean
# Example: make coq FILE=myfile.v 