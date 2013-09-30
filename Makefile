
export PYTHONPATH=.
PYVOWS = ./test/pyvows.sh

all: lint test

docs: build_docs

build_docs:
	cd docs && make html && find . -name '*.html' -exec sed -i -r 's/((src)|(href))="(_static)/\1="http:\/\/sphinx-doc.org\/\4/g' {} \;

lint:
	pylint jwt test bench

test: run_test

run_test:
	$(PYVOWS) test

coverage: run_coverage

run_coverage:
	$(PYVOWS) --cover --cover-package jwt --cover-report coverage/coverage.xml test && sed -r -i 's/(<head>)/\1<base href="http:\/\/nedbatchelder.com\/code\/coverage\/sample_html\/">/g' coverage/html/index.html

bench: run_bench

run_bench:
	for b in ./bench/*_bench.py; do $$b; done

bench_gfm: 
	for b in ./bench/*_bench.py; do $$b --gfm; done

dev_deps:
	mkdir -p node_modules && npm install jsjws sinon
