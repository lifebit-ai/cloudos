# Contributions

To contribute changes please checkout and branch from the `devel` branch.

Pull requests should be performed against the `devel` branch and will be squashed and merged into this branch after approval.

`master` branch sits at the latest tagged release and will be moved up to date with the devel branch once it is in a stable state for the next release.

# Instructions for creating a new release and submitting to CRAN

1. Create a pull request from `devel` into `master`.
2. Ensure version is updated in DESCRIPTION file and the description NEWS.md
3. Ensure all the CI tests are passing.
4. **DO NOT USE GITHUB GUI TO MERGE.** The github "rebase merge" option does not use fast-forward and so will cause the master branch and devel branch to have copies of the same commits instead of the actual same commits (this is problematic). 
5. Instead, using the CLI do the following:
    ```shell
    git merge origin/devel
    git push --force
    ```
    If things went correctly, this should have automatically closed the PR in github.
6. Checkout this new version of master branch and run `devtools::build()`.
7. [Draft a new release in github](https://github.com/lifebit-ai/cloudos/releases/new) and attach the `tar.gz` generated from `devtools::build()`.
8. Submit the new version to CRAN using `devtools::release()`.
