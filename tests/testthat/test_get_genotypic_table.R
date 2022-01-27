# capture_requests({
#   # set a cohort object
#   my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
# 
#   genotypic_table <- cb_get_genotypic_table(my_cohort)
#   expect_s3_class(genotypic_table, "data.frame")
# })

with_mock_api({
  test_that("Get a genotypic table", {
    # set a cohort object
    my_cohort <- cb_load_cohort(cohort_id = "61f18422acdea8299c3f56b5", cb_version = "v1")
    genotypic_table <- cb_get_genotypic_table(my_cohort)
    expect_s3_class(genotypic_table, "data.frame")
  })
})
