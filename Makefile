CASK ?= cask
EMACS ?= emacs

all: test

check: unit

unit:
	${CASK} exec ert-runner

install:
	${CASK} install
