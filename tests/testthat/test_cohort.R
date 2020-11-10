# capture_requests({
#   # set a dummy cloudos credentials
#   my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
#                         auth = Sys.getenv("test_cloudos_apikey"),
#                         team_id = Sys.getenv("test_cloudos_team_id"))
#   # set a dummy cohort object
#   my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f9af3793dd2dc6091cd17cd")
# 
#   expect_s4_class(my_cohort, "cohort")
# })

with_mock_api({
  test_that("Get a cohort class method", {
    
    my_cloudos <- connect_cloudos(base_url = "http://cohort-browser-dev-110043291.eu-west-1.elb.amazonaws.com/api",
                                  auth = Sys.getenv("test_cloudos_apikey"),
                                  team_id = Sys.getenv("test_cloudos_team_id"))

    my_cohort <- cb_load_cohort(my_cloudos, cohort_id = "5f9af3793dd2dc6091cd17cd")
    
    expect_s4_class(my_cohort, "cohort")
  })
})
