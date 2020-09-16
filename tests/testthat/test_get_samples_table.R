# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
#                         auth = Sys.getenv("cloudos_Bearer_token"),
#                         team_id = Sys.getenv("cloudos_team_id"))
#   # set a dummy cohort object
#   my_cohort <- cohort(my_cloudos, cohort_id = "5f6228133097cc7a6504fb76")
#   # test
#   sample_table <- get_samples_table(my_cloudos, my_cohort)
#   expect_s3_class(sample_table, "data.frame")
# })

with_mock_api({
  test_that("Get a samples table", {
    
    # set a dummy cloudos credentials
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
                          auth = "Bearer token",
                          team_id = "5f046bf6c132dd15fdd1a525")
    # set a cohort object
    my_cohort <- cohort(my_cloudos, cohort_id = "5f6228133097cc7a6504fb76")
    
    sample_table <- get_samples_table(my_cloudos, my_cohort)
    expect_s3_class(sample_table, "data.frame")
  })
})
