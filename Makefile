VENVDIR = ./build/venv
BINDIR = $(VENVDIR)/bin
PYTHON = $(BINDIR)/python
PIP = $(BINDIR)/pip
INSTALL = $(PIP) install

.PHONY: all
all:	build test

.PHONY: build
build: $(VENVDIR)/COMPLETE
$(VENVDIR)/COMPLETE: requirements.txt
	virtualenv --no-site-packages --distribute $(VENVDIR)
	$(INSTALL) --upgrade Distribute pip
	$(INSTALL) -r ./requirements.txt
	$(PYTHON) ./setup.py develop
	touch $(VENVDIR)/COMPLETE

.PHONY: test
test: $(BINDIR)/flake8 $(BINDIR)/nosetests $(BINDIR)/coverage
	$(BINDIR)/flake8 ./fxa
	$(BINDIR)/coverage erase
	$(BINDIR)/coverage run $(BINDIR)/nosetests ./fxa
	$(BINDIR)/coverage report --include="*fxa*"

$(BINDIR)/flake8: $(VENVDIR)/COMPLETE
	$(INSTALL) -U --force-reinstall flake8

$(BINDIR)/nosetests: $(VENVDIR)/COMPLETE
	$(INSTALL) -U --force-reinstall nose

$(BINDIR)/coverage: $(VENVDIR)/COMPLETE
	$(INSTALL) -U --force-reinstall coverage

.PHONY: shell
shell: $(VENVDIR)/COMPLETE
	$(PYTHON)