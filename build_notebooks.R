# Build Python notebook version
fmt = rmarkdown::md_document(variant='gfm')
fmt$pandoc$ext = ".gfm"
fmt <- bookdown::epub_book()
bookdown::render_book('index.Rmd', fmt,
                      config_file='_bookdown.yml',
                      output_dir='_notebooks')
