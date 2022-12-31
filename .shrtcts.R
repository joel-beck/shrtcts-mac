# All commands currently supported by RStudio. The command IDs can be used in RStudio
# API calls such as rstudioapi::executeCommand().
# https://docs.rstudio.com/ide/server-pro/rstudio_ide_commands/rstudio_ide_commands.html


#   ____________________________________________________________________________
#   Addins                                                                  ####

#' Format on Save
#'
#' @description
#'   Format Document with styler Package and Save Document.
#' @interactive
#' @shortcut Cmd+S
function() {
  # format only .R and .Rmd files, but save all file types
  file_type <- tools::file_ext(rstudioapi::getActiveDocumentContext()$path)

  if (file_type %in% c("R", "Rmd", "qmd")) {
    styler:::style_active_file() |>
      capture.output() |>
      invisible()
  }

  rstudioapi::documentSave() |>
    capture.output() |>
    invisible()
}


#' Show Project TODOs
#'
#' @description Show Project TODOs
#' @interactive
#' @shortcut Ctrl+T
todor::todor_project_addin



#   ____________________________________________________________________________
#   Editor Utils                                                            ####

#' Run Code without moving Cursor
#'
#' @description Run Code as with Ctrl+Enter but without moving Cursor
#' @interactive
#' @shortcut Alt+Enter
function() {
  rstudioapi::executeCommand("executeCodeWithoutMovingCursor") |>
    capture.output() |>
    invisible()
}


#' Delete File
#'
#' @description
#'   Close Current Document without Saving
#' @interactive
# @shortcut Shift+Delete
function() {
  rstudioapi::documentClose(save = FALSE) |>
    capture.output() |>
    invisible()
}



#   ____________________________________________________________________________
#   R Markdown                                                              ####

#' New R Markdown
#'
#' @description Open New empty R Markdown Document and Insert Template
#' @interactive
#' @shortcut Cmd+Shift+N
function() {
  rstudioapi::documentNew(text = "", type = "rmarkdown")
  # requires snippet with name 'rmd'
  rstudioapi::insertText("rmd")
  rstudioapi::executeCommand("insertSnippet") |>
    capture.output() |>
    invisible()
}


#' Run Current Chunk and Advance
#'
#' @description Run Current RMarkdown Chunk and Advance to Next Chunk
#' @interactive
#' @shortcut Ctrl+Shift+Enter
function() {
  rstudioapi::executeCommand(commandId = "executeCurrentChunk")
  rstudioapi::executeCommand(commandId = "goToNextChunk") |>
    capture.output() |>
    invisible()
}



#   ____________________________________________________________________________
#   Text Highlighting                                                       ####

#' Italic
#'
#' @description
#'   If Editor has selection, transform current selection to italic font.
#'   If Editor has no selection, write between single stars.
#' @interactive
#' @shortcut Cmd+I
function() {
  source(here::here(".shrtcts_helpers.R"))
  highlight_text(snippet_text = "it", prefix = "*")
}


#' Bold
#'
#' @description
#'   If Editor has selection, transform current selection to bold font.
#'   If Editor has no selection, write between double stars.
#' @interactive
#' @shortcut Cmd+B
function() {
  source(here::here(".shrtcts_helpers.R"))
  highlight_text(snippet_text = "bo", prefix = "**")
}


#' Code Font
#'
#' @description
#'   If Editor has selection, transform current selection to code font.
#'   If Editor has no selection, write between backticks.
#' @interactive
#' @shortcut Cmd+E
function() {
  source(here::here(".shrtcts_helpers.R"))
  highlight_text(snippet_text = "in", prefix = "`")
}


#' Latex Math
#'
#' @description
#'   If Editor has selection, surround current selection by Dollar signs.
#'   If Editor has no selection, write between Dollar signs.
#' @interactive
#' @shortcut Cmd+L
function() {
  source(here::here(".shrtcts_helpers.R"))
  highlight_text(snippet_text = "la", prefix = "$")
}


#' Inline R Code
#'
#' @description
#'   If Editor has selection, transform current selection to inline R code.
#'   If Editor has no selection, write new inline R code.
#' @interactive
#' @shortcut Cmd+Shift+I
function() {
  source(here::here(".shrtcts_helpers.R"))
  highlight_text(snippet_text = "inl", prefix = "`r ", suffix = "`")
}



#   ____________________________________________________________________________
#   Insert Text                                                             ####

#' Insert %*% Operator
#'
#' @description Insert %*% Operator at current Cursor Location
#' @interactive
function() {
  rstudioapi::insertText(" %*% ") |>
    capture.output() |>
    invisible()
}




#   ____________________________________________________________________________
#   Currently unused                                                        ####

#' Cut Current Line
#'
#' @description Cut Current Line without Selection
#' @interactive
# @shortcut Cmd+X
function() {
  source(here::here(".shrtcts_helpers.R"))
  line_action_without_selection(action_name = "cutDummy")
}


#' Copy Current Line
#'
#' @description Copy Current Line without Selection
#' @interactive
# @shortcut Cmd+C
function() {
  source(here::here(".shrtcts_helpers.R"))
  line_action_without_selection(action_name = "copyDummy")
}
