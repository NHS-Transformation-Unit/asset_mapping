
# Load all datasets for processing ----------------------------------------

extract_files_list <- list.files(path = paste0(here("src",
                                                    "etl",
                                                    "load")),
                                 pattern = "\\.R$",
                                 full.names = TRUE)

for (file in extract_files_list){
  
  source(file)
  
}
