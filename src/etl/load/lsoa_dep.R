
# Load IMD at LSOA --------------------------------------------------------

lsoa_dep_raw <- read_excel(path = paste0(here("data",
                                              "contextual",
                                              "IMD_2019.xlsx")),
                           sheet = 2)
