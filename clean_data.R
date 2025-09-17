library(readr)
library(dplyr)
library(tidyr)

clean_data <- function(folder, input, output) {
  #read csv
  faasr_get_file(remote_folder=folder, input, local_file="phd_stipend.csv")
  phd_stipend_df <- read_csv("phd_stipend.csv")
  
  #change column names into R style for better indexing
  colnames(phd_stipend_df)[colnames(phd_stipend_df) == 'University'] <- 'university'
  colnames(phd_stipend_df)[colnames(phd_stipend_df) == 'Department'] <- 'department'
  colnames(phd_stipend_df)[colnames(phd_stipend_df) == '12 M Gross Pay'] <- 'year_gross_pay'
  colnames(phd_stipend_df)[colnames(phd_stipend_df) == 'LW Ratio'] <- 'LW_ratio'
  colnames(phd_stipend_df)[colnames(phd_stipend_df) == 'Program Year'] <- 'program_year'
  
  #select columns and drop rows with NA values
  cleaned <- phd_stipend_df %>% 
    select('university', 'department','year_gross_pay', 'LW_ratio', 'program_year') %>%
    drop_na()
  
  #get rid of characters in year gross pay and program year, and convert them into numeric columns
  cleaned$year_gross_pay = as.numeric(gsub("[\\$,]", "", cleaned$year_gross_pay))
  cleaned$program_year <- as.numeric(substr(cleaned$program_year, 1, 1))
  
  #write cleaned data into csv file
  write.csv(cleaned, "phd_stipend_clean.csv", row.names = FALSE)
  
  faasr_put_file(local_file="phd_stipend_clean.csv", remote_folder=folder, remote_file=output)
  log_msg <- paste0('Data cleaning completed')
  faasr_log(log_msg)
}






