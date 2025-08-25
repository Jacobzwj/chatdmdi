#' Launch ChatDMDI in a background process and open a viewer
#'
#' @param model Character scalar; model name passed to ellmer::chat_openai.
#' @param api_key Character scalar; API key for the ChatDMDI-compatible endpoint.
#' @param base_url Character scalar; API base URL. Defaults to
#'   "https://chatdmdi.com.cuhk.edu.hk/v1".
#' @param port Integer scalar; Shiny port to serve the live browser. Defaults to 8765.
#' @param open_in_viewer Logical; open the viewer automatically (RStudio viewer if
#'   available, otherwise system browser). Defaults to interactive().
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
                     open_in_viewer = interactive()) {
  bg <- callr::r_bg(
    function(model, api_key, base_url, port) {
      library(ellmer)
      options(shiny.port = port)
      chat <- ellmer::chat_openai(
        model = model,
        api_key = api_key,
        base_url = base_url
      )
      ellmer::live_browser(chat)
    },
    args = list(model = model, api_key = api_key, base_url = base_url, port = port)
  )

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


