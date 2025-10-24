#
# PGx Clinical Decision Support Tool - User Interface (ui.R)
#

# Load required libraries
library(shiny)
library(shinythemes)
library(DT)

# Load gene choices from the CSV
gene_list <- readr::read_csv("pgx_kb.csv")$gene
gene_choices <- unique(gene_list)

# Define the User Interface (UI)
ui <- navbarPage(
  # 1. Application Title (now in the nav bar)
  title = "PGx Clinical Decision Support Tool",
  
  # 2. Use the "flatly" theme
  theme = shinytheme("flatly"), 
  
  # -----------------------------------------------------------------
  # TAB 1: THE PGx TOOL
  # -----------------------------------------------------------------
  tabPanel("PGx Recommendation Tool",
           sidebarLayout(
             
             # 3. Sidebar Panel (for inputs)
             sidebarPanel(
               width = 4, 
               
               helpText("Select a gene and the patient's genotype to see the clinical recommendation based on CPIC guidelines."),
               
               # Input 1: Select Gene
               selectInput(
                 inputId = "selected_gene",
                 label = "1. Select Gene:",
                 choices = gene_choices,
                 selected = "CYP2C19"
               ),
               
               # Input 2: Select Genotype (Dynamic)
               uiOutput(outputId = "genotype_selector_ui"),
               
               br(), 
               
               # Input 3: Action Button
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
  # TAB 2: DEVELOPER NOTE
  # -----------------------------------------------------------------
  tabPanel("About / Developer Note",
           fluidRow(
             column(
               width = 8,
               offset = 2, 
               
               h2("About This Project"),
               p("This tool is a pharmacogenomics (PGx) clinical decision support tool that provides drug recommendations based on a patient's genetic data."),
               
               h3("Project Goal"),
               p("This tool was created as a portfolio project for the SFD Fellowship application. The goal is to demonstrate skills in R, R Shiny, and the application of bioinformatics principles to solve a real-world clinical problem."),
               p("The recommendation logic is based on publicly available, evidence-based guidelines from the Clinical Pharmacogenetics Implementation Consortium (CPIC) and PharmGKB."),
               
               h3("Developer Note (v1.0)"),
               p("This first version of the tool is a functional prototype. The key simplification is the use of dropdown menus for star-allele genotypes rather than parsing raw genetic data (e.g., VCF files)."),
               p("Future development (v2.0) will focus on:"),
               tags$ul(
                 tags$li("Parsing user-uploaded VCF files."),
                 tags$li("Generating downloadable PDF reports."),
                 tags$li("Expanding the knowledge base to more gene-drug pairs.")
               ),
               
               h3("Contact"),
               p("Developed by [Your Name]. You can find the full source code and documentation on GitHub."),
               tags$a(href = "https://github.com/ujpm/PGx_report_generator", 
                      "View Project on GitHub", 
                      target = "_blank",
                      class = "btn btn-default")
             )
           )
  ), # End of tabPanel 2
  
  
  # -----------------------------------------------------------------
  # NEW: FOOTER SECTION
  # -----------------------------------------------------------------
  footer = tagList(
    hr(), # Adds a horizontal line
    p(
      "Developed by [Your Name] for the SFD Fellowship Application",
      style = "text-align: center; color: #777;"
    ),
    p(
      tags$a(href = "https://github.com/ujpm/PGx_report_generator", 
             "View Project on GitHub", 
             target = "_blank"),
      style = "text-align: center;"
    )
  )
  # -----------------------------------------------------------------
  
) # End of navbarPage