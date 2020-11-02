# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
#                         auth = Sys.getenv("test_cloudos_apikey"),
#                         team_id = Sys.getenv("test_cloudos_team_id"))
#   # set a dummy cohort object
#   my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f9af3793dd2dc6091cd17cd")
#   # test
#   sample_table <- cb_get_samples_table(my_cloudos, my_cohort)
#   expect_s3_class(sample_table, "data.frame")
# })

with_mock_api({
  test_that("Get a samples table", {
    
    # set a dummy cloudos credentials
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
                          auth = "apikey",
                          team_id = "5f7c8696d6ea46288645a89f")
    # set a cohort object
    my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f9af3793dd2dc6091cd17cd")
    
    sample_table <- cb_get_samples_table(my_cloudos, my_cohort)
    expect_s3_class(sample_table, "data.frame")
  })
})
