insert_snippet <- function(snippet_text) {
  rstudioapi::insertText(snippet_text)
  rstudioapi::executeCommand("insertSnippet") |>
    capture.output() |>
    invisible()
}

get_selected_text <- function(document_context) {
  document_context$selection[[1]]$text
}

get_selected_range <- function(document_context) {
  document_context$selection[[1]]$range
}

replace_selection <- function(document_context) {
  # Extracts selection as a string
  selected_text <- get_selected_text(document_context)
  selected_range <- get_selected_range(document_context)

  new_text <- paste0(prefix, selected_text, suffix)

  # replaces selection with string
  rstudioapi::modifyRange(selected_range, new_text)
}

highlight_text <- function(snippet_text, prefix, suffix = NULL) {
  # if prefix and suffix are identical, specifying the prefix is sufficient
  if (is.null(suffix)) {
    suffix <- prefix
  }

  if (rstudioapi::selectionGet()$value == "") {
    insert_snippet(snippet_text)
  } else {
    document_context <- rstudioapi::getActiveDocumentContext()

    # Checks that a document is active
    if (!is.null(document_context)) {
      replace_selection(document_context)
    }
  }
}

section_single_line <- function(text, delimiter, line_width = 80) {
  prefix <- "# "
  whitespace_after_text <- " "

  length_text <- nchar(text)
  length_prefix <- nchar(prefix)
  length_whitespace <- nchar(whitespace_after_text)
  length_suffix <- line_width - length_prefix - length_text - length_whitespace

  suffix <- rep(delimiter, times = length_suffix) |> paste0(collapse = "")
  text_line <- paste0(prefix, text, whitespace_after_text, suffix)

  cat(text_line, "\n\n", sep = "")
}

section_multi_line <- function(text, delimiter, line_width = 80) {
  prefix <- "#   "
  whitespace_after_text <- " "
  line_end <- "####"

  length_text <- nchar(text)
  length_prefix <- nchar(prefix)
  length_whitespace <- nchar(whitespace_after_text)
  length_line_end <- nchar(line_end)

  length_suffix <-
    line_width - length_prefix - length_text - length_whitespace - length_line_end

  suffix <- rep(" ", times = length_suffix) |> paste0(collapse = "")

  line_above <- paste0(
    prefix,
    rep(delimiter, times = line_width - length_prefix) |> paste0(collapse = "")
  )
  text_line <- paste0(prefix, text, whitespace_after_text, suffix, line_end)

  cat(line_above, "\n", sep = "")
  cat(text_line, "\n\n", sep = "")
}



#   ____________________________________________________________________________
#   Currently unused                                                        ####

line_action_without_selection <- function(action_name) {
  selection <- rstudioapi::selectionGet()

  if (selection$value == "") {
    # get current document position
    current_row <- rstudioapi::getSourceEditorContext()$selection[[1]]$range$start[[1]]

    # set cursor to beginning of line
    rstudioapi::setCursorPosition(
      position = rstudioapi::document_position(row = current_row, column = 1)
    )

    # initial selection
    rstudioapi::executeCommand("expandSelection")
    selected <- rstudioapi::selectionGet()

    while (stringr::str_detect(selected, "\n", negate = TRUE)) {
      # expand selection until it reaches new line
      rstudioapi::executeCommand("expandSelection")
      selected <- rstudioapi::selectionGet()
    }

    # reverse last expansion to only select current line
    rstudioapi::executeCommand("shrinkSelection")

    # copy command must be return value
    rstudioapi::executeCommand(action_name) |>
      capture.output() |>
      invisible()
  } else {
    rstudioapi::executeCommand(action_name) |>
      capture.output() |>
      invisible()
  }
}
