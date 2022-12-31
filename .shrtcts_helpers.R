#   ____________________________________________________________________________
#   RStudio API Wrappers                                                    ####

get_document_context <- function() {
  rstudioapi::getActiveDocumentContext()
}

get_selected_text <- function(document_context) {
  document_context$selection[[1]]$text
}

get_selected_range <- function(document_context) {
  document_context$selection[[1]]$range
}


#   ____________________________________________________________________________
#   Generate Text                                                           ####

surround_selection <- function(selected_text, prefix, suffix) {
  paste0(prefix, selected_text, suffix)
}

generate_section_single_line <- function(text, delimiter, line_width) {
  prefix <- "# "
  whitespace_after_text <- " "

  length_text <- nchar(text)
  length_prefix <- nchar(prefix)
  length_whitespace <- nchar(whitespace_after_text)
  length_suffix <- line_width - length_prefix - length_text - length_whitespace

  suffix <- rep(delimiter, times = length_suffix) |> paste0(collapse = "")
  text_line <- paste0(prefix, text, whitespace_after_text, suffix)

  paste0(text_line, "\n")
}

generate_section_multi_line <- function(text, delimiter, line_width) {
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

  paste0(line_above, "\n", text_line, "\n")
}


#   ____________________________________________________________________________
#   Insert Text                                                             ####

insert_text <- function(text) {
  rstudioapi::insertText(text) |>
    capture.output() |>
    invisible()
}

insert_snippet <- function(snippet_trigger) {
  rstudioapi::insertText(snippet_trigger)
  rstudioapi::executeCommand("insertSnippet") |>
    capture.output() |>
    invisible()
}

replace_selection <- function(selected_range, selected_text, new_text) {
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
    document_context <- get_document_context()

    # Checks that a document is active
    if (!is.null(document_context)) {
      # Extracts selection as a string
      selected_text <- get_selected_text(document_context)
      selected_range <- get_selected_range(document_context)
      new_text <- surround_selection(selected_text, prefix, suffix)

      replace_selection(selected_range, selected_text, new_text)
    }
  }
}

insert_section <- function(generate_section_function, delimiter, line_width) {
  document_context <- get_document_context()

  # Checks that a document is active
  if (!is.null(document_context)) {
    selected_text <- get_selected_text(document_context)
    selected_range <- get_selected_range(document_context)
    new_text <- generate_section_function(selected_text, delimiter, line_width)

    replace_selection(selected_range, selected_text, new_text)
  }
}

insert_section_single_line <- function(delimiter, line_width = 80) {
  insert_section(generate_section_single_line, delimiter, line_width)
}

insert_section_multi_line <- function(delimiter, line_width = 80) {
  insert_section(generate_section_multi_line, delimiter, line_width)
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
