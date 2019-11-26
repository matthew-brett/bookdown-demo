python:
	BOOK_ED=python Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', config_file='_bookdown.yml')"

python-nb:
	BOOK_ED=python-nb Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', config_file='_bookdown.yml', output_dir='_notebooks', clean=FALSE)"

r:
	BOOK_ED=r Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', config_file='_bookdown_r.yml')"
