.onLoad <- function(libname, pkgname, ...) {
  pkg.version <- utils::packageVersion("cloudos")
}

.onAttach <- function(libname, pkgname, ...) {
  startup_msg <- paste("\n",
                       "Welcome to Lifebit's CloudOS R client \n",
                       "For Documentation visit - https://lifebit-ai.github.io/cloudos/ \n",
                       "This package is under active development. If you found any issues, \n",
                       "Please reach out here - https://github.com/lifebit-ai/cloudos/issues \n",
                       sep="")
  
  packageStartupMessage(startup_msg)
}
