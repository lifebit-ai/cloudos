# capture_requests({
#   # set a dummy cohort object
#   my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
#   # test
#   sample_table <- cb_get_samples_table(my_cohort)
#   expect_s3_class(sample_table, "data.frame")
# })

with_mock_api({
  test_that("Get a samples table", {
    # set a cohort object
    my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd", cb_version = "v1")
    
    sample_table <- cb_get_participants_table(my_cohort)
    expect_s3_class(sample_table, "data.frame")
  })
})
