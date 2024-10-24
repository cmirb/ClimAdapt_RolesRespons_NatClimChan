# Main ---------------------------------------
# Script Name: figure_2_upset_plot 
# Purpose: Creates an upset plot featuring actor combinations and frequencies from the GAMI database
# Description ---------------------------------------
# Author: Charlotta Mirbach (c.mirbach@lmu.de)
# Created: Dec 2022
# Last Modified: Oct 2024
# Contributes to: Petzold et al., (2023): A global assessment of actors and their roles in climate change adaptation (Nature Climate Change)
# doi: https://doi.org/10.1038/s41558-023-01824-z

# Input: GAMI database, extracted all combinations of actors mentioned in literature
# Output: Visualization of actor combinations
# Dependencies: see packages below
# Usage: Please download the data from https://github.com/cmirb/WIA/blob/main/fig2_actors_upset_plot.csv and adjust file paths to your system.
# Issues: none
# Questions: please contact Charlotta Mirbach or Jan Petzold

# preamble
rm(list = ls(all = TRUE)) 
WD <-"path/to/your/directory"  
setwd(WD) 

library(UpSetR)
library(tidyr)

# load data
df <- read.csv('./fig2_actors_upset_plot.csv')

# clean col names
# Clean up column names
cleaned_colnames <- c(
  "Civil Society (Sub-National or Local)",
  "Individuals or Households",
  "Other",
  "Private Sector (SME)",
  "Government (National)",
  "Civil Society (International/Multinational/National)",
  "Government (Local)",
  "Private Sector (Corporations)",
  "Government (Sub-National)",
  "Academia",
  "International or Multinational Governance Institutions"
)

# assign cleaned column names to df
colnames(df) <- cleaned_colnames

# order df
ordered_data <- df %>%
  dplyr::select(
    `Individuals or Households`, 
    `Private Sector (SME)`, `Private Sector (Corporations)`,
    `Government (National)`, `Government (Sub-National)`, `Government (Local)`,
    `Civil Society (Sub-National or Local)`, `Civil Society (International/Multinational/National)`,
    `International or Multinational Governance Institutions`,
    Academia,
    Other
  )
df
ordered_data

# make upset simple plot
upset(ordered_data, 
      sets = c("Individuals or Households", "Private Sector (SME)", "Private Sector (Corporations)", 
               "Government (National)", "Government (Sub-National)", "Government (Local)",
               "Civil Society (Sub-National or Local)", "Civil Society (International/Multinational/National)",
               "International or Multinational Governance Institutions", "Academia", "Other"),
      order.by = "freq",
      sets.bar.color = "blue")

# make fancy upset plot
upset(ordered_data, 
      sets = c("Individuals or Households", "Civil Society (Sub-National or Local)",
               "Civil Society (International/Multinational/National)", "Government (Local)", 
               "Government (Sub-National)", "Government (National)",
               "International or Multinational Governance Institutions", "Private Sector (SME)",
               "Private Sector (Corporations)", "Academia", "Other"),
      order.by = "freq",       
      decreasing = TRUE,       
      keep.order = TRUE,       
      sets.bar.color = "darkgreen",  
      matrix.color = "black",        
      main.bar.color = "darkred",    
      point.size = 3,           
      line.size = 1,            
      text.scale = c(1.5, 1.5, 1.2, 1, 1.5, 1.5), 
      nsets = 7,                
      nintersects = 20,         
      show.numbers = "yes",     
      number.angles = 45,       
      set_size.angles = 0,      
      mb.ratio = c(0.55, 0.45), 
      mainbar.y.label = "Frequency of Each Combination Type",  
      sets.x.label = "Number of Publications Featuring Each Actor Type" 

