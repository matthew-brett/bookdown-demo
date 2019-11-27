# Build Python notebook version
# See: https://github.com/rstudio/bookdown/issues/782
Sys.setenv(BOOK_ED='python-nb')
# Markdown output
fmt <- bookdown::markdown_document2(base_format=rmarkdown::md_document)
# Turn off citation links.
fmt$pandoc$args <- c(fmt$pandoc$args, '--metadata', 'link-citations=no')
bookdown::render_book('index.Rmd', fmt,
                      config_file='_bookdown.yml',
                      output_dir='_notebooks')
