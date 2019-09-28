python:
	BOOK_ED=python Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', config_file='_bookdown.yml')"

python-nb:
	BOOK_ED=python-nb Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', output_format='html_book', config_file='_bookdown.yml')"

r:
	BOOK_ED=r Rscript -e \
			"bookdown::render_book('index.Rmd', 'bookdown::gitbook', config_file='_bookdown_r.yml')"
