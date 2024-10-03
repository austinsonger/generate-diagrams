ifneq ("$(wildcard bash-tools/Makefile.in)", "")
	include bash-tools/Makefile.in
endif

REPO := austinsonger/generate-diagrams

CODE_FILES := $(shell git ls-files | grep -E -e '\.d2$$' -e '\.sh$$' -e '\.py$$' | sort)

SHELL := /usr/bin/env bash

main:
	@$(MAKE) diag

.PHONY: diag
diag: diagrams
	@:

.PHONY: graphs
graphs: diag
	@:

.PHONY: diagrams
diagrams: diagrams-python diagrams-d2
	@:

.PHONY: diagrams-python
diagrams-python:
	@if ! type -P dot >/dev/null 2>&1 || \
		! python3 -c 'import diagrams' 2>&1; then \
		$(MAKE) install-python; \
	fi
	@echo ==========================
	@echo Generating Python Diagrams
	@echo ==========================
	mkdir -p -v images
	$(MAKE) clean
	export CI=1; \
	for x in *.py; do \
		if [ "$$x" = template.py ]; then \
			continue; \
		fi; \
		echo "Generating $$x"; \
		python3 $$x; \
	done

.PHONY: diagrams-d2
diagrams-d2:
	@if ! type -P d2 >/dev/null 2>&1; then \
		$(MAKE) install-d2; \
	fi;
	@echo ======================
	@echo Generating D2 Diagrams
	@echo ======================
	mkdir -p -v images
	$(MAKE) clean
	for x in *.d2; do \
		if [ "$$x" = template.d2 ]; then \
			continue; \
		fi; \
		img="images/$${x%.d2}.svg"; \
		shebang="$$(head -n 1 "$$x" | grep '^#!/.*d2' | sed 's/^#!//' || :)"; \
		if [ -z "$$shebang" ]; then \
			shebang="d2 --theme 200"; \
		fi; \
		echo "Generating $$x"; \
		$$shebang "$$x" "$$img"; \
	done

.PHONY: d2
d2: diagrams-d2
	@:

.PHONY: py
py: diagrams-python
	@:

.PHONY: install
install: build
	@:

.PHONY: build
build: init
	@echo ==============
	@echo Diagrams Build
	@echo ==============
	@$(MAKE) git-summary
	@echo
	@$(MAKE) d2
	@echo
	@$(MAKE) py

.PHONY: init
init:
	@echo "running init:"
	git submodule update --init --recursive
	@echo

.PHONY: install-d2
install-d2:
	@echo ==============
	@echo Install D2
	@echo ==============
	@if ! type -P curl >/dev/null 2>&2; then \
		bash-tools/packages/install_packages.sh curl; \
	fi
	curl -fsSL https://d2lang.com/install.sh | sh -s --

.PHONY: python-version
python-version:
	@echo "Checking Python version..."
	@if ! python3 --version >/dev/null 2>&1; then \
		echo "Python 3 is not installed. Exiting..."; \
		exit 1; \
	else \
		python3 --version; \
	fi

.PHONY: install-python
install-python:
	@echo ==============
	@echo Install Python
	@echo ==============
        @$(MAKE) python-version

	if [ -z "$(CPANM)" ]; then make; exit $$?; fi
	$(MAKE) system-packages-python

	$(MAKE) python

.PHONY: python
python:
	@PYTHON=python3 PIP=pip3 PIP_OPTS="--ignore-installed" bash-tools/python/python_pip_install_if_absent.sh requirements.txt
	@echo
	@#$(MAKE) pycompile
	@echo
	@echo 'BUILD SUCCESSFUL (Diagrams)'

.PHONY: test
test: diagrams
	PYTHON=python3 bash-tools/checks/check_all.sh

.PHONY: clean
clean:
	@echo
	@echo "Git resetting images/ dir:"
	@echo
	git checkout images
	@echo
	@echo
	@echo "Removing *.pyc / *.pyo files:"
	@echo
	@rm -fv -- *.pyc *.pyo
	@echo
	@echo "Removing PNG / SVG files:"
	@echo
	@rm -fv -- *.png *.svg custom/*.png custom/*.svg
	@echo
	@echo "Removing intermediate dot files of the same name as Python files but without the prefix:"
	@for x in *.py; do rm -fv -- "$${x%.py}"; done
	@echo
	@#git status --porcelain --ignored | awk '/^!!/{print $2}' | xargs rm -fv --

.PHONY: fmt
fmt: init
	# Format all .d2 files
	d2 fmt *.d2 # custom/*.d2
	sleep 1
	
	# Check for macOS (Darwin) and set sed to gsed if needed
	if uname -s | grep Darwin; then \
		sed(){ gsed "$$@"; }; \
	fi;
	
	# Only run sed on directories if they exist
	if [ -d "custom" ]; then \
		sed -i 's|# !/|#!/|' custom/*.d2; \
	fi;
	if [ -d "templates" ]; then \
		sed -i 's|# !/|#!/|' templates/*.d2; \
	fi;
	sed -i 's|# !/|#!/|' *.d2;

	# Safely handle git checkout in existing directories
	for directory in . templates; do \
		if [ -d "$$directory" ]; then \
			pushd "$$directory" && \
			git checkout $$(git status --porcelain | awk '/^.T/{print $$2}') && \
			popd || \
			exit 1; \
		fi; \
	done
