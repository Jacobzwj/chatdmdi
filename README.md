# chatdmdi

Minimal R wrapper to launch an `ellmer` live browser chat against a ChatDMDI-compatible API.

## Installation

Install from GitHub:

```r
install.packages("devtools")
devtools::install_github("Jacobzwj/chatdmdi")
```

## Usage

```r
library(chatdmdi)

# Provide your model and API key
chatdmdi(
  model = "o1",
  api_key = Sys.getenv("CHATDMDI_API_KEY"),
  # optional overrides
  # base_url = "https://chatdmdi.com.cuhk.edu.hk/v1",
  # port = 8765,
  # open_in_viewer = TRUE
)
```

By default the function starts a background process and opens the UI at
http://127.0.0.1:8765. If you're in RStudio, it opens in the Viewer pane.

## License

MIT


