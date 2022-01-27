library(testthat)
library(cloudos)

Sys.setenv(CLOUDOS_BASEURL = "api")
Sys.setenv(CLOUDOS_TEAMID = "5f7c8696d6ea46288645a89f")
Sys.setenv(CLOUDOS_TOKEN = "no real")

test_check("cloudos")

# CRAN requires path lengths within the package to be <100 chars long so they can be unpacked
# from a tarball correctly. This means the following for creating mock API tests with httptest:
# + Run the code that will comprise your test using a real API server and surround the code
#   with capture_requests({ ... }).
# + This will create a directory structure that matches the server url you used.
# + Now copy the 'v1' or 'v2' directory nested in that structure into tests/testthat/api/
# + Add your new unit test code in the tests/testthat directory.
