#
# PGx Clinical Decision Support Tool - Server Logic (server.R)
#

# 1. Load libraries
library(shiny)
library(dplyr)
library(stringr)
library(readr)
library(DT)

# 2. Source the Core Engine
source("pgx_engine.R")

# 3. Load the Knowledge Base
pgx_db <- read_csv("pgx_kb.csv")

# Define the Server logic
server <- function(input, output, session) {
  
  # -----------------------------------------------------------------
  # DYNAMIC UI: Populate Genotype Dropdown
  # -----------------------------------------------------------------
  output$genotype_selector_ui <- renderUI({
    genotype_choices <- pgx_db %>%
      filter(gene == input$selected_gene) %>%
      pull(genotype) 
    
    selectInput(
      inputId = "selected_genotype",
      label = "2. Select Genotype:",
      choices = unique(genotype_choices)
    )
  })
  
  # -----------------------------------------------------------------
  # REACTIVE: Run the Query
  # -----------------------------------------------------------------
  recommendation_data <- eventReactive(input$run_query_button, {
    showModal(modalDialog("Loading...", footer = NULL))
    
    result <- get_pgx_recommendation(
      gene_input = input$selected_gene,
      genotype_input = input$selected_genotype
    )
    
    removeModal()
    return(result)
  })
  
  # -----------------------------------------------------------------
  # DYNAMIC UI: Display Main Panel (Welcome OR Results)
  # -----------------------------------------------------------------
  
  # This is the new logic for the main panel
  output$main_panel_content_ui <- renderUI({
    
    # Check if the button has been clicked yet.
    # input$run_query_button starts at 0.
    if (input$run_query_button == 0) {
      # --- If button not clicked, show Welcome Message ---
      tagList(
        h3("Welcome to the PGx Recommendation Tool"),
        p("This tool helps you find clinical drug recommendations based on a patient's genotype."),
        tags$ol(
          tags$li("Select a gene (e.g., CYP2C19) from the sidebar."),
          tags$li("Select the corresponding genotype (e.g., *2/*2)."),
          tags$li("Click 'Get Recommendation' to see the results.")
        ),
        hr(),
        p("Use the 'About / Developer Note' tab to learn more about this project.")
      )
    } else {
      # --- If button HAS been clicked, show the results box ---
      # This is the same logic we had before.
      
      # We must 'isolate' this.
      # This tells Shiny to *only* run this code when 'recommendation_data()'
      # is updated, NOT when 'input$selected_gene' changes.
      result <- isolate(recommendation_data())
      
      if (nrow(result) == 0) {
        return(div(h3("No Recommendation Found"), p("Please check inputs.")))
      }
      
      # --- Helper for color-coding ---
      summary_text <- result$recommendation_summary
      summary_color <- "black"
      if (str_detect(summary_text, "Alternative Therapy|Avoid Use")) {
        summary_color <- "#D32F2F" # Red
      } else if (str_detect(summary_text, "Dose Reduction|Dose Limitation")) {
        summary_color <- "#F57C00" # Orange
      } else if (str_detect(summary_text, "Standard Dose")) {
        summary_color <- "#388E3C" # Green
      }
      
      # Build the HTML output box
      tagList(
        tags$style(HTML(paste0("
          .recommendation-box {
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            background-color: #f9f9f9;
          }
          .summary-header {
            color: ", summary_color, ";
            font-weight: bold;
            border-bottom: 2px solid ", summary_color, ";
            padding-bottom: 10px;
          }
        "))),
        
        div(
          class = "recommendation-box",
          h3(class = "summary-header", summary_text),
          h4("Phenotype:"),
          p(result$phenotype),
          h4("Drug(s):"),
          p(result$drug),
          h4("Recommendation Details:"),
          p(result$recommendation_details)
        )
      )
    }
  })
}