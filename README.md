# `rk.dplyr`: An RKWard Plugin for `dplyr` Table Combinations

[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This repository contains the source code for `rk.dplyr`, an RKWard plugin package that provides a user-friendly graphical interface for the powerful data combination and manipulation functions in the R package `dplyr`.

This package simplifies common data wrangling tasks by providing clear dialogs for four categories of operations, each requiring two data frames as input.

## Features

The plugin provides a clean three-column interface for all operations, guiding the user to select their two input data frames (`x` and `y`) and then configure the specific operation.

### 1. Combine by Binding
Performs basic stacking or side-by-side combination of two data frames.
-   **Bind Rows (`bind_rows`):** Stacks two data frames on top of each other. Columns are matched by name.
-   **Bind Columns (`bind_cols`):** Pastes two data frames together side-by-side.

### 2. Mutating Joins
Combines variables from two tables, matching rows based on one or more key columns.
-   **Left Join (`left_join`):** Keeps all rows from `x`, adding matching columns from `y`.
-   **Right Join (`right_join`):** Keeps all rows from `y`, adding matching columns from `x`.
-   **Inner Join (`inner_join`):** Keeps only the rows that have matching keys in *both* `x` and `y`.
-   **Full Join (`full_join`):** Keeps all rows from *both* `x` and `y`.

### 3. Filtering Joins
Filters rows from one table based on whether they have a match in another table, without adding any columns.
-   **Semi Join (`semi_join`):** Keeps all rows in `x` that have a match in `y`.
-   **Anti Join (`anti_join`):** Keeps all rows in `x` that *do not* have a match in `y`.

### 4. Set Operations
Treats rows as elements of a set. These operations require that the two data frames have identical column names.
-   **Intersect (`intersect`):** Returns only the rows that are present in both `x` and `y`.
-   **Set Difference (`setdiff`):** Returns the rows that are in `x` but not in `y`.
-   **Union (`union`):** Returns the unique rows from both `x` and `y`.

## Installation

To install this plugin, you need to have RKWard and the `remotes` package installed.

1.  Install the `remotes` package if you haven't already:
    ```R
    install.packages("remotes")
    ```

2.  Install the plugin directly from GitHub:
    ```R
    remotes::install_github("AlfCano/rk.dplyr")
    ```

3.  Restart RKWard to ensure the new menu items appear correctly.

## Usage

After installation, the plugins will be available in the RKWard menu under a consolidated submenu:

**Data -> Combine Data Tables (dplyr)**

-   Combine by Binding
-   Mutating Joins
-   Filtering Joins
-   Set Operations

Select the desired operation to open its dialog window.

## Dependencies

-   **RKWard:** Version 0.7.0 or greater.
-   **R:** Version 3.5.0 or greater.
-   **R Package:** `dplyr` (version 1.0.0 or greater), which will be installed from CRAN if not already present.

## License

This plugin package is licensed under the GPL (>= 3).
