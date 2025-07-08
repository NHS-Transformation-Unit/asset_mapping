
# Package List ------------------------------------------------------------

packages <- c("here",
              "dplyr",
              "readxl",
              "tidyr",
              "scales",
              "sf",
              "leaflet",
              "shiny",
              "shinycssloaders")

# Package Load ------------------------------------------------------------

load_packages <- function(packages){
  
  missing_packages <- setdiff(packages, installed.packages()[,"Package"])
  
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
  
  lapply(packages, function(pkg) {
    library(pkg, character.only = TRUE)
  })
  
}

# Load Packages -----------------------------------------------------------

load_packages(packages)