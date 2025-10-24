#
# PGx Clinical Decision Support Tool - User Interface (ui.R)
#

# Load required libraries
library(shiny)
library(shinythemes) # For the theme
library(DT)

# Load gene choices from the CSV
gene_list <- readr::read_csv("pgx_kb.csv")$gene
gene_choices <- unique(gene_list)

# Define the User Interface (UI)
ui <- navbarPage(
  # 1. Application Title
  title = "PGx Clinical Decision Support Tool",
  
  # 2. Use the "flatly" theme
  theme = shinytheme("flatly"), 
  
  # --- Add custom CSS for the footer ---
  header = tags$head(
    tags$style(HTML("
      .footer-content {
        padding: 20px;
        text-align: center;
        color: #777;
        font-size: 13px;
        border-top: 1px solid #e7e7e7;
        background-color: #f9f9f9;
        margin-top: 30px; /* Add space above the footer */
      }
      .footer-content strong {
        color: #D32F2F; /* Make the disclaimer stand out */
      }
    "))
  ),
  
  # -----------------------------------------------------------------
  # TAB 1: THE PGx TOOL
  # -----------------------------------------------------------------
  tabPanel("PGx Recommendation Tool",
           sidebarLayout(
             
             # 3. Sidebar Panel (for inputs)
             sidebarPanel(
               width = 4, 
               helpText("Select a gene and the patient's genotype to see the clinical recommendation based on CPIC guidelines."),
               
               selectInput(
                 inputId = "selected_gene",
                 label = "1. Select Gene:",
                 choices = gene_choices,
                 selected = "CYP2C19"
               ),
               
               uiOutput(outputId = "genotype_selector_ui"),
               
               br(), 
               
               actionButton(
                 inputId = "run_query_button",
                 label = "Get Recommendation",
                 icon = icon("pills"),
                 class = "btn-primary btn-lg" 
               )
             ),
             
             # 4. Main Panel (for outputs)
             mainPanel(
               width = 8, 
               uiOutput(outputId = "main_panel_content_ui")
             )
           )
  ), # End of tabPanel 1
  
  # -----------------------------------------------------------------
  # TAB 2: ABOUT THIS PROJECT (Renamed)
  # -----------------------------------------------------------------
  tabPanel("About This Project",
           fluidRow(
             column(
               width = 8,
               offset = 2, 
               
               h2("About This Project"),
               p("This tool is a pharmacogenomics (PGx) clinical decision support tool that provides drug recommendations based on a patient's genetic data."),
               
               # --- NEW GOAL SECTION ---
               h3("Project Goal"),
               p("The goal of this project is to create an intuitive tool that bridges the gap between complex genomic data and actionable clinical insights. By translating star-allele genotypes into clear, evidence-based recommendations, this tool aims to make personalized medicine more accessible and understandable."),
               
               h3("Development (v1.0)"),
               p("This first version of the tool is a functional prototype. The key simplification is the use of dropdown menus for star-allele genotypes rather than parsing raw genetic data (e.g., VCF files). The recommendation logic is based on publicly available guidelines from the Clinical Pharmacogenetics Implementation Consortium (CPIC) and PharmGKB."),
               
               h3("Future Work"),
               p("Future development (v2.0) will focus on:"),
               tags$ul(
                 tags$li("Parsing user-uploaded VCF files."),
                 tags$li("Generating downloadable PDF reports."),
                 tags$li("Expanding the knowledge base to more gene-drug pairs.")
               ),
               
               h3("Contact"),
               p("Developed by Jean Pierre. You can find the full source code and documentation on GitHub."),
               tags$a(href = "https://github.com/ujpm/PGx_report_generator", 
                      "View Project on GitHub", 
                      target = "_blank",
                      class = "btn btn-default")
             )
           )
  ), # End of tabPanel 2
  
  # -----------------------------------------------------------------
  # NEW FOOTER
  # -----------------------------------------------------------------
  footer = div(
    class = "footer-content",
    p(strong("Disclaimer:"), "This tool is for educational and research purposes only. It is not intended for clinical use or to replace professional medical advice."),
    p(
      "Developed by Jean Pierre | ",
      tags$a(href = "https://github.com/ujpm/PGx_report_generator", 
             "View Source on GitHub", 
             target = "_blank")
    )
  ) # End of footer
  
) # End of navbarPage