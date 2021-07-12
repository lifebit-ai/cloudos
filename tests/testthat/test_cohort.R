# capture_requests({
#   my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#   expect_s4_class(my_cohort, "cohort")
# })

with_mock_api({
  test_that("Get a cohort class method", {
    my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd", cb_version = "v1")
    expect_s4_class(my_cohort, "cohort")
  })
})
