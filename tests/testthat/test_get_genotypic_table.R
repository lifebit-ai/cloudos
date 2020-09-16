# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
#                         auth = Sys.getenv("cloudos_Bearer_token"),
#                         team_id = "5f046bf6c132dd15fdd1a525")
#   # test
#   genotypic_table <- cb_get_genotypic_table(my_cloudos)
#   expect_s3_class(genotypic_table, "data.frame")
# })

with_mock_api({
  test_that("Get a genotypic table", {
    
    # set a dummy cloudos credentials
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
                          auth = "Bearer token",
                          team_id = "5f046bf6c132dd15fdd1a525")
    # test
    genotypic_table <- cb_get_genotypic_table(my_cloudos)
    expect_s3_class(genotypic_table, "data.frame")
  })
})
