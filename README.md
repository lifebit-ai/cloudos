
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cloudos

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/lifebit-ai/cloudos/workflows/R-CMD-check/badge.svg)](https://github.com/lifebit-ai/cloudos/actions)
<!-- badges: end -->

The ‘CloudOS’ client library for R makes it easy to interact with
CloudOS <https://cloudos.lifebit.ai/> in the R environment for analysis.

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

### Create a cohort

``` r
cloudos::create_cohort(base_url = cb_base_url,
              auth = my_auth,
              team_id = my_team_id,
              cohort_name = "Cohort-R",
              cohort_desc = "This cohort is for testing purpose, created from R.")
#> Cohort named Cohort-R created successfully. Bellow are the details
#>                      details                                              
#> phenotypeFilters     ""                                                   
#> _id                  "5f3d271d2890e2285ef3afff"                           
#> name                 "Cohort-R"                                           
#> description          "This cohort is for testing purpose, created from R."
#> team                 "5f046bf6c132dd15fdd1a525"                           
#> owner                "5f046be1c132dd15fdd1a51e"                           
#> numberOfParticipants 644686                                               
#> numberOfFilters      0                                                    
#> createdAt            "2020-08-19T13:20:29.096Z"                           
#> updatedAt            "2020-08-19T13:20:29.096Z"                           
#> __v                  0
```

### List Cohorts

List available cohorts in a workspace.

``` r
cohorts <- cloudos::list_cohorts(base_url = cb_base_url,
                        auth = my_auth,
                        team_id = my_team_id)
#> Total number of cohorts found-28. But here is 10. For more, change 'page_number' and 'page_size'
kableExtra::kable(cohorts)
```

<table>

<thead>

<tr>

<th style="text-align:left;">

id

</th>

<th style="text-align:left;">

name

</th>

<th style="text-align:left;">

description

</th>

<th style="text-align:right;">

number\_of\_participants

</th>

<th style="text-align:right;">

number\_of\_filters

</th>

<th style="text-align:left;">

created\_at

</th>

<th style="text-align:left;">

updated\_at

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

5f2ab881b695de55d93024a7

</td>

<td style="text-align:left;">

test

</td>

<td style="text-align:left;">

test-desc

</td>

<td style="text-align:right;">

414326

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:left;">

2020-08-05T13:47:45.826Z

</td>

<td style="text-align:left;">

2020-08-14T10:48:37.284Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f327e8c1733200222dc3e8c

</td>

<td style="text-align:left;">

test\_2

</td>

<td style="text-align:left;">

some random

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-11T11:18:36.703Z

</td>

<td style="text-align:left;">

2020-08-11T11:18:36.703Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f32c2147ca1902e9c5ba45d

</td>

<td style="text-align:left;">

test-R

</td>

<td style="text-align:left;">

created from R lib

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-11T16:06:44.205Z

</td>

<td style="text-align:left;">

2020-08-11T16:06:44.205Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f32e1687ca1902e9c5ba467

</td>

<td style="text-align:left;">

Test cohort

</td>

<td style="text-align:left;">

This cohort is for testing purpose.

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-11T18:20:24.356Z

</td>

<td style="text-align:left;">

2020-08-11T18:20:24.356Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f32f1407ca1902e9c5ba46e

</td>

<td style="text-align:left;">

Cohort-R

</td>

<td style="text-align:left;">

This cohort is for testing purpose, created from R.

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-11T19:28:00.606Z

</td>

<td style="text-align:left;">

2020-08-11T19:28:00.606Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f351e89cb536f664c1e0a47

</td>

<td style="text-align:left;">

test-new

</td>

<td style="text-align:left;">

test-new-desc

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-13T11:05:45.111Z

</td>

<td style="text-align:left;">

2020-08-13T11:05:45.111Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f351ec1305af25011d57b25

</td>

<td style="text-align:left;">

test-new-new

</td>

<td style="text-align:left;">

New-new

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-13T11:06:41.160Z

</td>

<td style="text-align:left;">

2020-08-13T11:06:41.160Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f351f15305af25011d57b26

</td>

<td style="text-align:left;">

test-new-new

</td>

<td style="text-align:left;">

New-new

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-13T11:08:05.512Z

</td>

<td style="text-align:left;">

2020-08-13T11:08:05.512Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f352103cb536f664c1e0a4a

</td>

<td style="text-align:left;">

random test

</td>

<td style="text-align:left;">

random descriptiom

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-13T11:16:19.086Z

</td>

<td style="text-align:left;">

2020-08-13T11:16:19.086Z

</td>

</tr>

<tr>

<td style="text-align:left;">

5f3521c5b12d49672a616b88

</td>

<td style="text-align:left;">

Cohort-R

</td>

<td style="text-align:left;">

This cohort is for testing purpose, created from R.

</td>

<td style="text-align:right;">

600000

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:left;">

2020-08-13T11:19:33.094Z

</td>

<td style="text-align:left;">

2020-08-13T11:19:33.094Z

</td>

</tr>

</tbody>

</table>

### Extract participants

Create a RAW data string. This usually generates after selecting
participants on UI. (more information will be added how to create this
in R)

``` r
new_raw_data <- '{"columns":[{"id":34,"instance":0,"array":{"type":"exact","value":0}},{"id":31,"instance":0,"array":{"type":"exact","value":0}},{"id":52,"instance":0,"array":{"type":"exact","value":0}},{"id":5984,"instance":0,"array":{"type":"avg"}},{"id":5984,"instance":0,"array":{"type":"min"}},{"id":5984,"instance":0,"array":{"type":"max"}},{"id":20001,"instance":0,"array":{"type":"exact","value":0}}],"ids":["5f185b92bf92ed4d3be9637d","5edbdd689d700db709af0c2f","5f185b91bf92ed4d3be9587e","5f185b91bf92ed4d3be95984","5edbdd689d700db709af0c3e","5edbdd689d700db709af0c2b","5edbdd689d700db709af0c2d","5f185b93bf92ed4d3be982e9","5edbdd689d700db709af0c2a","5edbdd689d700db709af0c4d"],"type":"csv","base_url":"http://cohort-browser-766010452.eu-west-1.elb.amazonaws.com"}'
```

Using this above raw data lets extract selected participants.

``` r
df <- cloudos::extract_participants(base_url= cb_base_url, 
                      auth = my_auth,
                      raw_data = new_raw_data)


kableExtra::kable(df)
```

<table>

<thead>

<tr>

<th style="text-align:right;">

i

</th>

<th style="text-align:right;">

ECG..load.0.0

</th>

<th style="text-align:right;">

ECG..load.0.1

</th>

<th style="text-align:right;">

ECG..load.0.2

</th>

<th style="text-align:right;">

ECG..load.0.3

</th>

<th style="text-align:right;">

ECG..load.0.4

</th>

<th style="text-align:right;">

ECG..load.0.5

</th>

<th style="text-align:right;">

ECG..load.0.6

</th>

<th style="text-align:right;">

ECG..load.0.7

</th>

<th style="text-align:right;">

ECG..load.0.8

</th>

<th style="text-align:right;">

ECG..load.0.9

</th>

<th style="text-align:right;">

ECG..load.0.10

</th>

<th style="text-align:right;">

ECG..load.0.11

</th>

<th style="text-align:right;">

ECG..load.0.12

</th>

<th style="text-align:right;">

ECG..load.0.13

</th>

<th style="text-align:right;">

ECG..load.0.14

</th>

<th style="text-align:right;">

ECG..load.0.15

</th>

<th style="text-align:right;">

ECG..load.0.16

</th>

<th style="text-align:right;">

ECG..load.0.17

</th>

<th style="text-align:right;">

ECG..load.0.18

</th>

<th style="text-align:right;">

ECG..load.0.19

</th>

<th style="text-align:right;">

ECG..load.0.20

</th>

<th style="text-align:right;">

ECG..load.0.21

</th>

<th style="text-align:right;">

ECG..load.0.22

</th>

<th style="text-align:right;">

ECG..load.0.23

</th>

<th style="text-align:right;">

ECG..load.0.24

</th>

<th style="text-align:right;">

ECG..load.0.25

</th>

<th style="text-align:right;">

ECG..load.0.26

</th>

<th style="text-align:right;">

ECG..load.0.27

</th>

<th style="text-align:right;">

ECG..load.0.28

</th>

<th style="text-align:right;">

ECG..load.0.29

</th>

<th style="text-align:right;">

ECG..load.0.30

</th>

<th style="text-align:right;">

ECG..load.0.31

</th>

<th style="text-align:right;">

ECG..load.0.32

</th>

<th style="text-align:right;">

ECG..load.0.33

</th>

<th style="text-align:right;">

ECG..load.0.34

</th>

<th style="text-align:right;">

ECG..load.0.35

</th>

<th style="text-align:right;">

ECG..load.0.36

</th>

<th style="text-align:right;">

ECG..load.0.37

</th>

<th style="text-align:right;">

ECG..load.0.38

</th>

<th style="text-align:right;">

ECG..load.0.39

</th>

<th style="text-align:right;">

ECG..load.0.40

</th>

<th style="text-align:right;">

ECG..load.0.41

</th>

<th style="text-align:right;">

ECG..load.0.42

</th>

<th style="text-align:right;">

ECG..load.0.43

</th>

<th style="text-align:right;">

ECG..load.0.44

</th>

<th style="text-align:right;">

ECG..load.0.45

</th>

<th style="text-align:right;">

ECG..load.0.46

</th>

<th style="text-align:right;">

ECG..load.0.47

</th>

<th style="text-align:right;">

ECG..load.0.48

</th>

<th style="text-align:right;">

ECG..load.0.49

</th>

<th style="text-align:right;">

ECG..load.0.50

</th>

<th style="text-align:right;">

ECG..load.0.51

</th>

<th style="text-align:right;">

ECG..load.0.52

</th>

<th style="text-align:right;">

ECG..load.0.53

</th>

<th style="text-align:right;">

ECG..load.0.54

</th>

<th style="text-align:right;">

ECG..load.0.55

</th>

<th style="text-align:right;">

ECG..load.0.56

</th>

<th style="text-align:right;">

ECG..load.0.57

</th>

<th style="text-align:right;">

ECG..load.0.58

</th>

<th style="text-align:right;">

ECG..load.0.59

</th>

<th style="text-align:right;">

ECG..load.0.60

</th>

<th style="text-align:right;">

ECG..load.0.61

</th>

<th style="text-align:right;">

ECG..load.0.62

</th>

<th style="text-align:right;">

ECG..load.0.63

</th>

<th style="text-align:right;">

ECG..load.0.64

</th>

<th style="text-align:right;">

ECG..load.0.65

</th>

<th style="text-align:right;">

ECG..load.0.66

</th>

<th style="text-align:right;">

ECG..load.0.67

</th>

<th style="text-align:right;">

ECG..load.0.68

</th>

<th style="text-align:right;">

ECG..load.0.69

</th>

<th style="text-align:right;">

ECG..load.0.70

</th>

<th style="text-align:right;">

ECG..load.0.71

</th>

<th style="text-align:right;">

ECG..load.0.72

</th>

<th style="text-align:right;">

ECG..load.0.73

</th>

<th style="text-align:right;">

ECG..load.0.74

</th>

<th style="text-align:right;">

ECG..load.0.75

</th>

<th style="text-align:right;">

ECG..load.0.76

</th>

<th style="text-align:right;">

ECG..load.0.77

</th>

<th style="text-align:right;">

ECG..load.0.78

</th>

<th style="text-align:right;">

ECG..load.0.79

</th>

<th style="text-align:right;">

ECG..load.0.80

</th>

<th style="text-align:right;">

ECG..load.0.81

</th>

<th style="text-align:right;">

ECG..load.0.82

</th>

<th style="text-align:right;">

ECG..load.0.83

</th>

<th style="text-align:right;">

ECG..load.0.84

</th>

<th style="text-align:right;">

ECG..load.0.85

</th>

<th style="text-align:right;">

ECG..load.0.86

</th>

<th style="text-align:right;">

ECG..load.0.87

</th>

<th style="text-align:right;">

ECG..load.0.88

</th>

<th style="text-align:right;">

ECG..load.0.89

</th>

<th style="text-align:right;">

ECG..load.0.90

</th>

<th style="text-align:right;">

ECG..load.0.91

</th>

<th style="text-align:right;">

ECG..load.0.92

</th>

<th style="text-align:right;">

ECG..load.0.93

</th>

<th style="text-align:right;">

ECG..load.0.94

</th>

<th style="text-align:right;">

ECG..load.0.95

</th>

<th style="text-align:right;">

ECG..load.0.96

</th>

<th style="text-align:right;">

ECG..load.0.97

</th>

<th style="text-align:right;">

ECG..load.0.98

</th>

<th style="text-align:right;">

ECG..load.0.99

</th>

<th style="text-align:right;">

ECG..load.0.100

</th>

<th style="text-align:right;">

ECG..load.0.101

</th>

<th style="text-align:right;">

ECG..load.0.102

</th>

<th style="text-align:right;">

ECG..load.0.103

</th>

<th style="text-align:right;">

ECG..load.0.104

</th>

<th style="text-align:right;">

ECG..load.0.105

</th>

<th style="text-align:right;">

ECG..load.0.106

</th>

<th style="text-align:right;">

ECG..load.0.107

</th>

<th style="text-align:right;">

ECG..load.0.108

</th>

<th style="text-align:right;">

ECG..load.0.109

</th>

<th style="text-align:right;">

ECG..load.0.110

</th>

<th style="text-align:right;">

ECG..load.0.111

</th>

<th style="text-align:right;">

ECG..load.0.112

</th>

<th style="text-align:right;">

ECG..load.0.113

</th>

<th style="text-align:left;">

Cancer.code..self.reported.0.0

</th>

<th style="text-align:left;">

Sex

</th>

<th style="text-align:right;">

Year.of.birth

</th>

<th style="text-align:left;">

Month.of.birth

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:right;">

1000002

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

</tr>

<tr>

<td style="text-align:right;">

1000016

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

245

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

93

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

64

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

87

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

88

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

140

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

70

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

104

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

104

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

132

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

42

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

78

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:left;">

cervical cancer

</td>

<td style="text-align:left;">

Male

</td>

<td style="text-align:right;">

1954

</td>

<td style="text-align:left;">

September

</td>

</tr>

<tr>

<td style="text-align:right;">

1000020

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

</tr>

<tr>

<td style="text-align:right;">

1000035

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

</tr>

<tr>

<td style="text-align:right;">

1000048

</td>

<td style="text-align:right;">

109

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

87

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

67

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

93

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

72

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

32

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

109

</td>

<td style="text-align:right;">

195

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

31

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

78

</td>

<td style="text-align:right;">

37

</td>

<td style="text-align:right;">

7

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:right;">

93

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

90

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

195

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

69

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

103

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

81

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

56

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

56

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

116

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

72

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

68

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:left;">

chronic myeloid

</td>

<td style="text-align:left;">

Female

</td>

<td style="text-align:right;">

1950

</td>

<td style="text-align:left;">

January

</td>

</tr>

<tr>

<td style="text-align:right;">

1000057

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

67

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

88

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

195

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

132

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

90

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

98

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

65

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

32

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

71

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

245

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

70

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

103

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

93

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

65

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

87

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

67

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

103

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

8

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

109

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

78

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:left;">

metastatic cancer (unknown primary)

</td>

<td style="text-align:left;">

Female

</td>

<td style="text-align:right;">

1942

</td>

<td style="text-align:left;">

February

</td>

</tr>

<tr>

<td style="text-align:right;">

1000059

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

245

</td>

<td style="text-align:right;">

90

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

132

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

95

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

140

</td>

<td style="text-align:right;">

22

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

68

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

80

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

195

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

65

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

61

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

81

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

53

</td>

<td style="text-align:right;">

93

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

77

</td>

<td style="text-align:right;">

84

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

32

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

61

</td>

<td style="text-align:right;">

90

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

140

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

245

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

56

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

61

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:right;">

61

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

69

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

99

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

61

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:left;">

uterine/endometrial cancer

</td>

<td style="text-align:left;">

Female

</td>

<td style="text-align:right;">

1964

</td>

<td style="text-align:left;">

December

</td>

</tr>

<tr>

<td style="text-align:right;">

1000061

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

<td style="text-align:left;">

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

</td>

</tr>

<tr>

<td style="text-align:right;">

1000063

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

130

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

59

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

46

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

9

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:right;">

20

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

69

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

17

</td>

<td style="text-align:right;">

54

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

58

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

85

</td>

<td style="text-align:right;">

84

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

67

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

43

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

270

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

73

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

109

</td>

<td style="text-align:right;">

2

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

26

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

36

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

16

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

127

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

112

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

30

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

47

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

55

</td>

<td style="text-align:right;">

57

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

97

</td>

<td style="text-align:right;">

40

</td>

<td style="text-align:right;">

84

</td>

<td style="text-align:right;">

56

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:left;">

chronic myeloid

</td>

<td style="text-align:left;">

Female

</td>

<td style="text-align:right;">

1944

</td>

<td style="text-align:left;">

April

</td>

</tr>

<tr>

<td style="text-align:right;">

1000068

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

94

</td>

<td style="text-align:right;">

15

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

88

</td>

<td style="text-align:right;">

195

</td>

<td style="text-align:right;">

136

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

52

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

50

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

29

</td>

<td style="text-align:right;">

115

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

121

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

120

</td>

<td style="text-align:right;">

124

</td>

<td style="text-align:right;">

95

</td>

<td style="text-align:right;">

0

</td>

<td style="text-align:right;">

88

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

60

</td>

<td style="text-align:right;">

86

</td>

<td style="text-align:right;">

84

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

28

</td>

<td style="text-align:right;">

108

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

21

</td>

<td style="text-align:right;">

19

</td>

<td style="text-align:right;">

24

</td>

<td style="text-align:right;">

95

</td>

<td style="text-align:right;">

27

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

103

</td>

<td style="text-align:right;">

76

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

33

</td>

<td style="text-align:right;">

14

</td>

<td style="text-align:right;">

105

</td>

<td style="text-align:right;">

11

</td>

<td style="text-align:right;">

72

</td>

<td style="text-align:right;">

91

</td>

<td style="text-align:right;">

51

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

103

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

96

</td>

<td style="text-align:right;">

87

</td>

<td style="text-align:right;">

34

</td>

<td style="text-align:right;">

39

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

1

</td>

<td style="text-align:right;">

81

</td>

<td style="text-align:right;">

4

</td>

<td style="text-align:right;">

83

</td>

<td style="text-align:right;">

118

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

75

</td>

<td style="text-align:right;">

100

</td>

<td style="text-align:right;">

109

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

84

</td>

<td style="text-align:right;">

49

</td>

<td style="text-align:right;">

102

</td>

<td style="text-align:right;">

63

</td>

<td style="text-align:right;">

35

</td>

<td style="text-align:right;">

82

</td>

<td style="text-align:right;">

23

</td>

<td style="text-align:right;">

92

</td>

<td style="text-align:right;">

79

</td>

<td style="text-align:right;">

38

</td>

<td style="text-align:right;">

128

</td>

<td style="text-align:right;">

25

</td>

<td style="text-align:right;">

81

</td>

<td style="text-align:right;">

45

</td>

<td style="text-align:right;">

42

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

18

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

44

</td>

<td style="text-align:right;">

110

</td>

<td style="text-align:right;">

5

</td>

<td style="text-align:right;">

62

</td>

<td style="text-align:right;">

87

</td>

<td style="text-align:right;">

13

</td>

<td style="text-align:right;">

74

</td>

<td style="text-align:right;">

41

</td>

<td style="text-align:right;">

66

</td>

<td style="text-align:right;">

106

</td>

<td style="text-align:right;">

48

</td>

<td style="text-align:left;">

bladder cancer

</td>

<td style="text-align:left;">

Female

</td>

<td style="text-align:right;">

1947

</td>

<td style="text-align:left;">

November

</td>

</tr>

</tbody>

</table>
