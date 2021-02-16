library(testthat)
library(cloudos)

Sys.setenv(CLOUDOS_BASEURL = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api")
Sys.setenv(CLOUDOS_TEAMID = "5f7c8696d6ea46288645a89f")
Sys.setenv(CLOUDOS_TOKEN = "no real")

test_check("cloudos")
