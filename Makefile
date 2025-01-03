.SUFFIXES:
.DELETE_ON_ERROR:

MAKEFLAGS += --no-builtin-rules
SHELL := /bin/bash -e -c

TEMPLATES := $(wildcard templates/*)

all: README.md

.PHONY: clean
clean:
	rm -rf tmp

tmp/.dir:
	mkdir '$(@D)' && touch $@

tmp/repos.json: | tmp/.dir
	curl --fail --silent --show-error -o $@ \
		-H 'Accept: application/vnd.github+json' \
		$${GITHUB_TOKEN:+-H "Authorization: Bearer $${GITHUB_TOKEN}"} \
		'https://api.github.com/users/hansmi/repos?type=owner&per_page=100'

README.md: tmp/repos.json generate $(TEMPLATES)
	./generate $< > $@
