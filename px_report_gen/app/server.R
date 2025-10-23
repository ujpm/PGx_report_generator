#
# PGx Clinical Decision Support Tool - Server Logic (server.R)
#

# 1. Load all required libraries
library(shiny)
library(dplyr)
library(stringr)
library(readr)
library(DT)

# 2. Source the Core Engine
# We go "up" one directory to find the 'scripts' folder
source("../scripts/pgx_engine.R")

# 3. Load the Knowledge Base (again)
# This object is used by the server to populate the dropdowns
pgx_db <- read_csv("../data/pgx_kb.csv")

# Define the Server logic
server <- function(input, output, session) {
  
  # -----------------------------------------------------------------
  # DYNAMIC UI: Populate Genotype Dropdown
  # -----------------------------------------------------------------
  # This reactive block runs *every time* input$selected_gene changes
  
  output$genotype_selector_ui <- renderUI({
    
    # Filter the database for the selected gene
    genotype_choices <- pgx_db %>%
      filter(gene == input$selected_gene) %>%
      pull(genotype) # 'pull' gets just that one column as a vector
    
    # Create the new dropdown menu
    selectInput(
      inputId = "selected_genotype",
      label = "2. Select Genotype:",
      choices = unique(genotype_choices)
    )
  })
  
  # -----------------------------------------------------------------
  # REACTIVE: Run the Query
  # -----------------------------------------------------------------
  # 'eventReactive' waits for the button press
  # It then runs the code and stores the result in 'recommendation_data'
  
  recommendation_data <- eventReactive(input$run_query_button, {
    
    # Show a loading spinner (good for user experience)
    showModal(modalDialog("Loading...", footer = NULL))
    
    # Get the recommendation from our engine
    result <- get_pgx_recommendation(
      gene_input = input$selected_gene,
      genotype_input = input$selected_genotype
    )
    
    # Remove the loading spinner
    removeModal()
    
    # Return the result
    return(result)
  })
  
  # -----------------------------------------------------------------
  # DYNAMIC UI: Display the Recommendation Box
  # -----------------------------------------------------------------
  # This block waits for 'recommendation_data()' to have a result
  # and then builds the HTML to display it.
  
  output$recommendation_box_ui <- renderUI({
    
    # Get the data from our reactive variable
    result <- recommendation_data()
    
    # Case 1: No result found (should be rare)
    if (nrow(result) == 0) {
      return(
        div(
          h3("No Recommendation Found"),
          p("Please check the inputs or update the knowledge base.")
        )
      )
    }
    
    # Case 2: Result found!
    
    # --- Helper for color-coding ---
    summary_text <- result$recommendation_summary
    summary_color <- "black" # Default
    
    if (str_detect(summary_text, "Alternative Therapy|Avoid Use")) {
      summary_color <- "#D32F2F" # Red
    } else if (str_detect(summary_text, "Dose Reduction|Dose Limitation")) {
      summary_color <- "#F57C00" # Orange
    } else if (str_detect(summary_text, "Standard Dose")) {
      summary_color <- "#388E3C" # Green
    }
    # ---------------------------------
    
    # Build the HTML output box
    tagList(
      # We use 'tags' to write custom HTML
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
      
      # The main output box
      div(
        class = "recommendation-box",
        
        # 1. Summary
        h3(class = "summary-header", summary_text),
        
        # 2. Phenotype
        h4("Phenotype:"),
        p(result$phenotype),
        
        # 3. Drug
        h4("Drug(s):"),
        p(result$drug),
        
        # 4. Full Details
        h4("Recommendation Details:"),
        p(result$recommendation_details)
      )
    )
  })
  
}