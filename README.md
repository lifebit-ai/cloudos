<!-- README.md is generated from README.Rmd. Please edit that file -->

# cloudos <img src="logo/hexlogo.png" align="right" height=140/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/lifebit-ai/cloudos/workflows/R-CMD-check/badge.svg)](https://github.com/lifebit-ai/cloudos/actions)
<!-- badges: end -->

The ‘CloudOS’ client library for R makes it easy to interact with
CloudOS <https://cloudos.lifebit.ai/> in the R environment for analysis.

- [Installation](#installation)
- [Usage](#usage)
    - [Load the cloudos R-client
    library](#load-the-cloudos-r-client-library)
    - [Setup essentials](#setup-essentials)
    - [Create a cloudos object](#create-a-cloudos-object)
    - [List Cohorts](#list-cohorts)
    - [Create a cohort](#create-a-cohort)
    - [Filtering](#filtering)
    - [Get sample (participants) table - Independent from a
      cohort](#get-sample-participants-table---independent-from-a-cohort)
    - [Get genotypic table - Independent from a
      cohort](#get-genotypic-table---independent-from-a-cohort)
    - [Get samples table for selected
      rows](#get-samples-table-for-selected-rows)

## Installation

You can install the released version of cloudos from
[GitHub](https://github.com/lifebit-ai/cloudos/) at this moment. (Will
be listed on [CRAN](https://CRAN.R-project.org) as well)

``` r
if (!require(remotes)) { install.packages("remotes") }
  remotes::install_github("lifebit-ai/cloudos")
```

## Usage

### Load the cloudos R-client library

``` r
library(cloudos)
```

### Setup essentials

``` r
cb_base_url <- "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com"
my_auth <- "*************************"
my_team_id <- "***************************"
```

### Create a cloudos object

This object will be input to most of the other functions, which directly
communicates with the cloudos server.

``` r
my_cloudos <- cloudos::cloudos(base_url = cb_base_url,
                               auth = my_auth,
                               team_id = my_team_id)
my_cloudos
#> Base URL:  http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com 
#> Authentication Method:  Bearer Token 
#> Team ID: 5f046bf6c132dd15fdd1a525
```

### List Cohorts

List available cohorts in a workspace.

``` r
cohorts <- cloudos::list_cohorts(my_cloudos)
#> Total number of cohorts found-42. But here is 10. For more, change 'page_number' and 'page_size'
cohorts
#>                          id         name
#> 1  5f2ab881b695de55d93024a7         test
#> 2  5f327e8c1733200222dc3e8c       test_2
#> 3  5f32c2147ca1902e9c5ba45d       test-R
#> 4  5f32e1687ca1902e9c5ba467  Test cohort
#> 5  5f32f1407ca1902e9c5ba46e     Cohort-R
#> 6  5f351e89cb536f664c1e0a47     test-new
#> 7  5f351ec1305af25011d57b25 test-new-new
#> 8  5f351f15305af25011d57b26 test-new-new
#> 9  5f352103cb536f664c1e0a4a  random test
#> 10 5f3521c5b12d49672a616b88     Cohort-R
#>                                            description number_of_participants
#> 1                                            test-desc                 414326
#> 2                                          some random                 600000
#> 3                                   created from R lib                 600000
#> 4                  This cohort is for testing purpose.                 600000
#> 5  This cohort is for testing purpose, created from R.                 600000
#> 6                                        test-new-desc                 600000
#> 7                                              New-new                 600000
#> 8                                              New-new                 600000
#> 9                                   random descriptiom                 600000
#> 10 This cohort is for testing purpose, created from R.                 333264
#>    number_of_filters               created_at               updated_at
#> 1                  1 2020-08-05T13:47:45.826Z 2020-08-14T10:48:37.284Z
#> 2                  0 2020-08-11T11:18:36.703Z 2020-08-11T11:18:36.703Z
#> 3                  0 2020-08-11T16:06:44.205Z 2020-08-11T16:06:44.205Z
#> 4                  0 2020-08-11T18:20:24.356Z 2020-08-11T18:20:24.356Z
#> 5                  0 2020-08-11T19:28:00.606Z 2020-08-11T19:28:00.606Z
#> 6                  0 2020-08-13T11:05:45.111Z 2020-08-13T11:05:45.111Z
#> 7                  0 2020-08-13T11:06:41.160Z 2020-08-13T11:06:41.160Z
#> 8                  0 2020-08-13T11:08:05.512Z 2020-08-13T11:08:05.512Z
#> 9                  0 2020-08-13T11:16:19.086Z 2020-08-13T11:16:19.086Z
#> 10                 1 2020-08-13T11:19:33.094Z 2020-08-20T07:30:41.584Z
```

### Create a cohort

``` r
my_cohort <- cloudos::create_cohort(my_cloudos,
              cohort_name = "Cohort-R",
              cohort_desc = "This cohort is for testing purpose, created from R.")
#> Cohort named Cohort-R created successfully.
my_cohort
#>                      details                                              
#> phenotypeFilters     ""                                                   
#> _id                  "5f49252baaafb6454ad4a30b"                           
#> name                 "Cohort-R"                                           
#> description          "This cohort is for testing purpose, created from R."
#> team                 "5f046bf6c132dd15fdd1a525"                           
#> owner                "5f046be1c132dd15fdd1a51e"                           
#> numberOfParticipants 644686                                               
#> numberOfFilters      0                                                    
#> createdAt            "2020-08-28T15:39:23.097Z"                           
#> updatedAt            "2020-08-28T15:39:23.097Z"                           
#> __v                  0
```

### Filtering

#### Search avaiable filters

``` r
filt <- cloudos::search_filters(my_cloudos, term = "cancer")
#> Total number of filters - 29
filt
#>                         _id           categoryPathLevel1 categoryPathLevel2
#> 1  5eb55c78599ae918ebb48f69 UK Biobank Assessment Centre        Touchscreen
#> 2  5eb55c78599ae918ebb48f6b UK Biobank Assessment Centre        Touchscreen
#> 3  5eb55c78599ae918ebb48f7d UK Biobank Assessment Centre        Touchscreen
#> 4  5eb55c78599ae918ebb48fa6 UK Biobank Assessment Centre        Touchscreen
#> 5  5eb55c78599ae918ebb48fb3 UK Biobank Assessment Centre        Touchscreen
#> 6  5eb55c78599ae918ebb48fc1 UK Biobank Assessment Centre   Verbal interview
#> 7  5eb55c78599ae918ebb48fc2 UK Biobank Assessment Centre   Verbal interview
#> 8  5eb55c78599ae918ebb48fc3 UK Biobank Assessment Centre   Verbal interview
#> 9  5eb55c78599ae918ebb48fc4 UK Biobank Assessment Centre   Verbal interview
#> 10 5eb55c78599ae918ebb48fc5 UK Biobank Assessment Centre   Verbal interview
#> 11 5eb55c78599ae918ebb48fc6 UK Biobank Assessment Centre   Verbal interview
#> 12 5eb55c78599ae918ebb48fc7 UK Biobank Assessment Centre   Verbal interview
#> 13 5eb55c78599ae918ebb48fc8 UK Biobank Assessment Centre   Verbal interview
#> 14 5eb55c78599ae918ebb48fc9 UK Biobank Assessment Centre   Verbal interview
#> 15 5eb55c78599ae918ebb48fcb UK Biobank Assessment Centre   Verbal interview
#> 16 5eb55c78599ae918ebb48fcc UK Biobank Assessment Centre   Verbal interview
#> 17 5eb55c78599ae918ebb48fcd UK Biobank Assessment Centre   Verbal interview
#> 18 5eb55c87599ae918ebb4a09c             Online follow-up   Work environment
#> 19 5eb55c87599ae918ebb4a0a9             Online follow-up   Work environment
#> 20 5eb55c87599ae918ebb4a0bf             Online follow-up   Work environment
#> 21 5eb55c8a599ae918ebb4a226      Health-related outcomes    Cancer register
#> 22 5eb55c8a599ae918ebb4a227      Health-related outcomes    Cancer register
#> 23 5eb55c8a599ae918ebb4a228      Health-related outcomes    Cancer register
#> 24 5eb55c8a599ae918ebb4a229      Health-related outcomes    Cancer register
#> 25 5eb55c8a599ae918ebb4a22a      Health-related outcomes    Cancer register
#> 26 5eb55c8a599ae918ebb4a22b      Health-related outcomes    Cancer register
#> 27 5eb55c8a599ae918ebb4a22c      Health-related outcomes    Cancer register
#> 28 5eb55c8a599ae918ebb4a306      Health-related outcomes    Cancer register
#> 29 5eb55c8a599ae918ebb4a32b      Health-related outcomes    Cancer register
#>            categoryPathLevel3      categoryPathLevel4    id
#> 1  Health and medical history        Cancer screening  2345
#> 2  Health and medical history        Cancer screening  2355
#> 3  Health and medical history      Medical conditions  2453
#> 4        Sex-specific factors Female-specific factors  2674
#> 5        Sex-specific factors Female-specific factors  2684
#> 6          Medical conditions                    <NA> 20009
#> 7          Medical conditions                    <NA> 20012
#> 8          Medical conditions                    <NA> 20013
#> 9          Medical conditions                    <NA> 20001
#> 10         Medical conditions                    <NA> 20006
#> 11         Medical conditions                    <NA>    84
#> 12         Medical conditions                    <NA> 20007
#> 13         Medical conditions                    <NA> 20008
#> 14         Medical conditions                    <NA>    87
#> 15         Medical conditions                    <NA>   134
#> 16         Medical conditions                    <NA>   135
#> 17         Medical conditions                    <NA> 20002
#> 18        Medical information                    <NA> 22140
#> 19        Medical information                    <NA> 22180
#> 20        Medical information                    <NA> 22160
#> 21                       <NA>                    <NA> 40012
#> 22                       <NA>                    <NA> 40011
#> 23                       <NA>                    <NA> 40021
#> 24                       <NA>                    <NA> 40019
#> 25                       <NA>                    <NA> 40005
#> 26                       <NA>                    <NA> 40008
#> 27                       <NA>                    <NA> 40009
#> 28                       <NA>                    <NA> 40013
#> 29                       <NA>                    <NA> 40006
#>                                                                       name
#> 1                                          Ever had bowel cancer screening
#> 2                                       Most recent bowel cancer screening
#> 3                                               Cancer diagnosed by doctor
#> 4                             Ever had breast cancer screening / mammogram
#> 5                     Years since last breast cancer screening / mammogram
#> 6  Interpolated Age of participant when non-cancer illness first diagnosed
#> 7                     Method of recording time when cancer first diagnosed
#> 8         Method of recording time when non-cancer illness first diagnosed
#> 9                                               Cancer code; self-reported
#> 10                           Interpolated Year when cancer first diagnosed
#> 11                                          Cancer year/age first occurred
#> 12             Interpolated Age of participant when cancer first diagnosed
#> 13               Interpolated Year when non-cancer illness first diagnosed
#> 14                              Non-cancer illness year/age first occurred
#> 15                                         Number of self-reported cancers
#> 16                            Number of self-reported non-cancer illnesses
#> 17                                  Non-cancer illness code; self-reported
#> 18                         Doctor diagnosed lung cancer (not mesothelioma)
#> 19                    Recent medication for lung cancer (not mesothelioma)
#> 20                  Age lung cancer (not mesothelioma) diagnosed by doctor
#> 21                                              Behaviour of cancer tumour
#> 22                                              Histology of cancer tumour
#> 23                                                    Cancer record origin
#> 24                                                    Cancer record format
#> 25                                                Date of cancer diagnosis
#> 26                                                 Age at cancer diagnosis
#> 27                                          Reported occurrences of cancer
#> 28                                                    Type of cancer: ICD9
#> 29                                                   Type of cancer: ICD10
#>           type            valueType units instances array
#> 1         bars   Categorical single               4     1
#> 2    histogram              Integer years         4     1
#> 3         bars   Categorical single               4     1
#> 4         bars   Categorical single               4     1
#> 5    histogram              Integer years         4     1
#> 6    histogram           Continuous years         4    34
#> 7         bars   Categorical single               4     6
#> 8         bars   Categorical single               4    34
#> 9  nested list Categorical multiple               4     6
#> 10   histogram           Continuous years         4     6
#> 11   histogram              Integer               4     6
#> 12   histogram           Continuous years         4     6
#> 13   histogram           Continuous years         4    34
#> 14   histogram              Integer               4    34
#> 15   histogram              Integer               4     1
#> 16   histogram              Integer               4     1
#> 17 nested list Categorical multiple               4    34
#> 18        bars   Categorical single               1     1
#> 19        bars   Categorical single               1     1
#> 20   histogram              Integer               1     1
#> 21 nested list   Categorical single              17     1
#> 22 nested list   Categorical single              17     1
#> 23        bars   Categorical single              17     1
#> 24        bars   Categorical single              17     1
#> 25   histogram                 Date              17     1
#> 26   histogram           Continuous              17     1
#> 27   histogram              Integer               1     1
#> 28 nested list   Categorical single              15     1
#> 29 nested list   Categorical single              17     1
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           description
#> 1  "ACE touchscreen question ""Have you ever had a screening test for bowel (colorectal) cancer? (Please include tests for blood in the stool/faeces or a colonoscopy or a sigmoidoscopy)"" If the participant activated the Help button they were shown the message:     Screening tests for bowel or colorectal cancer include:  - FOBT (faecal occult blood test) - this is when you    are given a set of cards and asked to smear a part    of your stool on three separate occasions onto the    cards and then return the cards to be tested for    blood.  - Sigmoidoscopy - a tube is used to examine the lower    bowel. This is usually done in a doctor's office    without pain relief.  - Colonoscopy - a long tube is used the examine the    whole large bowel; you would usually have to drink    a large amount of special liquid to prepare the    bowel; and you would be given a sedative medication    for the procedure.     "
#> 2                                                                                                                                                                                                                                                                                                                                                                           "ACE touchscreen question ""How many years ago was the most recent one of these tests?"" The following checks were performed:  If answer   If answer > Participants age - 5 years then rejected  If answer > 20 then participant asked to confirm   If the participant activated the Help button they were shown the message:     If you are unsure; please provide an estimate or select Do not know.      ~F2355~ was collected from participants who indicated they have had a screening test for bowel (colorectal) cancer; as indicated by their answers to ~F2345~"
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "ACE touchscreen question ""Has a doctor ever told you that you have had cancer?"" If the participant activated the Help button they were shown the message:     If you are unsure if you have been told you had cancer; select Do not know and you will be asked about this by an interviewer later during this visit.     "
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        "ACE touchscreen question ""Have you ever been for breast cancer screening (a mammogram)?"""
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                               "ACE touchscreen question ""How many years ago was your last screen?"" The following checks were performed:  If answer   If answer > Participants age - 15 years then rejected  If answer > 15 then participant asked to confirm   If the participant activated the Help button they were shown the message:     If you are unsure; please provide an estimate or select Do not know.      ~F2684~ was collected from women who indicated that they had been for a mammogram; as defined by their answers to ~F2674~"
#> 6                                                                                                      This is the interpolated time when the participant indicated the corresponding condition was first diagnosed by a doctor; given as their estimated age.    If the participant gave a calendar year; then the best-fit time is their age at the mid-point of that year. For example if the year was given as 1970; and the participant was born on 1 April 1950; then their age on 1st July 1970 is 20.25  then the value presented is 1970.5   If the participant gave their age then the value presented is the fractional year corresponding to the mid-point of that age. For example; if the participant said they were 30 years old then the value is 30.5  Interpolated values before the date of birth were truncated forwards to that time.   Interpolated values after the time of data acquisition were truncated back to that time.
#> 7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                Participants were able to record the time the cancer was diagnosed by entering either their age or the year. Some participants recorded an event but were unable to recall the time.
#> 8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Participants were able to record the time the non-cancer illness was diagnosed by entering either their age or the year. Some participants recorded an event but were unable to recall the time.
#> 9                                                                                                                                                                                                                                                                                                                                                                        "Code for cancer. If the participant was uncertain of the type of cancer they had had; then they described it to the interviewer (a trained nurse) who attempted to place it within the coding tree. If the cancer could not be located in the coding tree then the interviewer entered a free-text description of it. These free-text descriptions were subsequently examined by a doctor and; where possible; matched to entries in the coding tree. Free-text descriptions which could not be matched with very high probability have been marked as ""unclassifiable""."
#> 10                                                                                                                                                                                This is the interpolated time when the participant indicated the corresponding cancer was first diagnosed by a doctor; measured in years.    If the participant gave a calendar year; then the best-fit time is half-way through that year. For example if the year was given as 1970; then the value presented is 1970.5   If the participant gave their age then the value presented is the fractional year corresponding to the mid-point of that age. For example; if the participant said they were 30 years old then the value is the date at which they were 30years+6months.  Interpolated values before the date of birth were truncated forwards to that time.   Interpolated values after the time of data acquisition were truncated back to that time.
#> 11                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   For each cancer entered; the nurse entered the date or age at diagnosis using a pop-up screen; depending on the participant's response. See Related Data-fields tab for further information on where to find separate data-fields for age and year of diagnosis.
#> 12                                                                                                        This is the interpolated time when the participant indicated the corresponding cancer was first diagnosed by a doctor; given as their estimated age.    If the participant gave a calendar year; then the best-fit time is their age at the mid-point of that year. For example if the year was given as 1970; and the participant was born on 1 April 1950; then their age on 1st July 1970 is 20.25  then the value presented is 1970.5   If the participant gave their age then the value presented is the fractional year corresponding to the mid-point of that age. For example; if the participant said they were 30 years old then the value is 30.5  Interpolated values before the date of birth were truncated forwards to that time.   Interpolated values after the time of data acquisition were truncated back to that time.
#> 13                                                                                                                                                                             This is the interpolated time when the participant indicated the corresponding condition was first diagnosed by a doctor; measured in years.    If the participant gave a calendar year; then the best-fit time is half-way through that year. For example if the year was given as 1970; then the value presented is 1970.5   If the participant gave their age then the value presented is the fractional year corresponding to the mid-point of that age. For example; if the participant said they were 30 years old then the value is the date at which they were 30years+6months.  Interpolated values before the date of birth were truncated forwards to that time.   Interpolated values after the time of data acquisition were truncated back to that time.
#> 14                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  For each disease entered; the nurse entered the date or age at diagnosis using a pop-up screen; depending on the participant's response. See Related Data-fields tab for further information on where to find separate data-fields for age and year of diagnosis.
#> 15                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Number of cancers entered
#> 16                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Number of non-cancer illnesses entered
#> 17                                                                                                                                                                                                            "Code for non-cancer illness. If the participant was uncertain of the type of illness they had had; then they described it to the interviewer (a trained nurse) who attempted to place it within the coding tree. If the illness could not be located in the coding tree then the interviewer entered a free-text description of it. These free-text descriptions were subsequently examined by a doctor and; where possible; matched to entries in the coding tree. Free-text descriptions which could not be matched with very high probability have been marked as ""unclassifiable"".   Note that myasthenia gravis appears twice (under codes 1260 and 1437). Please ensure you use both codes to capture all relevant diagnoses."
#> 18                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "User asked ""Has a doctor ever told you that you have had any of the conditions below?"" ""lung cancer (not mesothelioma)"" was one of the options listed."
#> 19                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         User asked whether they are currently on medication for the lung cancer (not mesothelioma) which was diagnosed by a doctor
#> 20                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    User was asked the age at which doctor diagnosed lung cancer (not mesothelioma)
#> 21                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    This is a numeric code relating to the behaviour of the tumour; provided by the cancer registry
#> 22                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    This is a numeric code relating to the histology of the tumour; provided by the cancer registry
#> 23                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Indicates the origin of the data in which the original cancer record was supplied to UK Biobank.
#> 24                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   Indicates the format of the data in which the original cancer record was supplied to UK Biobank.
#> 25                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Date of cancer diagnosis; acquired from central registry.  Note that data from the most recent 12-18 months is still accruing (i.e. it is not complete).   The events/dates are indexed in the order in which they are received and processed by UK Biobank rather than in their own chronological order.
#> 26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Age calculated as interval between Dates of Birth and Cancer diagnosis.
#> 27                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 This is the number of reports of cancer received from UK National registries. Participants who have never been reported as having cancer do not contribute to this field unless a report was received then subsequently withdrawn.
#> 28                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              The ICD9 code for the type of cancer. Acquired from central registry.
#> 29                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         The ICD-10 code for the type of cancer. Acquired from central registry. The ICD-10 tree displayed on this page includes all cancer records for each UK Biobank participant (for which there may be multiple ICD codes). For more information on the first diagnosed cancer in each participant; please refer to ~L100092~.
#>    descriptionParticipantsNo descriptionItemNo descriptionStability coding
#> 1                     501599            572225             Complete 100349
#> 2                     180035            202611             Complete 100567
#> 3                     501592            572218             Complete 100603
#> 4                     272921            309271             Complete 100349
#> 5                     223188            252179             Complete 100567
#> 6                     385696           1121517             Complete     13
#> 7                      45525             53149             Complete     14
#> 8                     385697           1121528             Complete     14
#> 9                      45525             53149             Complete      3
#> 10                     45525             53149             Complete     13
#> 11                     45525             53149             Complete     37
#> 12                     45525             53149             Complete     13
#> 13                    385696           1121517             Complete     13
#> 14                    385697           1121528             Complete     37
#> 15                    501656            566685             Complete       
#> 16                    501656            566685             Complete       
#> 17                    385697           1121528             Complete      6
#> 18                    121277            121277             Accruing      7
#> 19                       156               156             Accruing      7
#> 20                       156               156             Accruing       
#> 21                     89269            114009             Accruing     39
#> 22                     89177            113834             Accruing     38
#> 23                     89808            118822           Updateable   1970
#> 24                     89808            118822              Ongoing    262
#> 25                     89766            118715             Accruing       
#> 26                     89766            118715             Accruing       
#> 27                     89766             89766              Ongoing       
#> 28                     11222             15241             Accruing     87
#> 29                     84723            103466             Accruing     19
#>    descriptionCategoryID descriptionItemType descriptionStrata descriptionSexed
#> 1                 100040                Data           Primary           Unisex
#> 2                 100040                Data           Primary           Unisex
#> 3                 100044                Data           Primary           Unisex
#> 4                 100069                Data           Primary           Female
#> 5                 100069                Data           Primary           Female
#> 6                 100074                Data           Primary           Unisex
#> 7                 100074                Data           Primary           Unisex
#> 8                 100074                Data           Primary           Unisex
#> 9                 100074                Data           Derived           Unisex
#> 10                100074                Data           Primary           Unisex
#> 11                100074                Data           Primary           Unisex
#> 12                100074                Data           Primary           Unisex
#> 13                100074                Data           Primary           Unisex
#> 14                100074                Data           Primary           Unisex
#> 15                100074                Data           Primary           Unisex
#> 16                100074                Data           Primary           Unisex
#> 17                100074                Data           Derived           Unisex
#> 18                   132                Data           Primary           Unisex
#> 19                   132                Data           Primary           Unisex
#> 20                   132                Data           Primary           Unisex
#> 21                100092                Data           Primary           Unisex
#> 22                100092                Data           Primary           Unisex
#> 23                100092                Data           Primary           Unisex
#> 24                100092                Data         Auxiliary           Unisex
#> 25                100092                Data           Primary           Unisex
#> 26                100092                Data           Derived           Unisex
#> 27                100092                Data           Derived           Unisex
#> 28                100092                Data           Primary           Unisex
#> 29                100092                Data           Primary           Unisex
#>                                                        link
#> 1   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2345
#> 2   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2355
#> 3   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2453
#> 4   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2674
#> 5   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2684
#> 6  http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20009
#> 7  http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20012
#> 8  http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20013
#> 9  http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20001
#> 10 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20006
#> 11    http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=84
#> 12 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20007
#> 13 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20008
#> 14    http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=87
#> 15   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=134
#> 16   http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=135
#> 17 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=20002
#> 18 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22140
#> 19 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22180
#> 20 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=22160
#> 21 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40012
#> 22 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40011
#> 23 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40021
#> 24 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40019
#> 25 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40005
#> 26 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40008
#> 27 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40009
#> 28 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40013
#> 29 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=40006
#>                                                                                  instance0Name
#> 1  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 2  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 3  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 4  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 5  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 6  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 7  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 8  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 9  Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 10 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 11 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 12 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 13 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 14 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 15 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 16 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 17 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 18                                                                                            
#> 19                                                                                            
#> 20                                                                                            
#> 21                                                                                           0
#> 22                                                                                           0
#> 23                                                                                           0
#> 24                                                                                           0
#> 25                                                                                           0
#> 26                                                                                           0
#> 27                                                                                           0
#> 28                                                                                           0
#> 29                                                                                           0
#>                              instance1Name         instance2Name
#> 1  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 2  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 3  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 4  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 5  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 6  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 7  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 8  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 9  First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 10 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 11 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 12 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 13 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 14 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 15 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 16 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 17 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 18                                                              
#> 19                                                              
#> 20                                                              
#> 21                                       1                     2
#> 22                                       1                     2
#> 23                                       1                     2
#> 24                                       1                     2
#> 25                                       1                     2
#> 26                                       1                     2
#> 27                                                              
#> 28                                       1                     2
#> 29                                       1                     2
#>                         instance3Name instance4Name instance5Name instance6Name
#> 1  First repeat imaging visit (2019+)                                          
#> 2  First repeat imaging visit (2019+)                                          
#> 3  First repeat imaging visit (2019+)                                          
#> 4  First repeat imaging visit (2019+)                                          
#> 5  First repeat imaging visit (2019+)                                          
#> 6  First repeat imaging visit (2019+)                                          
#> 7  First repeat imaging visit (2019+)                                          
#> 8  First repeat imaging visit (2019+)                                          
#> 9  First repeat imaging visit (2019+)                                          
#> 10 First repeat imaging visit (2019+)                                          
#> 11 First repeat imaging visit (2019+)                                          
#> 12 First repeat imaging visit (2019+)                                          
#> 13 First repeat imaging visit (2019+)                                          
#> 14 First repeat imaging visit (2019+)                                          
#> 15 First repeat imaging visit (2019+)                                          
#> 16 First repeat imaging visit (2019+)                                          
#> 17 First repeat imaging visit (2019+)                                          
#> 18                                                                             
#> 19                                                                             
#> 20                                                                             
#> 21                                  3             4             5             6
#> 22                                  3             4             5             6
#> 23                                  3             4             5             6
#> 24                                  3             4             5             6
#> 25                                  3             4             5             6
#> 26                                  3             4             5             6
#> 27                                                                             
#> 28                                  3             4             5             6
#> 29                                  3             4             5             6
#>    instance7Name instance8Name instance9Name instance10Name instance11Name
#> 1                                                                         
#> 2                                                                         
#> 3                                                                         
#> 4                                                                         
#> 5                                                                         
#> 6                                                                         
#> 7                                                                         
#> 8                                                                         
#> 9                                                                         
#> 10                                                                        
#> 11                                                                        
#> 12                                                                        
#> 13                                                                        
#> 14                                                                        
#> 15                                                                        
#> 16                                                                        
#> 17                                                                        
#> 18                                                                        
#> 19                                                                        
#> 20                                                                        
#> 21             7             8             9             10             11
#> 22             7             8             9             10             11
#> 23             7             8             9             10             11
#> 24             7             8             9             10             11
#> 25             7             8             9             10             11
#> 26             7             8             9             10             11
#> 27                                                                        
#> 28             7             8                           10             11
#> 29             7             8             9             10             11
#>    instance12Name instance13Name instance14Name instance15Name instance16Name
#> 1                                                                            
#> 2                                                                            
#> 3                                                                            
#> 4                                                                            
#> 5                                                                            
#> 6                                                                            
#> 7                                                                            
#> 8                                                                            
#> 9                                                                            
#> 10                                                                           
#> 11                                                                           
#> 12                                                                           
#> 13                                                                           
#> 14                                                                           
#> 15                                                                           
#> 16                                                                           
#> 17                                                                           
#> 18                                                                           
#> 19                                                                           
#> 20                                                                           
#> 21             12             13                            15             16
#> 22             12             13             14             15             16
#> 23             12             13             14             15             16
#> 24             12             13             14             15             16
#> 25             12             13             14             15             16
#> 26             12             13             14             15             16
#> 27                                                                           
#> 28             12                            14                              
#> 29                            13                            15             16
#>    bucket300 bucket500 bucket1000 bucket2500 bucket5000 bucket10000
#> 1      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 2      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 3      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 4      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 5      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 6       TRUE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 7      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 8      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 9      FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 10      TRUE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 11     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 12      TRUE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 13      TRUE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 14     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 15     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 16     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 17     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 18     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 19     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 20     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 21     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 22     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 23     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 24     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 25      TRUE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 26     FALSE      TRUE       TRUE       TRUE       TRUE        TRUE
#> 27     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 28     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 29     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#>    orderPhenotype checked
#> 1              40       1
#> 2              40       1
#> 3              42       1
#> 4              47       1
#> 5              47       1
#> 6              51       1
#> 7              51       1
#> 8              51       1
#> 9              51       1
#> 10             51       1
#> 11             51       1
#> 12             51       1
#> 13             51       1
#> 14             51       1
#> 15             51       1
#> 16             51       1
#> 17             51       1
#> 18            196       0
#> 19            196       0
#> 20            196       0
#> 21            224       0
#> 22            224       0
#> 23            224       0
#> 24            224       0
#> 25            224       0
#> 26            224       0
#> 27            224       0
#> 28            224       0
#> 29            224       0
```

#### Phenotype filtering

``` r
# phenotype filter
cohort_with_filters <- cloudos::filter_samples(my_cloudos, 
                                   cohort_id = my_cohort["_id",], 
                                   filter_id = filt$id[1])
cohort_with_filters
#>      _id number total  label                 
#> [1,] -3  32545  600000 "Prefer not to answer"
#> [2,] -1  181143 600000 "Do not know"         
#> [3,] 0   300719 600000 "No"                  
#> [4,] 1   85593  600000 "Yes"
```

``` r
# filter participants
participants_with_fiter <- cloudos:::filter_participants(my_cloudos,
                                                cohort_id = my_cohort["_id",], 
                                                filter_id = filt$id[1] )
 
participants_with_fiter
#> $total
#> [1] 644686
#> 
#> $count
#> [1] 333264
```

``` r
# apply filter (genotypic_save) 
gs <- cloudos::genotypic_save(my_cloudos,
                     cohort_id = my_cohort["_id",],
                     filter_id = filt$id[1] )

gs
#>      cohortId                   markers filters _id                       
#> data "5f49252baaafb6454ad4a30b" List,0  List,1  "5f49252faaafb6454ad4a30c"
#>      numberOfParticipants
#> data 32545
```

``` r
df <- cloudos::filter_metadata(my_cloudos,
                     filter_id = filt$id[1])
df
#>                        _id           categoryPathLevel1 categoryPathLevel2
#> 1 5eb55c78599ae918ebb48f69 UK Biobank Assessment Centre        Touchscreen
#>           categoryPathLevel3 categoryPathLevel4   id
#> 1 Health and medical history   Cancer screening 2345
#>                              name type          valueType units instances array
#> 1 Ever had bowel cancer screening bars Categorical single               4     1
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          description
#> 1 "ACE touchscreen question ""Have you ever had a screening test for bowel (colorectal) cancer? (Please include tests for blood in the stool/faeces or a colonoscopy or a sigmoidoscopy)"" If the participant activated the Help button they were shown the message:     Screening tests for bowel or colorectal cancer include:  - FOBT (faecal occult blood test) - this is when you    are given a set of cards and asked to smear a part    of your stool on three separate occasions onto the    cards and then return the cards to be tested for    blood.  - Sigmoidoscopy - a tube is used to examine the lower    bowel. This is usually done in a doctor's office    without pain relief.  - Colonoscopy - a long tube is used the examine the    whole large bowel; you would usually have to drink    a large amount of special liquid to prepare the    bowel; and you would be given a sedative medication    for the procedure.     "
#>   descriptionParticipantsNo descriptionItemNo descriptionStability coding
#> 1                    501599            572225             Complete 100349
#>   descriptionCategoryID descriptionItemType descriptionStrata descriptionSexed
#> 1                100040                Data           Primary           Unisex
#>                                                      link
#> 1 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2345
#>                                                                                 instance0Name
#> 1 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#>                             instance1Name         instance2Name
#> 1 First repeat assessment visit (2012-13) Imaging visit (2014+)
#>                        instance3Name instance4Name instance5Name instance6Name
#> 1 First repeat imaging visit (2019+)                                          
#>   instance7Name instance8Name instance9Name instance10Name instance11Name
#> 1                                                                        
#>   instance12Name instance13Name instance14Name instance15Name instance16Name
#> 1                                                                           
#>   bucket300 bucket500 bucket1000 bucket2500 bucket5000 bucket10000
#> 1     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#>   orderPhenotype checked
#> 1             40       1
```

### Get sample (participants) table - Independent from a cohort

Get all the sample (participants) table from cohort browser. Optionally
you can also add filters.

TODO: For now two filters are hard-coded for testing.

``` r
df <- cloudos::get_samples_table(my_cloudos)
df
#>                         _id       i      f5984i0aavg
#> 1  5f185b92bf92ed4d3be9637d 1000002                0
#> 2  5edbdd689d700db709af0c2f 1000016 65.7105263157895
#> 3  5f32c12e2edb69826cc17cc6 1000016                0
#> 4  5f185b91bf92ed4d3be9587e 1000020                0
#> 5  5f185b91bf92ed4d3be95984 1000035                0
#> 6  5edbdd689d700db709af0c3e 1000048 59.2368421052632
#> 7  5edbdd689d700db709af0c2b 1000057  73.140350877193
#> 8  5f32c12e2edb69826cc17ccd 1000057                0
#> 9  5edbdd689d700db709af0c2d 1000059 71.1491228070175
#> 10 5f32c12e2edb69826cc17cc9 1000059                0
#>                             f20001i0a0 f31i0a0 f34i0a0   f52i0a0 f5984i0amin
#> 1                                 <NA>    <NA>    <NA>      <NA>        <NA>
#> 2                      cervical cancer    Male    1954 September           0
#> 3                                 <NA>    <NA>    <NA>      <NA>        <NA>
#> 4                                 <NA>    <NA>    <NA>      <NA>        <NA>
#> 5                                 <NA>    <NA>    <NA>      <NA>        <NA>
#> 6                      chronic myeloid  Female    1950   January           0
#> 7  metastatic cancer (unknown primary)  Female    1942  February           0
#> 8                                 <NA>    <NA>    <NA>      <NA>        <NA>
#> 9           uterine/endometrial cancer  Female    1964  December           1
#> 10                                <NA>    <NA>    <NA>      <NA>        <NA>
#>    f5984i0amax
#> 1         <NA>
#> 2          270
#> 3         <NA>
#> 4         <NA>
#> 5         <NA>
#> 6          195
#> 7          270
#> 8         <NA>
#> 9          270
#> 10        <NA>
```

### Get genotypic table - Independent from a cohort

Get all the genotypic table from cohort browser. Optionally you can also
add filters.

``` r
# df <- cloudos::get_genotypic_table(my_cloudos, filt_chr = c(5,9), filt_type = c("SNP", "Insertion"))
df <- cloudos::get_genotypic_table(my_cloudos)
df
#>       _id                        Chromosome Location    Reference Alternative
#>  [1,] "5ef793999b8097fcd1da226a" "10"       "10:93190"  "AC"      " "        
#>  [2,] "5ef793719b8097fcd1cea2f3" "10"       "10:93502"  "C"       "G"        
#>  [3,] "5ef793719b8097fcd1cea2ff" "10"       "10:93635"  "T"       "C"        
#>  [4,] "5ef793999b8097fcd1da2266" "10"       "10:94514"  "CTGG"    " "        
#>  [5,] "5ef793999b8097fcd1da2277" "10"       "10:94693"  "G"       " "        
#>  [6,] "5ef793719b8097fcd1cea2f6" "10"       "10:95844"  "C"       "T"        
#>  [7,] "5ef793719b8097fcd1cea2f2" "10"       "10:110655" "C"       "T"        
#>  [8,] "5ef793719b8097fcd1cea2f5" "10"       "10:111955" "A"       "G"        
#>  [9,] "5ef793719b8097fcd1cea2f0" "10"       "10:119812" "C"       "T"        
#> [10,] "5ef793719b8097fcd1cea2ef" "10"       "10:122109" "C"       "T"        
#>       Affimetrix ID Possible allele combination 0 Possible allele combination 1
#>  [1,] "80278591"    "GAC G"                       "0 0"                        
#>  [2,] "52134431"    "C C"                         "0 0"                        
#>  [3,] "3729558"     "T T"                         "0 0"                        
#>  [4,] "52349171"    "CCTGG CCT"                   "C CCTGG"                    
#>  [5,] "80278592"    "AG"                          "0 0"                        
#>  [6,] "35481805"    "C C"                         "T C"                        
#>  [7,] "2365062"     "T C"                         "0 0"                        
#>  [8,] "2380802"     "A A"                         "G A"                        
#>  [9,] "2473215"     "T T"                         "C C"                        
#> [10,] "2502714"     "C C"                         "T T"                        
#>       Possible allele combination 2 index Type        id   cn          
#>  [1,] "G GAC"                       "0"   "Insertion" "1"  "zzg_m_10_0"
#>  [2,] "G C"                         "1"   "SNP"       "2"  "zzg_m_10_1"
#>  [3,] "C T"                         "2"   "SNP"       "3"  "zzg_m_10_2"
#>  [4,] "0 0"                         "3"   "Insertion" "4"  "zzg_m_10_3"
#>  [5,] "A A"                         "4"   "SNP"       "5"  "zzg_m_10_4"
#>  [6,] "0 0"                         "5"   "SNP"       "6"  "zzg_m_10_5"
#>  [7,] "C C"                         "6"   "SNP"       "7"  "zzg_m_10_6"
#>  [8,] "G G"                         "7"   "SNP"       "8"  "zzg_m_10_7"
#>  [9,] "T C"                         "8"   "SNP"       "9"  "zzg_m_10_8"
#> [10,] "T C"                         "9"   "SNP"       "10" "zzg_m_10_9"
#>       <NA>          <NA>          <NA>                <NA>               
#>  [1,] NA            NA            NA                  NA                 
#>  [2,] "rs201177578" "Deleterious" "Possibly Damaging" "Possibly Damaging"
#>  [3,] "rs200242637" "Deleterious" "Benign"            "Benign"           
#>  [4,] NA            NA            NA                  NA                 
#>  [5,] NA            NA            NA                  NA                 
#>  [6,] "rs117205301" NA            NA                  NA                 
#>  [7,] "rs78253668"  NA            NA                  NA                 
#>  [8,] "rs7909677"   NA            NA                  NA                 
#>  [9,] "rs11253280"  NA            NA                  NA                 
#> [10,] "rs7093061"   NA            NA                  NA                 
#>       <NA>      <NA>              <NA>     <NA>          <NA>         
#>  [1,] NA        NA                NA       NA            NA           
#>  [2,] "Unknown" "Disease Causing" "Medium" "Deleterious" "Deleterious"
#>  [3,] "Unknown" "Disease Causing" "Medium" "Tolerated"   "Deleterious"
#>  [4,] NA        NA                NA       NA            NA           
#>  [5,] NA        NA                NA       NA            NA           
#>  [6,] NA        NA                NA       NA            NA           
#>  [7,] NA        NA                NA       NA            NA           
#>  [8,] NA        NA                NA       NA            NA           
#>  [9,] NA        NA                NA       NA            NA           
#> [10,] NA        NA                NA       NA            NA           
#>       <NA>        <NA>          <NA>  <NA> 
#>  [1,] NA          NA            NA    NA   
#>  [2,] "Tolerated" "Deleterious" "542" "244"
#>  [3,] "Tolerated" "Tolerated"   "615" "27" 
#>  [4,] NA          NA            NA    NA   
#>  [5,] NA          NA            NA    NA   
#>  [6,] NA          NA            NA    NA   
#>  [7,] NA          NA            NA    NA   
#>  [8,] NA          NA            NA    NA   
#>  [9,] NA          NA            NA    NA   
#> [10,] NA          NA            NA    NA   
#>       <NA>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
#>  [1,] NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
#>  [2,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
#>  [3,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
#>  [4,] NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
#>  [5,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
#>  [6,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
#>  [7,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING"
#>  [8,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING"
#>  [9,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING"
#> [10,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING"
#>       <NA>             <NA>                                  <NA>    <NA>   
#>  [1,] NA               NA                                    NA      NA     
#>  [2,] "TUBB8"          "TUBB8:NM 177987:exon4:cG830C:pG277A" "0.002" "0.787"
#>  [3,] "TUBB8"          "TUBB8:NM 177987:exon4:cA697G:pM233V" "0.012" "0.01" 
#>  [4,] NA               NA                                    NA      NA     
#>  [5,] "TUBB8"          NA                                    NA      NA     
#>  [6,] "TUBB8"          NA                                    NA      NA     
#>  [7,] "TUBB8; ZMYND11" NA                                    NA      NA     
#>  [8,] "TUBB8; ZMYND11" NA                                    NA      NA     
#>  [9,] "TUBB8; ZMYND11" NA                                    NA      NA     
#> [10,] "TUBB8; ZMYND11" NA                                    NA      NA     
#>       <NA>    <NA>    <NA> <NA>    <NA>    <NA>    <NA>    <NA>    <NA>    
#>  [1,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [2,] "0.598" "0.001" "1"  "2.155" "-1.84" "-4.65" "0.41"  "0.877" "-0.012"
#>  [3,] "0.043" "0"     "1"  "2.105" "-0.18" "-3.33" "0.098" "0.713" "-0.829"
#>  [4,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [5,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [6,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [7,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [8,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>  [9,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#> [10,] NA      NA      NA   NA      NA      NA      NA      NA      NA      
#>       <NA>    <NA>     <NA>     <NA>     <NA>     <NA>     <NA>     <NA>    
#>  [1,] NA      NA       NA       NA       NA       NA       NA       NA      
#>  [2,] "0.561" NA       NA       NA       NA       NA       NA       NA      
#>  [3,] "0.183" "0.0279" "0.0174" "0.0196" "0.04"   "0.0194" "0.0573" "0.028" 
#>  [4,] NA      NA       NA       NA       NA       NA       NA       NA      
#>  [5,] NA      NA       NA       NA       NA       NA       NA       NA      
#>  [6,] NA      "0.0242" "0.0085" "0.0155" "0.0199" "0.0025" "0.0218" "0.0367"
#>  [7,] NA      "0.2678" "0.1517" "0.195"  "0.2881" "0.254"  "0.3489" "0.3203"
#>  [8,] NA      "0.0634" "0.0352" "0.0465" "0.0265" "0.066"  "0.0785" "0.0786"
#>  [9,] NA      "0.4425" "0.4947" "0.3077" "0.3699" "0.3674" "0.4488" "0.4306"
#> [10,] NA      "0.2538" "0.1036" "0.2734" "0.3514" "0.0961" "0.282"  "0.3489"
#>       <NA>     <NA>  <NA>       
#>  [1,] NA       NA    NA         
#>  [2,] NA       NA    NA         
#>  [3,] "0.0461" NA    NA         
#>  [4,] NA       NA    NA         
#>  [5,] NA       NA    NA         
#>  [6,] "0.0275" "T T" "0.0364263"
#>  [7,] "0.2916" "T T" "0.315864" 
#>  [8,] "0.0519" "0 0" "0.0843255"
#>  [9,] "0.4063" "0 0" "0.444643" 
#> [10,] "0.3077" "0 0" "0.35744"
```

### Get samples table for selected rows

Create a RAW data string. This usually generates after selecting
participants on UI. (more information will be added how to create this
in R)

NOTE: This function will be improved `raw_data` arg is temporary.

``` r
new_raw_data <- '{"columns":[{"id":34,"instance":0,"array":{"type":"exact","value":0}},{"id":31,"instance":0,"array":{"type":"exact","value":0}},{"id":52,"instance":0,"array":{"type":"exact","value":0}},{"id":5984,"instance":0,"array":{"type":"avg"}},{"id":5984,"instance":0,"array":{"type":"min"}},{"id":5984,"instance":0,"array":{"type":"max"}},{"id":20001,"instance":0,"array":{"type":"exact","value":0}}],"ids":["5f185b92bf92ed4d3be9637d","5edbdd689d700db709af0c2f","5f185b91bf92ed4d3be9587e","5f185b91bf92ed4d3be95984","5edbdd689d700db709af0c3e","5edbdd689d700db709af0c2b","5edbdd689d700db709af0c2d","5f185b93bf92ed4d3be982e9","5edbdd689d700db709af0c2a","5edbdd689d700db709af0c4d"],"type":"csv","base_url":"http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com"}'
```

Using this above raw data lets extract selected participants.

``` r
df <- cloudos::extract_samples(my_cloudos,
                      raw_data = new_raw_data)
df
#>          i ECG..load.0.0 ECG..load.0.1 ECG..load.0.2 ECG..load.0.3
#> 1  1000002            NA            NA            NA            NA
#> 2  1000016            20            75            55            57
#> 3  1000020            NA            NA            NA            NA
#> 4  1000035            NA            NA            NA            NA
#> 5  1000048           109            51            87            75
#> 6  1000057           110           112            97            67
#> 7  1000059            85            99            52            86
#> 8  1000061            NA            NA            NA            NA
#> 9  1000063            15            58           130           100
#> 10 1000068            14           128           128            13
#>    ECG..load.0.4 ECG..load.0.5 ECG..load.0.6 ECG..load.0.7 ECG..load.0.8
#> 1             NA            NA            NA            NA            NA
#> 2            245            22            40            24            83
#> 3             NA            NA            NA            NA            NA
#> 4             NA            NA            NA            NA            NA
#> 5             16            67            12            50            51
#> 6             14            54            76            57           128
#> 7             29           108            49           112            99
#> 8             NA            NA            NA            NA            NA
#> 9             94           124            74            59           127
#> 10            94            15             0           106            91
#>    ECG..load.0.9 ECG..load.0.10 ECG..load.0.11 ECG..load.0.12 ECG..load.0.13
#> 1             NA             NA             NA             NA             NA
#> 2             93            130             41             19             64
#> 3             NA             NA             NA             NA             NA
#> 4             NA             NA             NA             NA             NA
#> 5             91             77             75             47             63
#> 6             88              6             59            195             11
#> 7             53            245             90             44            132
#> 8             NA             NA             NA             NA             NA
#> 9             62            102             75             63              0
#> 10            66             66             66             88            195
#>    ECG..load.0.14 ECG..load.0.15 ECG..load.0.16 ECG..load.0.17 ECG..load.0.18
#> 1              NA             NA             NA             NA             NA
#> 2              85             87              3             47             88
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5             108            116             80             45             93
#> 6              40             57             46              3             13
#> 7              97            270             95             57            140
#> 8              NA             NA             NA             NA             NA
#> 9             106             46             91             51             29
#> 10            136            121             52             48             19
#>    ECG..load.0.19 ECG..load.0.20 ECG..load.0.21 ECG..load.0.22 ECG..load.0.23
#> 1              NA             NA             NA             NA             NA
#> 2             130             28             96             24             17
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              75              9             72             73             35
#> 6               9            120             36             21              5
#> 7              22             30             68            118             38
#> 8              NA             NA             NA             NA             NA
#> 9               5             11             75            112             91
#> 10             50             29             39             29            115
#>    ECG..load.0.24 ECG..load.0.25 ECG..load.0.26 ECG..load.0.27 ECG..load.0.28
#> 1              NA             NA             NA             NA             NA
#> 2              38             63              2            108             57
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              31             32             76            128             31
#> 6              20              9            270            132             74
#> 7              53             58             80            118            195
#> 8              NA             NA             NA             NA             NA
#> 9             106            108             92             74            121
#> 10            120            121              5            120            124
#>    ECG..load.0.29 ECG..load.0.30 ECG..load.0.31 ECG..load.0.32 ECG..load.0.33
#> 1              NA             NA             NA             NA             NA
#> 2             140             85              8             77            112
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              15            100             53              2            116
#> 6              90            105             97             98              0
#> 7              18            136             94             92             65
#> 8              NA             NA             NA             NA             NA
#> 9              63              9             26             63             43
#> 10             95              0             88             76             60
#>    ECG..load.0.34 ECG..load.0.35 ECG..load.0.36 ECG..load.0.37 ECG..load.0.38
#> 1              NA             NA             NA             NA             NA
#> 2              58             12             24             20             97
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              25            109            195            130             21
#> 6             115             16             65             54             86
#> 7             121             54             77            100            124
#> 8              NA             NA             NA             NA             NA
#> 9             105             27            112             30             75
#> 10             86             84             33             13             92
#>    ECG..load.0.39 ECG..load.0.40 ECG..load.0.41 ECG..load.0.42 ECG..load.0.43
#> 1              NA             NA             NA             NA             NA
#> 2              30            136             50             70             29
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              31             25             15             99             57
#> 6              11            136             28            118            118
#> 7              73             59            108             60              3
#> 8              NA             NA             NA             NA             NA
#> 9             124             20            112             69             41
#> 10            108             38            118             24             49
#>    ECG..load.0.44 ECG..load.0.45 ECG..load.0.46 ECG..load.0.47 ECG..load.0.48
#> 1              NA             NA             NA             NA             NA
#> 2             118            104             38             24             23
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              78             37              7             79            130
#> 6             108             32            106             71             44
#> 7             130             13             48             83             97
#> 8              NA             NA             NA             NA             NA
#> 9             118             17             54             24            124
#> 10             28            108             76             21             19
#>    ECG..load.0.49 ECG..load.0.50 ECG..load.0.51 ECG..load.0.52 ECG..load.0.53
#> 1              NA             NA             NA             NA             NA
#> 2              18              3             62            128             71
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              46            130             91             33             93
#> 6             270             29            245              3            106
#> 7              61             77             81             30             53
#> 8              NA             NA             NA             NA             NA
#> 9              48             24             55             57              0
#> 10             24             95             27              4             51
#>    ECG..load.0.54 ECG..load.0.55 ECG..load.0.56 ECG..load.0.57 ECG..load.0.58
#> 1              NA             NA             NA             NA             NA
#> 2              33             23              6            104            136
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5               2             96             90             50             18
#> 6              26            105             60             70             44
#> 7              93             79             77             84             48
#> 8              NA             NA             NA             NA             NA
#> 9              58            127             85             84            110
#> 10            103             76            118             33             14
#>    ECG..load.0.59 ECG..load.0.60 ECG..load.0.61 ECG..load.0.62 ECG..load.0.63
#> 1              NA             NA             NA             NA             NA
#> 2               0             18             63            108             47
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              46             28             36              9            195
#> 6              77            103             62             47             74
#> 7              32             54             96             40             61
#> 8              NA             NA             NA             NA             NA
#> 9              67             52             43             24            121
#> 10            105             11             72             91             51
#>    ECG..load.0.64 ECG..load.0.65 ECG..load.0.66 ECG..load.0.67 ECG..load.0.68
#> 1              NA             NA             NA             NA             NA
#> 2               2            116             58             44            120
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              26             69              3            103             29
#> 6              17             86             43             75              9
#> 7              90             44              9            140             19
#> 8              NA             NA             NA             NA             NA
#> 9              96            270              4             26             73
#> 10             79             92            103             38             82
#>    ECG..load.0.69 ECG..load.0.70 ECG..load.0.71 ECG..load.0.72 ECG..load.0.73
#> 1              NA             NA             NA             NA             NA
#> 2              77             50             51             18            132
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              77             34             41             26            105
#> 6              35             82             49             80             93
#> 7              66             46             27             26            127
#> 8              NA             NA             NA             NA             NA
#> 9              29             28            136             48             75
#> 10             96             87             34             39             13
#>    ECG..load.0.74 ECG..load.0.75 ECG..load.0.76 ECG..load.0.77 ECG..load.0.78
#> 1              NA             NA             NA             NA             NA
#> 2             130             96             15             42             45
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              29             81             94              2             71
#> 6             105             97             65             94              5
#> 7              96            245            121             83              3
#> 8              NA             NA             NA             NA             NA
#> 9             109              2             24             26             49
#> 10              1             81              4             83            118
#>    ECG..load.0.79 ECG..load.0.80 ECG..load.0.81 ECG..load.0.82 ECG..load.0.83
#> 1              NA             NA             NA             NA             NA
#> 2               0             53             13             58             25
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              56             18             18             57             56
#> 6              22              5             60             51            128
#> 7              48             50             55             57             51
#> 8              NA             NA             NA             NA             NA
#> 9              36             92             19             24             16
#> 10              5             44             75            100            109
#>    ECG..load.0.84 ECG..load.0.85 ECG..load.0.86 ECG..load.0.87 ECG..load.0.88
#> 1              NA             NA             NA             NA             NA
#> 2              23             53            102             76             13
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              38             18              5            136             39
#> 6              23             52             25             55             79
#> 7              62              2             76             59             49
#> 8              NA             NA             NA             NA             NA
#> 9              40            127             91            110              5
#> 10             13             84             49            102             63
#>    ECG..load.0.89 ECG..load.0.90 ECG..load.0.91 ECG..load.0.92 ECG..load.0.93
#> 1              NA             NA             NA             NA             NA
#> 2              55             54            127             75            270
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5               3            116             11             74            110
#> 6              43              0            128             87             51
#> 7              56              3             25             61             20
#> 8              NA             NA             NA             NA             NA
#> 9             112             41             82             82             21
#> 10             35             82             23             92             79
#>    ECG..load.0.94 ECG..load.0.95 ECG..load.0.96 ECG..load.0.97 ECG..load.0.98
#> 1              NA             NA             NA             NA             NA
#> 2             118             60            127             37             45
#> 3              NA             NA             NA             NA             NA
#> 4              NA             NA             NA             NA             NA
#> 5              14             21             60             39             66
#> 6             120             67             83            103            270
#> 7             102             61             28             41             55
#> 8              NA             NA             NA             NA             NA
#> 9              15             23             76             30             13
#> 10             38            128             25             81             45
#>    ECG..load.0.99 ECG..load.0.100 ECG..load.0.101 ECG..load.0.102
#> 1              NA              NA              NA              NA
#> 2              19              35              73             106
#> 3              NA              NA              NA              NA
#> 4              NA              NA              NA              NA
#> 5              15             106              15              50
#> 6              47               8             121              79
#> 7              40              69             115              51
#> 8              NA              NA              NA              NA
#> 9             106              47              14              55
#> 10             42              62              18               5
#>    ECG..load.0.103 ECG..load.0.104 ECG..load.0.105 ECG..load.0.106
#> 1               NA              NA              NA              NA
#> 2                7              55             116              78
#> 3               NA              NA              NA              NA
#> 4               NA              NA              NA              NA
#> 5               85              48              71              72
#> 6              109              35              58              28
#> 7               23             110               1              40
#> 8               NA              NA              NA              NA
#> 9               57               6              83              21
#> 10              44             110               5              62
#>    ECG..load.0.107 ECG..load.0.108 ECG..load.0.109 ECG..load.0.110
#> 1               NA              NA              NA              NA
#> 2               75             270              11              25
#> 3               NA              NA              NA              NA
#> 4               NA              NA              NA              NA
#> 5               53              68               0              97
#> 6              130             136              85              78
#> 7               30              66              99              25
#> 8               NA              NA              NA              NA
#> 9               97              40              84              56
#> 10              87              13              74              41
#>    ECG..load.0.111 ECG..load.0.112 ECG..load.0.113
#> 1               NA              NA              NA
#> 2              121             121              83
#> 3               NA              NA              NA
#> 4               NA              NA              NA
#> 5               13              48             105
#> 6               99              99              91
#> 7                6              61              29
#> 8               NA              NA              NA
#> 9              110              52             124
#> 10              66             106              48
#>         Cancer.code..self.reported.0.0    Sex Year.of.birth Month.of.birth
#> 1                                                        NA               
#> 2                      cervical cancer   Male          1954      September
#> 3                                                        NA               
#> 4                                                        NA               
#> 5                      chronic myeloid Female          1950        January
#> 6  metastatic cancer (unknown primary) Female          1942       February
#> 7           uterine/endometrial cancer Female          1964       December
#> 8                                                        NA               
#> 9                      chronic myeloid Female          1944          April
#> 10                      bladder cancer Female          1947       November
```
