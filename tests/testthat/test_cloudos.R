test_that("Test cloudos class method", {
  
  # set a dummy cloudos credentials
  my_cloudos <- cloudos(base_url = "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com",
                        auth = "Bearer token",
                        team_id = "5f046bf6c132dd15fdd1a525")
  expect_s4_class(my_cloudos, "cloudos")
})