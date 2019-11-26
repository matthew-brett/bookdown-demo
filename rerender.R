library(bookdown)

rerender <- function (input, output_format = NULL, ..., clean = TRUE, envir = parent.frame(), 
    clean_envir = !interactive(), output_dir = NULL, new_session = NA, 
    preview = FALSE, encoding = "UTF-8", config_file = "_bookdown.yml") 
{
    verify_rstudio_version()
    format = NULL
    if (is.list(output_format)) {
        format = output_format$bookdown_output_format
        if (!is.character(format) || !(format %in% c("latex", 
            "html"))) 
            format = NULL
    }
    else if (is.character(output_format)) {
        if (identical(output_format, "all")) {
            output_format = rmarkdown::all_output_formats(input, 
                "UTF-8")
        }
        if (length(output_format) > 1) {
            return(unlist(lapply(output_format, function(fmt) render_book(input, 
                fmt, ..., clean = clean, envir = envir, output_dir = output_dir, 
                new_session = new_session, preview = preview, 
                config_file = config_file))))
        }
        format = target_format(output_format)
    }
    if (clean_envir) 
        rm(list = ls(envir, all.names = TRUE), envir = envir)
    if (config_file != "_bookdown.yml") {
        unlink(tmp_config <- tempfile("_bookdown_", ".", ".yml"))
        if (file.exists("_bookdown.yml")) 
            file.rename("_bookdown.yml", tmp_config)
        file.rename(config_file, "_bookdown.yml")
        on.exit({
            file.rename("_bookdown.yml", config_file)
            if (file.exists(tmp_config)) file.rename(tmp_config, 
                "_bookdown.yml")
        }, add = TRUE)
    }
    on.exit(opts$restore(), add = TRUE)
    config = load_config()
    output_dir = output_dirname(output_dir, config)
    on.exit(clean_empty_dir(output_dir), add = TRUE)
    opts$set(output_dir = output_dir, input_rmd = basename(input), 
        preview = preview)
    aux_diro = "_bookdown_files"
    if (isTRUE(dir_exists(aux_dir2 <- file.path(output_dir, aux_diro)))) {
        if (!dir_exists(aux_diro)) 
            file.rename(aux_dir2, aux_diro)
    }
    aux_dirs = files_cache_dirs(aux_diro)
    move_dirs(aux_dirs, basename(aux_dirs))
    on.exit({
        aux_dirs = files_cache_dirs(".")
        if (length(aux_dirs)) {
            dir_create(aux_diro)
            move_dirs(aux_dirs, file.path(aux_diro, basename(aux_dirs)))
        }
    }, add = TRUE)
    if (is.na(new_session)) {
        new_session = FALSE
        if (is.logical(config[["new_session"]])) 
            new_session = config[["new_session"]]
    }
    main = book_filename()
    if (!grepl("[.][Rr]?md$", main)) 
        main = paste0(main, if (new_session) 
            ".md"
        else ".Rmd")
    delete_main = isTRUE(config[["delete_merged_file"]])
    if (file.exists(main) && !delete_main) 
        stop("The file ", main, " exists. Please delete it if it was automatically generated, ", 
            "or set a different book_filename option in _bookdown.yml. If you are sure ", 
            "it can be safely deleted, please set the option 'delete_merged_file' to true in _bookdown.yml.")
    on.exit(if (file.exists(main) && !delete_main) {
        message("Please delete ", main, " after you finish debugging the error.")
    }, add = TRUE)
    opts$set(book_filename = main)
    files = setdiff(source_files(format, config), main)
    if (length(files) == 0) 
        stop("No input R Markdown files found from the current directory ", 
            getwd(), " or in the rmd_files field of _bookdown.yml")
    if (new_session && any(dirname(files) != ".")) 
        stop("All input files must be under the current working directory")
    res = if (new_session) {
        render_new_session(files, main, config, output_format, 
            clean, envir, ...)
    }
    else {
        render_cur_session(files, main, config, output_format, 
            clean, envir, ...)
    }
    # file.remove(main)
    res
}
