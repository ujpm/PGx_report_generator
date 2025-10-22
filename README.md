# PGx Clinical Decision Support Tool

A pharmacogenomics (PGx) tool in R to provide drug recommendations based on genetic data.
## Project Status (In Progress)

This tool is currently in development. The core analysis engine is complete, and the web interface is the next step.

* **[✅] Phase 1:** Built the knowledge database (`data/pgx_kb.csv`) from CPIC guidelines.
* **[✅] Phase 2:** Wrote the R function (`scripts/pgx_engine.R`) to query the database.
* **[TODO] Phase 3:** Build the R Shiny user interface.
* **[TODO] Phase 4:** Polish and deploy the app.

## Current Functionality

The core engine can be loaded and tested directly in an R console.

1.  Clone this repository.
2.  Open the `.Rproj` file in RStudio or Posit Cloud.
3.  Install packages: `install.packages(c("readr", "dplyr", "stringr"))`
4.  Load the engine: `source("scripts/pgx_engine.R")`
5.  Test the function:
    ```R
    get_pgx_recommendation("CYP2C19", "*2/*2")
    ```

## Technology Stack

* **Analysis Engine:** R
* **Core Packages:** `readr`, `dplyr`, `stringr`
* **(Future):** `shiny`, `DT` for the web UI.