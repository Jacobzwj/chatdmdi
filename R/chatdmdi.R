#' Launch ChatDMDI in a background process and open a viewer
#'
#' @param model Character scalar; model name passed to ellmer::chat_openai.
#' @param api_key Character scalar; API key for the ChatDMDI-compatible endpoint.
#' @param base_url Character scalar; API base URL. Defaults to
#'   "https://chatdmdi.com.cuhk.edu.hk/v1".
#' @param port Integer scalar; Shiny port to serve the live browser. Defaults to 8765.
#' @param open_in_viewer Logical; open the viewer automatically (RStudio viewer if
#'   available, otherwise system browser). Defaults to interactive().
#' @param force_open Logical; reserved for future use.
#'
#' @return Invisibly returns the background process handle.
#' @export
#' @import ellmer
#' @importFrom callr r_bg
#' @importFrom rstudioapi viewer isAvailable
#' @importFrom utils browseURL
chatdmdi <- function(model,
                     api_key,
                     base_url = "https://chatdmdi.com.cuhk.edu.hk/v1",
                     port = 8765,
                     open_in_viewer = interactive(),
                     force_open = FALSE) {
  # if an existing bg with same cfg is alive, just (re)open viewer
  if (exists(".chatdmdi_get_bg", mode = "function") &&
      exists(".chatdmdi_get_cfg", mode = "function")) {
    bg_prev <- .chatdmdi_get_bg()
    cfg_prev <- .chatdmdi_get_cfg()
    same_cfg <- !is.null(cfg_prev) &&
      isTRUE(cfg_prev$model == model) &&
      isTRUE(cfg_prev$base_url == base_url) &&
      isTRUE(as.integer(cfg_prev$port) == as.integer(port))
    if (same_cfg && !is.null(bg_prev) && is.function(bg_prev$is_alive) && isTRUE(bg_prev$is_alive())) {
      if (isTRUE(open_in_viewer)) {
        url <- sprintf("http://127.0.0.1:%s", port)
        if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
          rstudioapi::viewer(url)
        } else {
          utils::browseURL(url)
        }
      }
      return(invisible(bg_prev))
    }
    # different cfg or dead -> kill then restart
    if (exists(".chatdmdi_kill_bg_if_alive", mode = "function")) {
      .chatdmdi_kill_bg_if_alive()
    }
  }

  bg <- suppressMessages(suppressWarnings(callr::r_bg(
    function(model, api_key, base_url, port) {
      library(ellmer)
      options(shiny.port = port)
      chat <- ellmer::chat_openai(
        model = model,
        api_key = api_key,
        base_url = base_url
      )
      # Keep the chat session persistent across Viewer closes by
      # restarting the Shiny app whenever it stops.
      repeat {
        try(ellmer::live_browser(chat), silent = TRUE)
        Sys.sleep(0.2)
      }
    },
    args = list(model = model, api_key = api_key, base_url = base_url, port = port)
  )))

  # save handle and cfg for future reuse
  if (exists(".chatdmdi_set_bg", mode = "function")) .chatdmdi_set_bg(bg)
  if (exists(".chatdmdi_set_cfg", mode = "function")) .chatdmdi_set_cfg(model, base_url, port)

  if (isTRUE(open_in_viewer)) {
    url <- sprintf("http://127.0.0.1:%s", port)
    if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
      rstudioapi::viewer(url)
    } else {
      utils::browseURL(url)
    }
  }

  invisible(bg)
}


