.PHONY: build

run-docs:
	. .venv/bin/activate; mkdocs serve

install_uv:
	@if ! command -v uv >/dev/null 2>&1; then \
  		curl -LsSf https://astral.sh/uv/install.sh | sh; \
  	fi

setup:
	make install_uv
	uv venv
	uv pip install . -U

deploy:
	. .venv/bin/activate; mkdocs gh-deploy --force

build:
	. .venv/bin/activate; mkdocs build

build-check:
	. .venv/bin/activate; mkdocs build --strict

clean:
	rm -rf site .cache
