# capture_requests({
#   # set a cohort object
#   my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
# 
#   genotypic_table <- cb_get_genotypic_table(my_cohort)
#   expect_s3_class(genotypic_table, "data.frame")
# })

with_mock_api({
  test_that("Get a genotypic table", {
    # set a cohort object
    my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
    
    genotypic_table <- cb_get_genotypic_table(my_cohort)
    expect_s3_class(genotypic_table, "data.frame")
  })
})
