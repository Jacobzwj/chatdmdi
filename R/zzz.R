# internal package environment to store background process handle
.chatdmdi_env <- new.env(parent = emptyenv())

.chatdmdi_get_bg <- function() {
  if (!exists("bg", envir = .chatdmdi_env, inherits = FALSE)) {
    assign("bg", NULL, envir = .chatdmdi_env)
  }
  get("bg", envir = .chatdmdi_env, inherits = FALSE)
}

.chatdmdi_set_bg <- function(bg) {
  assign("bg", bg, envir = .chatdmdi_env)
  invisible(bg)
}

.chatdmdi_kill_bg_if_alive <- function(timeout_ms = 3000) {
  bg <- .chatdmdi_get_bg()
  if (!is.null(bg)) {
    # processx handle from callr::r_bg
    if (is.function(bg$is_alive) && isTRUE(bg$is_alive())) {
      try(bg$kill(), silent = TRUE)
      try(bg$wait(timeout = timeout_ms), silent = TRUE)
    }
  }
  .chatdmdi_set_bg(NULL)
}

.onUnload <- function(libpath) {
  # Best-effort cleanup on package unload
  .chatdmdi_kill_bg_if_alive()
}


