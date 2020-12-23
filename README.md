
# cloudos <img src="man/figures/logo/hexlogo.png" align="right" height=140/>

<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/lifebit-ai/cloudos/workflows/R-CMD-check/badge.svg)](https://github.com/lifebit-ai/cloudos/actions)
<!-- badges: end -->

**cloudos** R package makes it easy to interact with Lifebit’s CloudOS
<https://cloudos.lifebit.ai/> platform in the R environment.

## Installation

You can install the released version of **cloudos** from
[GitHub](https://github.com/lifebit-ai/cloudos/) at this moment. (Will
be listed on [CRAN](https://CRAN.R-project.org) as well)

``` r
if (!require(remotes)) { install.packages("remotes") }
  remotes::install_github("lifebit-ai/cloudos")
```

## Usage

Bellow are given the demonstration of how the **cloudos** package can be
used.

### Load the library

``` r
library(cloudos)
#> 
#> Welcome to Lifebit's CloudOS R client 
#> For Documentation visit - http://lifebit-ai.github.io/cloudos 
#> This package is under activate development. If you found any issues, 
#> Please reach out here - https://github.com/lifebit-ai/cloudos/issues
library(knitr) # For better visualization of wide dataframes in this README examples
library(magrittr) # For pipe
```

### Configure CloudOS

The cloudos functions will be need set of cloudos configurations for
able to connect to API. Lets see different ways of R package will try to
find those configurations.

1.  From Environment variable
2.  From cloudos configuration file

First thing this R-package will look for environment variables -
`CLOUDOS_BASEURL`, `CLOUDOS_TOKEN`, `CLOUDOS_TEAMID` and if not found it
will try to read from `~/.cloudos/config`.

Three ways to set cloudos environment variables

1.  Add them to `~/.Renviron`, which will load the environment variables
    on beginning of the R-session
2.  Add them using `Sys.setenv(ENV_VAR = "env_var_value")`
3.  Use the function `cloudos_configure()`, which will create a
    `~/.cloudos/config` (Recommended way if you using multiple cloudos
    clients)

## Application - Cohort Browser

Cohort Browser is part of Lifebit’s cloudos offering. Lets explore how
to interact with this in R environment.

### List Cohorts

To check list of available cohorts in a workspace.

``` r
cohorts <- cb_list_cohorts()
#> Total number of cohorts found-78. But here shows-10 as default. For more, change size = 78 to get all.
cohorts %>% kable()
```

| id                       | name            | description      | number\_of\_participants | number\_of\_filters | created\_at              | updated\_at              |
| :----------------------- | :-------------- | :--------------- | -----------------------: | ------------------: | :----------------------- | :----------------------- |
| 5fd9da48e3da655a4836e0aa | damian3         |                  |                    44667 |                   0 | 2020-12-16T09:58:32.942Z | 2020-12-16T09:58:32.942Z |
| 5fd8c234e34ec6186fe45d35 | Test Alberto 53 | Test description |                        4 |                  11 | 2020-12-15T14:03:32.394Z | 2020-12-16T17:01:27.225Z |
| 5fd88a13afc7200a2965d282 | Test Alberto 52 | Test description |                     2884 |                   2 | 2020-12-15T10:04:03.684Z | 2020-12-15T10:04:03.684Z |
| 5fd88972fb156109dbf8b9d4 | Test Alberto 51 | Test description |                     2884 |                   2 | 2020-12-15T10:01:22.801Z | 2020-12-15T10:01:22.801Z |
| 5fd888db775c6a099fdf6636 | Test Alberto 50 | Test description |                     2884 |                   2 | 2020-12-15T09:58:51.433Z | 2020-12-15T09:58:51.433Z |
| 5fd888097eb89a08eda68335 | Test Alberto 49 | Test description |                        0 |                   0 | 2020-12-15T09:55:21.831Z | 2020-12-15T14:22:15.293Z |
| 5fd8877fc2a78908b6d4083e | Test Alberto 48 | Test description |                     2884 |                   2 | 2020-12-15T09:53:03.775Z | 2020-12-15T09:53:03.775Z |
| 5fd8848ac56f6f0826d583d2 | Test Alberto 47 | Test description |                     2884 |                   2 | 2020-12-15T09:40:26.083Z | 2020-12-15T09:40:26.083Z |
| 5fd8832d4c827107921d83a7 | Test Alberto 46 | Test description |                     2884 |                   2 | 2020-12-15T09:34:37.947Z | 2020-12-15T09:34:37.947Z |
| 5fd882f594d869074efde02c | Test Alberto 45 | Test description |                     2884 |                   2 | 2020-12-15T09:33:41.180Z | 2020-12-15T09:33:41.180Z |

### Create a cohort

To create a new cohort.

``` r
my_cohort <- cb_create_cohort(cohort_name = "Cohort-R",
                             cohort_desc = "This cohort is for testing purpose, created from R.")
my_cohort
```

### Get a cohort

Get a available cohort in to a cohort R object. This cohort object can
be used in many different other functions.

``` r
my_cohort <- cb_load_cohort(cohort_id = "5f9af3793dd2dc6091cd17cd")
my_cohort
#> Cohort ID:  5f9af3793dd2dc6091cd17cd 
#> Cohort Name:  cb_demo_new 
#> Cohort Description:   
#> Number of filters applied:  2
```

### Get samples table

Get all the samples (participants) table for a cohort with phenotypic
filters applied.

``` r
cohort_samples <- cb_get_samples_table(cohort = my_cohort)
cohort_samples %>% kable()
```

| EID     | Programme     | Year of birth | Participant ethnic category                 | Participant karyotypic sex | Participant type | Acute flag | Biological relationship to proband |
| :------ | :------------ | :------------ | :------------------------------------------ | :------------------------- | :--------------- | :--------- | :--------------------------------- |
| 1000020 | Rare Diseases | 1970          | Not Stated                                  | Unknown                    | Relative         | Mother     | NULL                               |
| 1000522 | Rare Diseases | 1990          | White: Any other White background           | Not Supplied               | Relative         | Mother     | NULL                               |
| 100079  | Rare Diseases | 1967          | White: British                              | Not Supplied               | Relative         | Mother     | NULL                               |
| 100084  | Rare Diseases | 1953          | Other Ethnic Groups: Any other ethnic group | Not Supplied               | Relative         | Mother     | NULL                               |
| 1001429 | Rare Diseases | 1981          | White: British                              | Not Supplied               | Relative         | Mother     | NULL                               |
| 100245  | Rare Diseases | 2001          | White: British                              | Unknown                    | Relative         | Mother     | NULL                               |
| 1002999 | Rare Diseases | 1970          | White: British                              | Not Supplied               | Relative         | Father     | NULL                               |
| 1003149 | Rare Diseases | 1986          | White: British                              | Not Supplied               | Relative         | Father     | NULL                               |
| 1003363 | Rare Diseases | 1947          | White: British                              | Not Supplied               | Relative         | Mother     | NULL                               |
| 1003649 | Rare Diseases | 1982          | White: British                              | Not Supplied               | Relative         | Father     | NULL                               |

### Get genotypic table

Get all the genotypic table for a cohort.

``` r
#cohort_genotype <- cb_get_genotypic_table(my_cohort)
cohort_genotype <- cb_get_genotypic_table(cohort = my_cohort)
#> Total number of rows found 805357 You can use 'size' to mention how many rows you want to extract. Default size = 10
cohort_genotype %>% kable()
```

| Chromosome | Location  | Reference | Alternative | Affimetrix ID | Possible allele combination 0 | Possible allele combination 1 | Possible allele combination 2 | index | Type      | id | cn            | NA          | NA.1        | NA.2              | NA.3              | NA.4    | NA.5            | NA.6   | NA.7        | NA.8        | NA.9      | NA.10       | NA.11 | NA.12 | NA.13                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | NA.14          | NA.15                               | NA.16 | NA.17 | NA.18 | NA.19 | NA.20 | NA.21 | NA.22  | NA.23  | NA.24 | NA.25 | NA.26   | NA.27 | NA.28  | NA.29  | NA.30  | NA.31  | NA.32  | NA.33  | NA.34  | NA.35  | NA.36 | NA.37     |
| :--------- | :-------- | :-------- | :---------- | :------------ | :---------------------------- | :---------------------------- | :---------------------------- | :---- | :-------- | :- | :------------ | :---------- | :---------- | :---------------- | :---------------- | :------ | :-------------- | :----- | :---------- | :---------- | :-------- | :---------- | :---- | :---- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------------- | :---------------------------------- | :---- | :---- | :---- | :---- | :---- | :---- | :----- | :----- | :---- | :---- | :------ | :---- | :----- | :----- | :----- | :----- | :----- | :----- | :----- | :----- | :---- | :-------- |
| 10         | 10:93190  | AC        |             | 80278591      | GAC G                         | 0 0                           | G GAC                         | 0     | Insertion | 1  | zzg\_m\_10\_0 | NA          | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | NA             | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA    | NA        |
| 10         | 10:93502  | C         | G           | 52134431      | C C                           | 0 0                           | G C                           | 1     | SNP       | 2  | zzg\_m\_10\_1 | rs201177578 | Deleterious | Possibly Damaging | Possibly Damaging | Unknown | Disease Causing | Medium | Deleterious | Deleterious | Tolerated | Deleterious | 542   | 244   | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | TUBB8          | TUBB8:NM 177987:exon4:cG830C:pG277A | 0.002 | 0.787 | 0.598 | 0.001 | 1     | 2.155 | \-1.84 | \-4.65 | 0.41  | 0.877 | \-0.012 | 0.561 | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA    | NA        |
| 10         | 10:93635  | T         | C           | 3729558       | T T                           | 0 0                           | C T                           | 2     | SNP       | 3  | zzg\_m\_10\_2 | rs200242637 | Deleterious | Benign            | Benign            | Unknown | Disease Causing | Medium | Tolerated   | Deleterious | Tolerated | Tolerated   | 615   | 27    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | TUBB8          | TUBB8:NM 177987:exon4:cA697G:pM233V | 0.012 | 0.01  | 0.043 | 0     | 1     | 2.105 | \-0.18 | \-3.33 | 0.098 | 0.713 | \-0.829 | 0.183 | 0.0279 | 0.0174 | 0.0196 | 0.04   | 0.0194 | 0.0573 | 0.028  | 0.0461 | NA    | NA        |
| 10         | 10:94514  | CTGG      |             | 52349171      | CCTGG CCT                     | C CCTGG                       | 0 0                           | 3     | Insertion | 4  | zzg\_m\_10\_3 | NA          | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | NA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | NA             | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA    | NA        |
| 10         | 10:94693  | G         |             | 80278592      | AG                            | 0 0                           | A A                           | 4     | SNP       | 5  | zzg\_m\_10\_4 | NA          | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | TUBB8          | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA     | NA    | NA        |
| 10         | 10:95844  | C         | T           | 35481805      | C C                           | T C                           | 0 0                           | 5     | SNP       | 6  | zzg\_m\_10\_5 | rs117205301 | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | TUBB8          | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | 0.0242 | 0.0085 | 0.0155 | 0.0199 | 0.0025 | 0.0218 | 0.0367 | 0.0275 | T T   | 0.0364263 |
| 10         | 10:110655 | C         | T           | 2365062       | T C                           | 0 0                           | C C                           | 6     | SNP       | 7  | zzg\_m\_10\_6 | rs78253668  | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING | TUBB8; ZMYND11 | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | 0.2678 | 0.1517 | 0.195  | 0.2881 | 0.254  | 0.3489 | 0.3203 | 0.2916 | T T   | 0.315864  |
| 10         | 10:111955 | A         | G           | 2380802       | A A                           | G A                           | G G                           | 7     | SNP       | 8  | zzg\_m\_10\_7 | rs7909677   | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING | TUBB8; ZMYND11 | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | 0.0634 | 0.0352 | 0.0465 | 0.0265 | 0.066  | 0.0785 | 0.0786 | 0.0519 | 0 0   | 0.0843255 |
| 10         | 10:119812 | C         | T           | 2473215       | T T                           | C C                           | T C                           | 8     | SNP       | 9  | zzg\_m\_10\_8 | rs11253280  | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING | TUBB8; ZMYND11 | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | 0.4425 | 0.4947 | 0.3077 | 0.3699 | 0.3674 | 0.4488 | 0.4306 | 0.4063 | 0 0   | 0.444643  |
| 10         | 10:122109 | C         | T           | 2502714       | C C                           | T T                           | T C                           | 9     | SNP       | 10 | zzg\_m\_10\_9 | rs7093061   | NA          | NA                | NA                | NA      | NA              | NA     | NA          | NA          | NA        | NA          | NA    | NA    | GO CYTOSKELETON ORGANIZATION| GO OOGENESIS| GO MICROTUBULE BASED PROCESS| GO MICROTUBULE CYTOSKELETON ORGANIZATION| GO SEXUAL REPRODUCTION| GO ATOMICAL STRUCTURE MATURATION| GO MITOTIC CELL CYCLE| GO ORGANELLE FISSION| GO CELL MATURATION| GO ORGANELLE ASSEMBLY| GO CELLULAR PROCESS INVOLVED IN REPRODUCTION IN MULTICELLULAR ORGANISM| GO OOCYTE MATURATION| GO OOCYTE DIFFERENTIATION| GO MEIOTIC CELL CYCLE| GO CELL CYCLE| GO MULTI ORGANISM REPRODUCTIVE PROCESS| GO GAMETE GENERATION| GO FEMALE GAMETE GENERATION| GO DEVELOPMENTAL PROCESS INVOLVED IN REPRODUCTION| GO MEIOTIC CELL CYCLE PROCESS| GO SPINDLE ASSEMBLY| GO REPRODUCTION| GO GERM CELL DEVELOPMENT| GO MULTICELLULAR ORGANISM REPRODUCTION| GO DEVELOPMENTAL MATURATION| GO CELL CYCLE PROCESS| GO MICROTUBULE CYTOSKELETON| GO CYTOSKELETAL PART| GO MICROTUBULE| GO SPINDLE| GO GTPASE ACTIVITY| GO HYDROLASE ACTIVITY ACTING ON ACID ANHYDRIDES| GO GUANYL NUCLEOTIDE BINDING| GO RIBONUCLEOTIDE BINDING| GO STRUCTURAL CONSTITUENT OF CYTOSKELETON| GO STRUCTURAL MOLECULE ACTIVITY| GO MEIOTIC SPINDLE ORGANIZATION| GO SPINDLE ORGANIZATION| GO FEMALE MEIOTIC NUCLEAR DIVISION| GO SPINDLE ASSEMBLY INVOLVED IN MEIOSIS| GO MEIOTIC SPINDLE| GO SUPRAMOLECULAR COMPLEX| GO POLYMERIC CYTOSKELETAL FIBER; GO CHROMOSOME ORGANIZATION| GO D TEMPLATED TRANSCRIPTION ELONGATION| GO REGULATION OF MAPK CASCADE| GO REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO I KAPPAB KISE NF KAPPAB SIGLING| GO DEFENSE RESPONSE TO VIRUS| GO EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO NEGATIVE REGULATION OF MAPK CASCADE| GO NEGATIVE REGULATION OF INTRACELLULAR SIGL TRANSDUCTION| GO DEFENSE RESPONSE| GO NEGATIVE REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO REGULATION OF TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO DEFENSE RESPONSE TO OTHER ORGANISM| GO APOPTOTIC SIGLING PATHWAY| GO TRANSCRIPTION ELONGATION FROM R POLYMERASE II PROMOTER| GO JNK CASCADE| GO REGULATION OF EXTRINSIC APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO REGULATION OF RESPONSE TO STRESS| GO PROTEIN PHOSPHORYLATION| GO CHROMATIN ORGANIZATION| GO NEGATIVE REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF I KAPPAB KISE NF KAPPAB SIGLING| GO INTERSPECIES INTERACTION BETWEEN ORGANISMS| GO CELL CYCLE| GO NEGATIVE REGULATION OF JNK CASCADE| GO NEGATIVE REGULATION OF APOPTOTIC SIGLING PATHWAY| GO NEGATIVE REGULATION OF STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF CELLULAR RESPONSE TO STRESS| GO REGULATION OF CELL DEATH| GO NEGATIVE REGULATION OF RESPONSE TO STIMULUS| GO NEGATIVE REGULATION OF PHOSPHORYLATION| GO NEGATIVE REGULATION OF PROTEIN METABOLIC PROCESS| GO RESPONSE TO BIOTIC STIMULUS| GO REGULATION OF PROTEIN MODIFICATION PROCESS| GO SIGL TRANSDUCTION BY PROTEIN PHOSPHORYLATION| GO STRESS ACTIVATED PROTEIN KISE SIGLING CASCADE| GO REGULATION OF PHOSPHORUS METABOLIC PROCESS| GO RESPONSE TO VIRUS| GO NEGATIVE REGULATION OF PROTEIN MODIFICATION PROCESS| GO REGULATION OF D TEMPLATED TRANSCRIPTION ELONGATION| GO IMMUNE EFFECTOR PROCESS| GO REGULATION OF APOPTOTIC SIGLING PATHWAY| GO CHROMOSOME| GO HISTONE BINDING| GO METHYLATED HISTONE BINDING| GO DOUBLE STRANDED D BINDING| GO TRANSITION METAL ION BINDING| GO ZINC ION BINDING| GO TRANSCRIPTION COREPRESSOR ACTIVITY| GO APOPTOTIC PROCESS| GO NEGATIVE REGULATION OF BIOSYNTHETIC PROCESS| GO NEGATIVE REGULATION OF SIGLING| GO NEGATIVE REGULATION OF R BIOSYNTHETIC PROCESS| GO TRANSCRIPTION COREGULATOR ACTIVITY| GO MODIFICATION DEPENDENT PROTEIN BINDING | TUBB8; ZMYND11 | NA                                  | NA    | NA    | NA    | NA    | NA    | NA    | NA     | NA     | NA    | NA    | NA      | NA    | 0.2538 | 0.1036 | 0.2734 | 0.3514 | 0.0961 | 0.282  | 0.3489 | 0.3077 | 0 0   | 0.35744   |

### Explore Filters

#### Search phenotypic filters

Search for phenotypic filters based on a term.

``` r
all_filters <- cb_search_phenotypic_filters(term = "cancer")
#> Total number of phenotypic filters found - 4
all_filters %>% kable()
```

| bucket500 | bucket1000 | bucket2500 | bucket5000 | bucket300 | bucket10000 | categoryPathLevel1 | categoryPathLevel2  | id  | instances | name                             | type         | Sorting | valueType            | units | coding | description                                                                                                                                                                                                                                                                                  | descriptionParticipantsNo | link                                                              | array | descriptionStability | descriptionCategoryID | descriptionItemType | descriptionStrata   | descriptionSexed | orderPhenotype | instance0Name | instance1Name | instance2Name | instance3Name | instance4Name | instance5Name | instance6Name | instance7Name | instance8Name | instance9Name | instance10Name | instance11Name | instance12Name | instance13Name | instance14Name | instance15Name | instance16Name |
| :-------- | :--------- | :--------- | :--------- | :-------- | :---------- | :----------------- | :------------------ | :-- | :-------- | :------------------------------- | :----------- | :------ | :------------------- | :---- | :----- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------ | :---------------------------------------------------------------- | :---- | :------------------- | :-------------------- | :------------------ | :------------------ | :--------------- | :------------- | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------- | :------------- | :------------- | :------------- | :------------- | :------------- | :------------- |
| FALSE     | FALSE      | FALSE      | FALSE      | FALSE     | FALSE       | Cancer             | Participant disease | 177 | 1         | Cancer disease sub type          | bars         |         | Categorical multiple |       |        | The subtype of the cancer in question, recorded against a limited set of supplied enumerations.                                                                                                                                                                                              | 17404                     | <https://cnfl.extge.co.uk/pages/viewpage.action?pageId=147659370> | 4     |                      |                       |                     | Main 100k Programme |                  |                |               |               |               |               |               |               |               |               |               |               |                |                |                |                |                |                |                |
| FALSE     | FALSE      | FALSE      | FALSE      | FALSE     | FALSE       | Cancer             | Participant disease | 178 | 1         | Cancer disease type              | bars         |         | Categorical multiple |       |        | The cancer type of the tumour sample submitted to Genomics England.                                                                                                                                                                                                                          | 17404                     | <https://cnfl.extge.co.uk/pages/viewpage.action?pageId=147659370> | 4     |                      |                       |                     | Main 100k Programme |                  |                |               |               |               |               |               |               |               |               |               |               |                |                |                |                |                |                |                |
| FALSE     | FALSE      | FALSE      | FALSE      | FALSE     | FALSE       | Cancer             | Participant Tumour  | 190 | 1         | Cancer tumour sk                 | text\_search |         | Text                 |       |        | Database identifier for a participant’s registered tumour                                                                                                                                                                                                                                    | 9561                      | <https://cnfl.extge.co.uk/pages/viewpage.action?pageId=147659370> | 5     |                      |                       |                     | Main 100k Programme |                  |                |               |               |               |               |               |               |               |               |               |               |                |                |                |                |                |                |                |
| FALSE     | FALSE      | FALSE      | FALSE      | FALSE     | FALSE       | Cancer             | Participant Tumour  | 272 | 1         | Pancreatic cancer clinical stage | bars         |         | Categorical multiple |       |        | COSD UG14560, UPPER GI - STAGING - PANCREAS. Description: ’Clinically agreed stage based on radiological findings of tumour extent in order to offer treatment recommendations. The category selected depends on tumour location within the pancreas and the arterial or venous involvement. | 9561                      | <https://cnfl.extge.co.uk/pages/viewpage.action?pageId=147659370> | 5     |                      |                       |                     | Main 100k Programme |                  |                |               |               |               |               |               |               |               |               |               |               |                |                |                |                |                |                |                |

Lets choose one filter from above table

``` r
# apply this first row filter
my_phenotypic_filter <- all_filters[1,]
my_phenotypic_filter %>% kable()
```

| bucket500 | bucket1000 | bucket2500 | bucket5000 | bucket300 | bucket10000 | categoryPathLevel1 | categoryPathLevel2  | id  | instances | name                    | type | Sorting | valueType            | units | coding | description                                                                                     | descriptionParticipantsNo | link                                                              | array | descriptionStability | descriptionCategoryID | descriptionItemType | descriptionStrata   | descriptionSexed | orderPhenotype | instance0Name | instance1Name | instance2Name | instance3Name | instance4Name | instance5Name | instance6Name | instance7Name | instance8Name | instance9Name | instance10Name | instance11Name | instance12Name | instance13Name | instance14Name | instance15Name | instance16Name |
| :-------- | :--------- | :--------- | :--------- | :-------- | :---------- | :----------------- | :------------------ | :-- | :-------- | :---------------------- | :--- | :------ | :------------------- | :---- | :----- | :---------------------------------------------------------------------------------------------- | :------------------------ | :---------------------------------------------------------------- | :---- | :------------------- | :-------------------- | :------------------ | :------------------ | :--------------- | :------------- | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------ | :------------- | :------------- | :------------- | :------------- | :------------- | :------------- | :------------- |
| FALSE     | FALSE      | FALSE      | FALSE      | FALSE     | FALSE       | Cancer             | Participant disease | 177 | 1         | Cancer disease sub type | bars |         | Categorical multiple |       |        | The subtype of the cancer in question, recorded against a limited set of supplied enumerations. | 17404                     | <https://cnfl.extge.co.uk/pages/viewpage.action?pageId=147659370> | 4     |                      |                       |                     | Main 100k Programme |                  |                |               |               |               |               |               |               |               |               |               |               |                |                |                |                |                |                |                |

#### Apply phenotypic filter

We can get statistic of sample numbers in a cohort for which a filter is
applied.

``` r
# phenotype filter
cohort_with_filters <- cb_get_filter_statistics(cohort = my_cohort, 
                                     filter_id = my_phenotypic_filter$id)
cohort_with_filters %>% kable()
```

| \_id                                              | number | total |
| :------------------------------------------------ | -----: | ----: |
| (All) Acute Lymphoblastic Leukaemia               |     46 |  4449 |
| (Aml) Acute Myeloid Leukaemia                     |     55 |  4449 |
| Acral Lentiginous                                 |      1 |  4449 |
| Adamantinoma Of Bone                              |      7 |  4449 |
| Adenocarcinoma                                    |    982 |  4449 |
| Anaplastic Astrocytoma                            |     11 |  4449 |
| Anaplastic Oligodendroglioma                      |      5 |  4449 |
| Angiosarcoma                                      |      3 |  4449 |
| Biliary Adenocarcinoma                            |      1 |  4449 |
| Carcinosarcoma                                    |     12 |  4449 |
| Childhood Other                                   |     20 |  4449 |
| Cholangiocarcinoma                                |      9 |  4449 |
| Chordoma                                          |      8 |  4449 |
| Chromophobe                                       |      6 |  4449 |
| Chronic Lymphocytic Leukaemia                     |     55 |  4449 |
| Chronic Myeloid Leukaemia                         |     14 |  4449 |
| Classical Seminoma                                |      3 |  4449 |
| Clear Cell Adenocarcinoma                         |      4 |  4449 |
| Clear Cell Carcinoma                              |    154 |  4449 |
| Conventional Chondrosarcoma                       |     19 |  4449 |
| Dedifferentiated Chondrosarcoma                   |      4 |  4449 |
| Dedifferentiated Liposarcoma                      |     12 |  4449 |
| Diffuse Astrocytoma                               |      9 |  4449 |
| Diffuse Large B-Cell Lymphoma                     |      6 |  4449 |
| Ductal                                            |    483 |  4449 |
| Embryonal Carcinoma                               |      1 |  4449 |
| Endometrioid Carcinoma                            |    112 |  4449 |
| Extraskeletal Chondrosarcoma                      |      3 |  4449 |
| Gastric Adenocarcinoma                            |     10 |  4449 |
| Germ Cell Tumour                                  |      2 |  4449 |
| Glioblastoma                                      |     66 |  4449 |
| Granulosa Cell Tumour                             |      2 |  4449 |
| Haematological Malignancy Unclassified            |      1 |  4449 |
| Hepatocellular Carcinoma                          |      7 |  4449 |
| High Grade Lymphoma Nos                           |      3 |  4449 |
| High Grade Serous Carcinoma                       |     84 |  4449 |
| Hpv Negative Oropharyngeal Cancer                 |     27 |  4449 |
| Hpv Positive Oropharyngeal Cancer                 |      5 |  4449 |
| Large Cell                                        |      7 |  4449 |
| Leiomyosarcoma From All Sites                     |     36 |  4449 |
| Lobular                                           |    100 |  4449 |
| Low Grade Fibromyxoid Sarcoma                     |      3 |  4449 |
| Low Grade Serous Adenocarcinoma                   |      8 |  4449 |
| Medullary                                         |      2 |  4449 |
| Mesothelioma                                      |      7 |  4449 |
| Mixed Tumour Type                                 |     22 |  4449 |
| Mucinous Carcinoma                                |     17 |  4449 |
| Multiple Myeloma                                  |     17 |  4449 |
| Myelodysplastic Syndrome (High Risk)              |      4 |  4449 |
| Myleoproliferative Neoplasms                      |     14 |  4449 |
| Myxofibrosarcoma                                  |     35 |  4449 |
| Myxoid Liposarcoma                                |      3 |  4449 |
| Myxoinflammatory Fibroblastic Sarcoma             |      1 |  4449 |
| Neuroblastoma (Nos)                               |      3 |  4449 |
| Neuroendocrine                                    |      6 |  4449 |
| Neuroendocrine Carcinoma                          |     19 |  4449 |
| Nodular                                           |     18 |  4449 |
| Non Specified Renal Carcinoma                     |     30 |  4449 |
| Non-Hodgkins B Cell Lymphoma Low / Moderate Grade |      9 |  4449 |
| Not Available                                     |    120 |  4449 |
| Oligodendroglioma                                 |      5 |  4449 |
| Oncocytic                                         |     10 |  4449 |
| Other                                             |    350 |  4449 |
| Paediatric Malignant Glioma                       |      2 |  4449 |
| Pancreatic Adenocarcinoma                         |     31 |  4449 |
| Pancreatic Neuroendocrine Carcinoma               |      4 |  4449 |
| Papillary                                         |      3 |  4449 |
| Papillary Type 1                                  |     19 |  4449 |
| Papillary Type 2                                  |      6 |  4449 |
| Pituitary Carcinoma                               |      2 |  4449 |
| Pleomorphic Sarcoma                               |     21 |  4449 |
| Primary Conventional Osteosarcoma                 |      8 |  4449 |
| Rhabdomyosarcoma                                  |      1 |  4449 |
| Sarcoma Nos                                       |      4 |  4449 |
| Serous Carcinoma                                  |     22 |  4449 |
| Small Cell                                        |     11 |  4449 |
| Squamous Cell                                     |    125 |  4449 |
| Superficial Spreading                             |      7 |  4449 |
| Synovial Sarcoma - Monophasic And Biphasic        |     16 |  4449 |
| T-Cell Lymphoma                                   |      2 |  4449 |
| Tubular / Cribform                                |      4 |  4449 |
| Unknown                                           |   1035 |  4449 |
| Urothelial (In Situ)                              |     14 |  4449 |
| Urothelial Carcinoma                              |     12 |  4449 |
| Uveal Melanoma                                    |      2 |  4449 |

We can get number of total participants after applying a filter.

``` r
# filter participants
total_participants_with_filter <- cb_filter_participants(cohort = my_cohort, 
                                                filter_id = my_phenotypic_filter$id)
 
total_participants_with_filter
#> $total
#> [1] 44667
#> 
#> $count
#> [1] 0
```

### Apply and Save a filter

Save a filter into the database.

For this a `filter_query` is required.

`filter_query` is a list of different **phenotypic filter** quires.

Steps to find phenotypic filters -

  - Use `cb_search_phenotypic_filters()` to find a filter based on a
    term.
  - At this time you will be having phenotypic filter id of your choice.
  - Check the available filter values/range using
    `cb_get_filter_statistics()`
  - Now use this information to make your `filter_query`

There are two possible type of `filter_query`

  - Range based
  - Value based

**Range based**

For filter\_id = 22

``` r
# A tibble: 1,880 x 3
   `_id`      number total
   <chr>       <int> <int>
 1 1938-12-25      1 44660
 2 1998-07-07      1 44660
 3 2000-12-04      1 44660
 4 2003-12-24      1 44660
 5 2004-07-20      1 44660
 6 2004-10-21      1 44660
 7 2004-11-01      1 44660
 8 2004-11-03      1 44660
 9 2005-01-07      1 44660
10 2005-02-27      1 44660
# … with 1,870 more rows
```

To make a range based query - `filter_query = list("22" = list("from" =
"2015-05-13", "to" = "2016-04-29")`

Here `"22"` is the filter\_id and you need to provide the range as a
list with `from` and `to`.

**Value based**

For filter\_id = 50

``` r
# A tibble: 25 x 3
   `_id`                             number total
   <chr>                              <int> <int>
 1 Daughter                             135 19187
 2 Father                              6864 19187
 3 First Cousin Once Removed             11 19187
 4 Full Sibling                        1876 19187
 5 Half Sibling with a shared Father      4 19187
 6 Half Sibling with a shared Mother     79 19187
 7 Maternal Aunt                         49 19187
 8 Maternal Cousin Brother               12 19187
 9 Maternal Cousin Sister                34 19187
10 Maternal Grandfather                  36 19187
11 Maternal Grandmother                  68 19187
12 Maternal Uncle                        27 19187
13 Mother                              9649 19187
14 Other                                114 19187
```

To make a value based query \<- `filter_query = list("50" = c("Father",
"Mother"))`

Here `"50"` is filter\_id and `c("Father", "Mother")` is a vector of
values.

If you have multiple `filter_query` you can combine them with separated
by a coma `,` inside the list. Such as `filter_query =
list(filter_query_1, filter_query_2)`

Check the bellow example for the complete function call.

``` r
cb_apply_filter(cohort = my_cohort,
                filter_query = list("22" = list("from" = "2015-05-13", "to" = "2016-04-29"),
                                    "50" = c("Father", "Mother")))
```

### Get sample filters plot

Get ggplots for all the applied phenotypic filters for a cohort.

As this based on ggplot objects, this can be customised further.

``` r
plot_list <- cb_plot_filters(cohort = my_cohort)
#> Warning: Ignoring unknown parameters: binwidth, bins, pad
library(ggpubr)
#> Loading required package: ggplot2
ggpubr::ggarrange(plotlist = plot_list)
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

Individual plots

``` r
plot_list[[1]]
```

<img src="man/figures/README-unnamed-chunk-16-1.png" width="100%" />

``` r
plot_list[[2]]
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

Covert ggplot objects to plotly elements (just for demonstration
purpose, in markdown plotly don’t support.)

``` r
p1 <- plotly::ggplotly(plot_list$filter_id_34)
p1
```

``` r
p2 <- plotly::ggplotly(plot_list$filter_id_2345)
p2
```
