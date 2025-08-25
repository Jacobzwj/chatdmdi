# chatdmdi

A minimal R wrapper for using ChatDMDI in RStudio, based on the [ellmer](https://github.com/tidyverse/ellmer/) package.

## Installation

Install from GitHub:

```r
install.packages("devtools")
devtools::install_github("Jacobzwj/chatdmdi")
```


## Supported models

You can choose one of the following model names for the `model` parameter:

- gpt-4o-image-vip
- gpt-4.1
- claude-3-7-sonnet-20250219
- o1
- grok-3
- grok-3-reason
- claude-3-5-haiku-20241022
- deepseek-r1
- deepseek-v3
- gemini-2.0-flash
- gpt-4o-mini
- gpt-4o

## Usage

```r
library(chatdmdi)

# Choose the model name and API key
chatdmdi(
  model = "gpt-4o-mini",
  api_key ="sk-XXXXXXXXX", #your api_key from ChatDMDI website
)
```

By default the function starts a background process and opens the UI at
http://127.0.0.1:8765. If you're in RStudio, it opens in the Viewer pane.

## References

- ellmer: https://github.com/tidyverse/ellmer/

## License

MIT


