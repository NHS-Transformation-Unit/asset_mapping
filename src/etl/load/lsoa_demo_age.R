
# Load LSOA Age Demographics Dataset --------------------------------------

lsoa_demo_age_raw <- read_excel(path = paste0(here("data",
                                                   "contextual",
                                                   "lsoa_demo_age.xlsx")),
                                skip = 3)
