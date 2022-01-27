# capture_requests({
#   my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
#   expect_s4_class(my_cohort, "cohort")
# })

with_mock_api({
  test_that("Get a cohort class method", {
    my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
    expect_s4_class(my_cohort, "cohort")
  })
})
