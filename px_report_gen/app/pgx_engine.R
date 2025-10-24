# Load required libraries
library(readr)  # For reading the CSV
library(dplyr)  # For data manipulation (filtering)
library(stringr) # For handling strings

# -----------------------------------------------------------------
# Load the Knowledge Base
# -----------------------------------------------------------------
# We use "here::here()" to make the file path work
# whether we run the script from the console or from the Shiny app.
# If you don't have the 'here' package, run: install.packages("here")
#
# A simpler, but less robust way is to use a relative path:
# pgx_db <- read_csv("../data/pgx_kb.csv")
#
pgx_db <- read_csv("pgx_kb.csv")
# -----------------------------------------------------------------
# Define the Core Function
# -----------------------------------------------------------------
#' Get PGx Recommendation
#'
#' This function queries the knowledge base for a specific
#' gene and genotype and returns the clinical recommendation.
#'
#' @param gene_input The gene symbol (e.g., "CYP2C19")
#' @param genotype_input The star-allele genotype (e.g., "*1/*2")
#'
#' @return A data frame (tibble) row containing the matching
#'         recommendation, or an empty tibble if no match is found.

get_pgx_recommendation <- function(gene_input, genotype_input) {
  
  # Filter the database
  result <- pgx_db %>%
    filter(gene == gene_input & genotype == genotype_input)
  
  # Handle case-swapping for genotypes (e.g., *1/*2 vs *2/*1)
  # This makes our tool "smarter"
  if (nrow(result) == 0) {
    # Split the genotype, reverse, and re-join
    alleles <- str_split(genotype_input, "/", simplify = TRUE)
    if (ncol(alleles) == 2) {
      reversed_genotype <- paste(alleles[2], alleles[1], sep = "/")
      
      result <- pgx_db %>%
        filter(gene == gene_input & genotype == reversed_genotype)
    }
  }
  
  # Return the matching row
  return(result)
}

# -----------------------------------------------------------------
# Test the Function
# -----------------------------------------------------------------
# You can run this file directly in your console to test it.
#
# cat("\n--- TESTING FUNCTION ---\n")
#
# # Test 1: Clopidogrel Poor Metabolizer
# test1 <- get_pgx_recommendation("CYP2C19", "*2/*2")
# print(test1)
#
# # Test 2: Simvastatin Decreased Function (using the reversed logic)
# test2 <- get_pgx_recommendation("SLCO1B1", "*5/*1")
# print(test2)
#
# # Test 3: A test that should fail (no match)
# test3 <- get_pgx_recommendation("GENE_X", "*1/*1")
# print(test3)
#
# cat("\n--- TEST COMPLETE ---\n")