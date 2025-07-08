
# Load all datasets for shiny app ----------------------------------------

processed_files_list <- list.files(path = paste0(here("src",
                                                      "etl",
                                                      "load_processed")),
                                   pattern = "\\.R$",
                                   full.names = TRUE)

for (file in processed_files_list){
  
  source(file)
  
}
