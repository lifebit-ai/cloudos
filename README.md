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
  - [Get a cohort](#get-a-cohort)
  - [Get sample (participants)
    table](#get-sample-participants-table)
  - [Get genotypic table](#get-genotypic-table)
  - [Filtering](#filtering)
  - [Additional for UI](#additional-for-ui)

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

Require few cloudos server login details, which will used in next step
to create a `my_cloudos` object

Note: If no `base_url` given the default is
<https://cloudos.lifebit.ai/>

``` r
cb_base_url <- "http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com"
my_auth <- "Bearer *************************"
my_team_id <- "***************************"
# OR from environment variable stored in a ~/.Renviron file
my_auth <- Sys.getenv("cloudos_Bearer_token")
my_team_id <- Sys.getenv("cloudos_team_id")
```

### Create a cloudos object

This object can be used as input to other functions, which directly
requires to communicate with the cloudos server.

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
cohorts <- cloudos::cohorts_list(my_cloudos)
#> Total number of cohorts found-49. But here is 10. For more, change 'page_number' and 'page_size'
head(cohorts,5)
#>                         id        name
#> 1 5f2ab881b695de55d93024a7        test
#> 2 5f327e8c1733200222dc3e8c      test_2
#> 3 5f32c2147ca1902e9c5ba45d      test-R
#> 4 5f32e1687ca1902e9c5ba467 Test cohort
#> 5 5f32f1407ca1902e9c5ba46e    Cohort-R
#>                                           description number_of_participants
#> 1                                           test-desc                 414326
#> 2                                         some random                 514407
#> 3                                  created from R lib                 600000
#> 4                 This cohort is for testing purpose.                 600000
#> 5 This cohort is for testing purpose, created from R.                 600000
#>   number_of_filters               created_at               updated_at
#> 1                 1 2020-08-05T13:47:45.826Z 2020-08-14T10:48:37.284Z
#> 2                 1 2020-08-11T11:18:36.703Z 2020-09-01T13:51:34.560Z
#> 3                 0 2020-08-11T16:06:44.205Z 2020-08-11T16:06:44.205Z
#> 4                 0 2020-08-11T18:20:24.356Z 2020-08-11T18:20:24.356Z
#> 5                 0 2020-08-11T19:28:00.606Z 2020-08-11T19:28:00.606Z
```

### Create a cohort

Create a new cohort.

``` r
my_cohort <- cloudos::create_cohort(my_cloudos,
              cohort_name = "Cohort-R",
              cohort_desc = "This cohort is for testing purpose, created from R.")
#> Cohort created successfully.
my_cohort
#> Cphort ID:  5f4e55799a350d4bb04dd92f 
#> Cphort Name:  Cohort-R 
#> Cohort Description:  This cohort is for testing purpose, created from R.
```

### Get a cohort

Get a available cohort in to a cohort R object.

``` r
my_cohort <- cloudos::cohort(my_cloudos, cohort_id = "5f327e8c1733200222dc3e8c")
my_cohort
#> Cphort ID:  5f327e8c1733200222dc3e8c 
#> Cphort Name:  test_2 
#> Cohort Description:  some random
```

### Get sample (participants) table

Get all the sample (participants) table for a cohort.

``` r
cohort_samples <- cloudos::get_samples_table(my_cloudos, my_cohort)
head(cohort_samples, 5)
#>                        _id       i      f20001i0a0 f31i0a0 f34i0a0   f52i0a0
#> 1 5edbdd689d700db709af0c2f 1000016 cervical cancer    Male    1954 September
#> 2 5edbdd689d700db709af0c3e 1000048 chronic myeloid  Female    1950   January
#> 3 5edbdd689d700db709af0c2a 1000063 chronic myeloid  Female    1944     April
#> 4 5edbdd689d700db709af0c4d 1000068  bladder cancer  Female    1947  November
#> 5 5edbdd689d700db709af0c2c 1000080 cervical cancer  Female    1941  November
#>        f5984i0aavg f5984i0amin f5984i0amax
#> 1 65.7105263157895           0         270
#> 2 59.2368421052632           0         195
#> 3 65.0350877192982           0         270
#> 4 63.9824561403509           0         195
#> 5 61.1929824561403           0         270
```

### Get genotypic table

Get all the genotypic table for a cohort.

``` r
#cohort_genotype <- cloudos::get_genotypic_table(my_cloudos, my_cohort)
cohort_genotype <- cloudos::get_genotypic_table(my_cloudos)
head(cohort_genotype, 5)
#>      _id                        Chromosome Location   Reference Alternative
#> [1,] "5ef793999b8097fcd1da226a" "10"       "10:93190" "AC"      " "        
#> [2,] "5ef793719b8097fcd1cea2f3" "10"       "10:93502" "C"       "G"        
#> [3,] "5ef793719b8097fcd1cea2ff" "10"       "10:93635" "T"       "C"        
#> [4,] "5ef793999b8097fcd1da2266" "10"       "10:94514" "CTGG"    " "        
#> [5,] "5ef793999b8097fcd1da2277" "10"       "10:94693" "G"       " "        
#>      Affimetrix ID Possible allele combination 0 Possible allele combination 1
#> [1,] "80278591"    "GAC G"                       "0 0"                        
#> [2,] "52134431"    "C C"                         "0 0"                        
#> [3,] "3729558"     "T T"                         "0 0"                        
#> [4,] "52349171"    "CCTGG CCT"                   "C CCTGG"                    
#> [5,] "80278592"    "AG"                          "0 0"                        
#>      Possible allele combination 2 index Type        id  cn          
#> [1,] "G GAC"                       "0"   "Insertion" "1" "zzg_m_10_0"
#> [2,] "G C"                         "1"   "SNP"       "2" "zzg_m_10_1"
#> [3,] "C T"                         "2"   "SNP"       "3" "zzg_m_10_2"
#> [4,] "0 0"                         "3"   "Insertion" "4" "zzg_m_10_3"
#> [5,] "A A"                         "4"   "SNP"       "5" "zzg_m_10_4"
#>      <NA>          <NA>          <NA>                <NA>               
#> [1,] NA            NA            NA                  NA                 
#> [2,] "rs201177578" "Deleterious" "Possibly Damaging" "Possibly Damaging"
#> [3,] "rs200242637" "Deleterious" "Benign"            "Benign"           
#> [4,] NA            NA            NA                  NA                 
#> [5,] NA            NA            NA                  NA                 
#>      <NA>      <NA>              <NA>     <NA>          <NA>         
#> [1,] NA        NA                NA       NA            NA           
#> [2,] "Unknown" "Disease Causing" "Medium" "Deleterious" "Deleterious"
#> [3,] "Unknown" "Disease Causing" "Medium" "Tolerated"   "Deleterious"
#> [4,] NA        NA                NA       NA            NA           
#> [5,] NA        NA                NA       NA            NA           
#>      <NA>        <NA>          <NA>  <NA> 
#> [1,] NA          NA            NA    NA   
#> [2,] "Tolerated" "Deleterious" "542" "244"
#> [3,] "Tolerated" "Tolerated"   "615" "27" 
#> [4,] NA          NA            NA    NA   
#> [5,] NA          NA            NA    NA   
#>      <NA>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
#> [1,] NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
#> [2,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"
#> [3,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"
#> [4,] NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
#> [5,] "GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER"
#>      <NA>    <NA>                                  <NA>    <NA>    <NA>   
#> [1,] NA      NA                                    NA      NA      NA     
#> [2,] "TUBB8" "TUBB8:NM 177987:exon4:cG830C:pG277A" "0.002" "0.787" "0.598"
#> [3,] "TUBB8" "TUBB8:NM 177987:exon4:cA697G:pM233V" "0.012" "0.01"  "0.043"
#> [4,] NA      NA                                    NA      NA      NA     
#> [5,] "TUBB8" NA                                    NA      NA      NA     
#>      <NA>    <NA> <NA>    <NA>    <NA>    <NA>    <NA>    <NA>     <NA>   
#> [1,] NA      NA   NA      NA      NA      NA      NA      NA       NA     
#> [2,] "0.001" "1"  "2.155" "-1.84" "-4.65" "0.41"  "0.877" "-0.012" "0.561"
#> [3,] "0"     "1"  "2.105" "-0.18" "-3.33" "0.098" "0.713" "-0.829" "0.183"
#> [4,] NA      NA   NA      NA      NA      NA      NA      NA       NA     
#> [5,] NA      NA   NA      NA      NA      NA      NA      NA       NA     
#>      <NA>     <NA>     <NA>     <NA>   <NA>     <NA>     <NA>    <NA>     <NA>
#> [1,] NA       NA       NA       NA     NA       NA       NA      NA       NA  
#> [2,] NA       NA       NA       NA     NA       NA       NA      NA       NA  
#> [3,] "0.0279" "0.0174" "0.0196" "0.04" "0.0194" "0.0573" "0.028" "0.0461" NA  
#> [4,] NA       NA       NA       NA     NA       NA       NA      NA       NA  
#> [5,] NA       NA       NA       NA     NA       NA       NA      NA       NA  
#>      <NA>
#> [1,] NA  
#> [2,] NA  
#> [3,] NA  
#> [4,] NA  
#> [5,] NA
```

### Filtering

#### Search avaiable filters

``` r
all_filters <- cloudos::search_filters(my_cloudos, term = "cancer")
#> Total number of filters - 29
head(all_filters, 5)
#>                        _id           categoryPathLevel1 categoryPathLevel2
#> 1 5eb55c78599ae918ebb48f69 UK Biobank Assessment Centre        Touchscreen
#> 2 5eb55c78599ae918ebb48f6b UK Biobank Assessment Centre        Touchscreen
#> 3 5eb55c78599ae918ebb48f7d UK Biobank Assessment Centre        Touchscreen
#> 4 5eb55c78599ae918ebb48fa6 UK Biobank Assessment Centre        Touchscreen
#> 5 5eb55c78599ae918ebb48fb3 UK Biobank Assessment Centre        Touchscreen
#>           categoryPathLevel3      categoryPathLevel4   id
#> 1 Health and medical history        Cancer screening 2345
#> 2 Health and medical history        Cancer screening 2355
#> 3 Health and medical history      Medical conditions 2453
#> 4       Sex-specific factors Female-specific factors 2674
#> 5       Sex-specific factors Female-specific factors 2684
#>                                                   name      type
#> 1                      Ever had bowel cancer screening      bars
#> 2                   Most recent bowel cancer screening histogram
#> 3                           Cancer diagnosed by doctor      bars
#> 4         Ever had breast cancer screening / mammogram      bars
#> 5 Years since last breast cancer screening / mammogram histogram
#>            valueType units instances array
#> 1 Categorical single               4     1
#> 2            Integer years         4     1
#> 3 Categorical single               4     1
#> 4 Categorical single               4     1
#> 5            Integer years         4     1
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          description
#> 1 "ACE touchscreen question ""Have you ever had a screening test for bowel (colorectal) cancer? (Please include tests for blood in the stool/faeces or a colonoscopy or a sigmoidoscopy)"" If the participant activated the Help button they were shown the message:     Screening tests for bowel or colorectal cancer include:  - FOBT (faecal occult blood test) - this is when you    are given a set of cards and asked to smear a part    of your stool on three separate occasions onto the    cards and then return the cards to be tested for    blood.  - Sigmoidoscopy - a tube is used to examine the lower    bowel. This is usually done in a doctor's office    without pain relief.  - Colonoscopy - a long tube is used the examine the    whole large bowel; you would usually have to drink    a large amount of special liquid to prepare the    bowel; and you would be given a sedative medication    for the procedure.     "
#> 2                                                                                                                                                                                                                                                                                                                                                                          "ACE touchscreen question ""How many years ago was the most recent one of these tests?"" The following checks were performed:  If answer   If answer > Participants age - 5 years then rejected  If answer > 20 then participant asked to confirm   If the participant activated the Help button they were shown the message:     If you are unsure; please provide an estimate or select Do not know.      ~F2355~ was collected from participants who indicated they have had a screening test for bowel (colorectal) cancer; as indicated by their answers to ~F2345~"
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      "ACE touchscreen question ""Has a doctor ever told you that you have had cancer?"" If the participant activated the Help button they were shown the message:     If you are unsure if you have been told you had cancer; select Do not know and you will be asked about this by an interviewer later during this visit.     "
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       "ACE touchscreen question ""Have you ever been for breast cancer screening (a mammogram)?"""
#> 5                                                                                                                                                                                                                                                                                                                                                                                                                              "ACE touchscreen question ""How many years ago was your last screen?"" The following checks were performed:  If answer   If answer > Participants age - 15 years then rejected  If answer > 15 then participant asked to confirm   If the participant activated the Help button they were shown the message:     If you are unsure; please provide an estimate or select Do not know.      ~F2684~ was collected from women who indicated that they had been for a mammogram; as defined by their answers to ~F2674~"
#>   descriptionParticipantsNo descriptionItemNo descriptionStability coding
#> 1                    501599            572225             Complete 100349
#> 2                    180035            202611             Complete 100567
#> 3                    501592            572218             Complete 100603
#> 4                    272921            309271             Complete 100349
#> 5                    223188            252179             Complete 100567
#>   descriptionCategoryID descriptionItemType descriptionStrata descriptionSexed
#> 1                100040                Data           Primary           Unisex
#> 2                100040                Data           Primary           Unisex
#> 3                100044                Data           Primary           Unisex
#> 4                100069                Data           Primary           Female
#> 5                100069                Data           Primary           Female
#>                                                      link
#> 1 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2345
#> 2 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2355
#> 3 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2453
#> 4 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2674
#> 5 http://biobank.ctsu.ox.ac.uk/showcase/field.cgi?id=2684
#>                                                                                 instance0Name
#> 1 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 2 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 3 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 4 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#> 5 Initial assessment visit (2006-2010) at which participants were recruited and consent given
#>                             instance1Name         instance2Name
#> 1 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 2 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 3 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 4 First repeat assessment visit (2012-13) Imaging visit (2014+)
#> 5 First repeat assessment visit (2012-13) Imaging visit (2014+)
#>                        instance3Name instance4Name instance5Name instance6Name
#> 1 First repeat imaging visit (2019+)                                          
#> 2 First repeat imaging visit (2019+)                                          
#> 3 First repeat imaging visit (2019+)                                          
#> 4 First repeat imaging visit (2019+)                                          
#> 5 First repeat imaging visit (2019+)                                          
#>   instance7Name instance8Name instance9Name instance10Name instance11Name
#> 1                                                                        
#> 2                                                                        
#> 3                                                                        
#> 4                                                                        
#> 5                                                                        
#>   instance12Name instance13Name instance14Name instance15Name instance16Name
#> 1                                                                           
#> 2                                                                           
#> 3                                                                           
#> 4                                                                           
#> 5                                                                           
#>   bucket300 bucket500 bucket1000 bucket2500 bucket5000 bucket10000
#> 1     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 2     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 3     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 4     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#> 5     FALSE     FALSE      FALSE      FALSE      FALSE       FALSE
#>   orderPhenotype checked
#> 1             40       1
#> 2             40       1
#> 3             42       1
#> 4             47       1
#> 5             47       1
```

#### Phenotype filtering

``` r
# lets apply this first filter
all_filters[1,]
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

# phenotype filter
cohort_with_filters <- cloudos::filter_samples(my_cloudos, 
                                   cohort = my_cohort, 
                                   filter_id = all_filters[1,]$id)
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
                                                cohort = my_cohort, 
                                                filter_id = all_filters[1,]$id)
 
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
                     cohort = my_cohort,
                     filter_id = all_filters[1,]$id)

gs
#>      cohortId                   markers filters _id                       
#> data "5f327e8c1733200222dc3e8c" List,0  List,1  "5f4e557faaafb6454ad4a324"
#>      numberOfParticipants
#> data 32545
```

``` r
df <- cloudos::filter_metadata(my_cloudos,
                     filter_id = all_filters[1,]$id)
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

### Additional for UI

#### Get samples table for selected rows

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
