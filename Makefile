EMACS ?= emacs

ELPA_DEPENDENCIES=package-lint let-alist buttercup org-vcard helm async

ELPA_ARCHIVES=melpa-stable gnu

TEST_BUTTERCUP_OPTIONS  = .
LINT_CHECKDOC_FILES	= $(wildcard *.el) $(wildcard test/*.el)
LINT_PACKAGE_LINT_FILES	= $(wildcard *.el)
LINT_COMPILE_FILES	= ${LINT_CHECKDOC_FILES}

makel.mk:
	# Download makel
	@if [ -f ../makel/makel.mk ]; then \
		ln -s ../makel/makel.mk .; \
	else \
		curl \
		--fail --silent --show-error --insecure --location \
		--retry 9 --retry-delay 9 \
		-O https://github.com/DamienCassou/makel/raw/v0.8.0/makel.mk; \
	fi

.PHONY: test
test:
	@EMACS=$(EMACS) cask exec buttercup -L .

# Include makel.mk if present
-include makel.mk
