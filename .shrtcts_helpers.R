highlight_text <- function(snippet_text, prefix, suffix = NULL) {
  # if prefix and suffix are identical, specifying the prefix is sufficient
  if (is.null(suffix)) {
    suffix <- prefix
  }

  if (rstudioapi::selectionGet()$value == "") {
    rstudioapi::insertText(snippet_text)
    rstudioapi::executeCommand("insertSnippet") |>
      capture.output() |>
      invisible()
  } else {
    # Gets The Active Document
    ctx <- rstudioapi::getActiveDocumentContext()

    # Checks that a document is active
    if (!is.null(ctx)) {
      # Extracts selection as a string
      selected_text <- ctx$selection[[1]]$text

      # modify string
      selected_text <- paste0(prefix, selected_text, suffix)

      # replaces selection with string
      rstudioapi::modifyRange(ctx$selection[[1]]$range, selected_text)
    }
  }
}


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
