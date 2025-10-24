#
# PGx Clinical Decision Support Tool - User Interface (ui.R)
#

# Load required libraries for the UI
library(shiny)
library(DT) # We will use this to render nice tables

# Get the list of unique genes from our knowledge base
# This is a bit advanced, but it makes our app "smarter"
# It reads the CSV file *once* to populate the dropdown.
gene_list <- readr::read_csv("pgx_kb.csv")$gene
gene_choices <- unique(gene_list)

# Define the User Interface (UI)
ui <- fluidPage(
  
  # 1. Application Title
  titlePanel("PGx Clinical Decision Support Tool"),
  
  # 2. Layout
  sidebarLayout(
    
    # 3. Sidebar Panel (for inputs)
    sidebarPanel(
      width = 4, # Adjust the width of the sidebar
      
      helpText("Select a gene and the patient's genotype to see the clinical recommendation based on CPIC guidelines."),
      
      # Input 1: Select Gene
      selectInput(
        inputId = "selected_gene",
        label = "1. Select Gene:",
        # Use the gene list we just loaded
        choices = gene_choices,
        selected = "CYP2C19" # Default to a common one
      ),
      
      # Input 2: Select Genotype (This is a dynamic UI)
      # This dropdown will be built in the server.R file,
      # based on the gene selected above.
      uiOutput(outputId = "genotype_selector_ui"),
      
      br(), # Add a little space
      
      # Input 3: Action Button
      actionButton(
        inputId = "run_query_button",
        label = "Get Recommendation",
        icon = icon("pills") # Add a nice icon
      )
    ),
    
    # 4. Main Panel (for outputs)
    mainPanel(
      width = 8, # Adjust the width of the main panel
      
      # This is where all our results will be displayed.
      # It will be built in the server.R file.
      uiOutput(outputId = "recommendation_box_ui")
    )
  )
)
