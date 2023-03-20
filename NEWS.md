# cloudos 0.4.0

* Documentation is updated
* For R version 3.4 support is removed

# cloudos 0.3.0

* Overhaul of the cohort query system. Query syntax is now much easier to use.
* Neater and more consistent tabular outputs for many functions.
* Split cb_apply_query into seperate functions for applying query (cb_apply_query) and setting columns (cb_set_columns).
* Better error messaging.
* Many bug fixes.

# cloudos 0.2.0

* Adds compatibility for cohort browser v2 API.
* Renames a number of functions with more consistent naming scheme. #58
* Minor package structure adjustments to conform to CRAN guidelines.

# cloudos 0.1.0 (v0.01)

* Phenotypic plot improvement and bug fixes #9
* Adds phenotypic filter discovery, query and apply. `cb_search_phenotypic_filters()`, `cb_filter_metadata()`, `cb_get_filter_statistics()`, `cb_apply_filter()` and also support for multiple phenotypic filter apply. #13
* Improvements to API error error handling and message though `httr::stop_with_status()` #21
* Adds functionality to get participants table based on saved columns instead of default columns. #25
* Adds filtering for genotypic filtering #26
* Refactor of cloudos config access #27

# cloudos 0.0.0.9000

* First complete set of cb_* functions for Cohort Browser endpoints
