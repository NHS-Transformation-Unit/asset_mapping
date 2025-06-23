
# Load GP Practices -------------------------------------------------------

gp_practices_geo <- read.csv(paste0(here("data",
                                   "processed",
                                   "contextual",
                                   "gp_practices_geo.csv")))


# Load Care Sites ---------------------------------------------------------

care_sites_geo <- read.csv(paste0(here("data",
                                       "processed",
                                       "contextual",
                                       "care_sites_geo.csv")))

# Load Trust Sites --------------------------------------------------------

trust_sites_geo <- read.csv(paste0(here("data",
                                        "processed",
                                        "contextual",
                                        "trust_sites_geo.csv")))


# Load Pharmacies Locations -----------------------------------------------

pharmacy_geo <- read.csv(paste0(here("data",
                                     "processed",
                                     "contextual",
                                     "pharmacy_geo.csv")))
