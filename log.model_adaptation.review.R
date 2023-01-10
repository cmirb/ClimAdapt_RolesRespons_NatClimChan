# who is adapting  and how?
# identifying actors and roles in climate action
# systematic review
# code written by Charlotta Mirbach (LMU, UHH)


# packages ----------------------------------------------------------------
library(tidyverse) # to load tidyverse packages
library(MASS) # for ordered logistic regression
library(broom) # to convert statistics to tidy tibbles
library(knitr) # dynamic reports
library(pixiedust) # produce tables
library(dplyr) # data manipulation


# data manipulation -------------------------------------------------------


path <- # adjust path according to your directories
setwd(path)

# note that the data were pre-processed, cleaned, and inflated due to
#  multiple cell entries in original dataset
df <- read.csv('./data.csv', sep=';')
df <- df %>% mutate_if(is.character, as.factor)

# logistic regression on dummy encoded binary df --------------------------
# create binary encoding
res <- fastDummies::dummy_cols(df, select_columns = c('geography',
                                                      'response', 'settlement',
                                                      'actor', 'adaptation'),
                               remove_first_dummy = F)

# select id and binary columns
res <- res[, c(1,4, 8:42)]

# summrarize based on article.id
# sums up all observations
res_group <- res %>%
  group_by(Article.ID, depth) %>%
  summarise(across(everything(), sum, na.rm = TRUE), .groups = 'drop')
# drop article id
res_group <- res_group[,c(2:37)]
# encode back to binary
res_group <- res_group %>% mutate_if(is.numeric, ~1 * (. > 0))

df_bin <- res_group

df_bin$depth <- as.factor(df_bin$depth)
df_bin$depth <- ordered(df_bin$depth, levels = c("low", "medium", "high"))


# log.model ---------------------------------------------------------------

# create model
log.model <- polr(depth~.,data = df_bin, Hess=T)

# save model summary
model.summary <- summary(log.model)

# create model output
out <- tidy(log.model)
kable(out)
(ctable <- coef(summary(log.model)))

## calculate and store p values
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
## combined table
(ctable <- cbind(ctable, "p value" = p))

1-pchisq(deviance(log.model),df.residual(log.model))
log.model$fitted.values
anova(log.model, test="Chisq")


# export results ----------------------------------------------------------

output_wd <- # adjust path according to your directories
setwd(output_wd)

# save model summary
cat("Logistic Regression Depth (WIA)", file = "log.regression.txt")
# add 2 newlines
cat("\n\n", file = "log.regression.txt", append = TRUE)
# write model summary to txt file
cat("Logistic Regression Model Summary\n", file = "log.regression.txt", append = TRUE)
capture.output(model.summary, file = "log.regression.txt", append = TRUE)








