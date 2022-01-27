# capture_requests({
#   # set a dummy cohort object
#   my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
#   # test
#   sample_table <- cb_get_participants_table(my_cohort, page_size = 10, page_number = 0)
#   expect_s3_class(sample_table, "data.frame")
# })

with_mock_api({
  test_that("Get a samples table", {
    # set a cohort object
    my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
    
    sample_table <- cb_get_participants_table(my_cohort, page_size = 10, page_number = 0)
    expect_s3_class(sample_table, "data.frame")
  })
})
