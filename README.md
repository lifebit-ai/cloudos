
# cloudos

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build status](https://github.com/lifebit-ai/cloudos/workflows/R-CMD-check/badge.svg)](https://github.com/lifebit-ai/cloudos/actions)
<!-- badges: end -->

The 'CloudOS' client library for R makes it easy to interact with CloudOS <https://cloudos.lifebit.ai/> in the R environment for analysis.

## Installation

You can install the released version of cloudos from [GitHub](https://github.com/lifebit-ai/cloudos/) at this moment. (Will be listed on  [CRAN](https://CRAN.R-project.org) as well)

``` r
if (!require(remotes)) { install.packages("remotes") }
  remotes::install_github("lifebit-ai/cloudos")
```

## Example

This is a basic example.

``` r
library(cloudos)

extract_participants(baseurl= "https://cloudos.lifebit.ai", 
              auth = "Bearer ***token***",
              raw_data = "a JSON string for selected participants")

```

