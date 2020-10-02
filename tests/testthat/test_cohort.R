# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
#                         auth = Sys.getenv("test_cloudos_apikey"),
#                         team_id = "5f046bf6c132dd15fdd1a525")
#   # set a dummy cohort object
#   my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f6228133097cc7a6504fb76")
# 
#   expect_s4_class(my_cohort, "cohort")
# })

with_mock_api({
  test_that("Get a cohort class method", {
    
    # set a dummy cloudos credentials
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
                          auth = "Bearer token",
                          team_id = "5f046bf6c132dd15fdd1a525")
    # set a cohort object
    my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f6228133097cc7a6504fb76")
    
    expect_s4_class(my_cohort, "cohort")
  })
})
