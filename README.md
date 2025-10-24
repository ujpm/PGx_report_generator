# PGx Clinical Decision Support Tool (v1.0)

[![R Version](https://img.shields.io/badge/R-4.5.1+-blue?logo=R)](https://www.r-project.org/)
[![Built with](https://img.shields.io/badge/Built_with-R_Shiny-blue?logo=rstudio)](https://shiny.posit.co/)
[![Status](https://img.shields.io/badge/Status-Deployed_(v1.0)-brightgreen)](https://6hmy1m-uwizeyimana0jean0pierre.shinyapps.io/PGx_report_generator/)

A pharmacogenomics (PGx) tool to provide clear, evidence-based drug recommendations from genetic data.

---

## 🚀 Live Application

**The deployed application is available here:**
**[https://6hmy1m-uwizeyimana0jean0pierre.shinyapps.io/PGx_report_generator/](https://6hmy1m-uwizeyimana0jean0pierre.shinyapps.io/PGx_report_generator/)**

---

## 🎯 Project Goal

The goal of this project is to create an intuitive tool that bridges the gap between complex genomic data and actionable clinical insights. By translating star-allele genotypes into clear, evidence-based recommendations, this tool aims to make personalized medicine more accessible and understandable.

## ✨ Key Features (v1.0)

* **Interactive UI:** A clean, tabbed interface built with R Shiny and `shinythemes`.
* **Evidence-Based:** Recommendation logic is manually curated from gold-standard **CPIC (Clinical Pharmacogenetics Implementation Consortium)** guidelines.
* **Dynamic Results:** The UI features dynamic dropdowns that update based on user selection.
* **Color-Coded Feedback:** Results are color-coded (red, orange, green) for immediate risk assessment.
* **Curated Gene-Drug Pairs:** The current knowledge base includes 4 high-impact pairs:
    * `CYP2C19` $\rightarrow$ clopidogrel
    * `TPMT` $\rightarrow$ azathioprine
    * `DPYD` $\rightarrow$ 5-fluorouracil
    * `SLCO1B1` $\rightarrow$ simvastatin

## ⚠️ Disclaimer

This tool is for **educational and research purposes only**. It is not intended for clinical use or to replace professional medical advice.

## 💻 How to Run Locally

1.  Clone this repository:
    ```bash
    git clone [https://github.com/ujpm/PGx_report_generator.git](https://github.com/ujpm/PGx_report_generator.git)
    cd PGx_report_generator
    ```
2.  Open the project in RStudio (by opening `project.Rproj`).
3.  Install the required packages:
    ```R
    # Install core packages
    install.packages(c("shiny", "dplyr", "readr", "stringr", "DT", "shinythemes"))
    
    # You may also need the 'rsconnect' package to deploy
    install.packages("rsconnect")
    ```
4.  Run the application from the R console:
    ```R
    # Make sure your working directory is the project root
    shiny::runApp("px_report_gen/app") 
    ```

## 🛠️ Project Status & Future Work

This project is under active development.

* **[✅] v1.0 (Complete):**
    * Built the core knowledge base (`pgx_kb.csv`).
    * Wrote the core query engine (`pgx_engine.R`).
    * Built the interactive Shiny UI (`ui.R`, `server.R`).
    * Deployed the app to ShinyApps.io.
* **[🚀] v2.0 (Planned):**
    * **VCF Parsing:** Allow users to upload a VCF file to automatically determine genotypes.
    * **Report Generation:** Add a "Download Report" button to generate a clinical-grade PDF.
    * **Expand Database:** Add more gene-drug pairs.