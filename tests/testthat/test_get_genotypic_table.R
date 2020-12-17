# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
#                                 auth = Sys.getenv("test_cloudos_apikey"),
#                                 team_id = Sys.getenv("test_cloudos_team_id"))
#   # test
#   genotypic_table <- cb_get_genotypic_table(my_cloudos)
#   expect_s3_class(genotypic_table, "data.frame")
# })

with_mock_api({
  test_that("Get a genotypic table", {
    
    # set a dummy cloudos credentials
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
                          auth = "apikey",
                          team_id = "5f7c8696d6ea46288645a89f")
    # test
    genotypic_table <- cb_get_genotypic_table(my_cloudos)
    expect_s3_class(genotypic_table, "data.frame")
  })
})
