# Main ---------------------------------------
# Script Name: petzold-mirbach_NCC_2023_chi-square-test
# Purpose: Calculates Chi-Squared test for combinations of variables (actors and roles)
# Description ---------------------------------------
# Author: Charlotta Mirbach (c.mirbach@lmu.de)
# Created: Dec 2022
# Last Modified: Jan 2024
# Contributes to: Petzold et al., (2023): A global assessment of actors and their roles in climate change adaptation (Nature Climate Change)
# doi: https://doi.org/10.1038/s41558-023-01824-z

# Input: GAMI database merged with recoded papers, specifically for actors and roles. 
# Output: Chi-Squared test result + residuals table, basic plots (corrplot style for residuals)
# Dependencies: see packages below
# Usage: Please download the data from https://github.com/cmirb/WIA/blob/main/actor_roles_combinations.csv and adjust file paths to your system.
# Issues: none
# Questions: please contact Charlotta Mirbach or Jan Petzold


# Begin Script ---------------------------------------
#Preamble ===

# clear workspace
rm(list=ls())
gc()
setwd('D:/05_lmu/01_sys-rev/')

# load packages
library(splitstackshape)
library(corrplot)
library(ggcorrplot)
require(tidyverse)
require(rcompanion)
library(vcd)


# Run Script ---------------------------------------

# Load Data ====
actor_roles <- read.csv('./01-data/02-output/adaptation_review/actor_roles_combinations.csv', sep=';')
df <- dplyr::select(actor_roles, Actor.type, Adaptation.role.stage)

# Prep Data ====
# rename cols
colnames(df)
new_cols <- c('actor', 'role')
colnames(df) <- new_cols

# convert to factor
df$actor <- as.factor(df$actor)
df$role <- as.factor(df$role)


# Calculate Statistics ====

# calculate correlations for initial inspection
model.matrix(~0+., data=df) %>% 
  cor(use="pairwise.complete.obs", method='pearson') %>% 
  ggcorrplot(show.diag = F, type="lower", lab=TRUE, lab_size=2,
             insig = 'blank')

# CramerV
cramerV(df$actor, df$role) # 0.221

# Chi-Squ Test ===
# convert to cross-table
table <- table(df$actor, df$role)

# run chi-squ test
chisqu_df <- chisq.test(df$actor, df$role)
c(chisqu_df$statistic, chisqu_df$p.value)
# X-squared              
# 6.107718e+02 2.743754e-87 

sqrt(chisqu_df$statistic / sum(table))
chisq_df_t <- chisq.test(table)
chisq_df_t$stdres
chisq.posthoc.test(table, method = "bonferroni")

chisq_t<- chisq.test(table, simulate.p.value = TRUE, B=10000)
round(chisq_t$residuals,3)
chisq_t$residuals


# Export Data ===
# write.csv(chisq_df_t$residuals, "./07-transfer/chi-square-test-results_actors_roles.csv")

# Plot Results ===

# basic plot
windows() 
corrplot(chisq_df_t$residuals,is.cor=FALSE, 
         tl.col = "black", 
         tl.srt = 30,
         tl.cex = 2,
         cl.cex = 1.2,
         cl.pos = 'b',
         cl.align.text = 'l',
         cl.ratio = 0.1,
         cl.offset = 1,
         addCoef.col = 'grey30',#
         number.cex = 2)
dev.off()

# better plot
p <- ggcorrplot(chisq_t$residuals, method = 'circle',
                tl.col = "black", 
                tl.srt = 100,
                tl.cex = 7,
                lab=T,
                lab_col = 'black',
                lab_size = 3,
                legend.title = NULL)
p + scale_fill_gradient2(limit = c(-5,12), 
                         low = "blue", high =  "red", 
                         mid = "white", midpoint = c(0)) 
p

# End Script ---------------------------------------

