# Build Python notebook version
# See: https://github.com/rstudio/bookdown/issues/782
nb_document <- function () {
    fmt <- rmarkdown::md_document(variant='gfm')
    fmt$pandoc$ext = ".gfm"
    args = c()
    fig_caption = TRUE
    md_extensions = NULL
    number_sections = FALSE
    from = rmarkdown::from_rmarkdown(fig_caption, md_extensions)
    fmt$pre_processor = function(metadata, input_file, runtime, knit_meta,
                                 files_dir, output_dir) {
        bookdown:::process_markdown(input_file,
                                    from,
                                    args,
                                    number_sections)
        NULL
    }
    fmt
}

Sys.setenv(BOOK_ED='python-nb')
fmt <- nb_document()
bookdown::render_book('index.Rmd', fmt, clean=FALSE,
                      config_file='_bookdown.yml',
                      output_dir='_notebooks')
