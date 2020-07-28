# Build Python notebook version
# See: https://github.com/rstudio/bookdown/issues/782
Sys.setenv(BOOK_ED='python-nb')
# Markdown output
fmt__ <- bookdown::markdown_document2(base_format=rmarkdown::md_document)
# Turn off citation links.
fmt__$pandoc$args <- c(fmt__$pandoc$args,
                       '--metadata',
                       'link-citations=no')
bookdown::render_book('index.Rmd', fmt__,
                      clean_envir=FALSE,
                      config_file='_bookdown.yml',
                      output_dir='_notebooks')
