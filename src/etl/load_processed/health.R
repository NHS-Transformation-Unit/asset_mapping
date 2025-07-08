
# Load GP Practices -------------------------------------------------------

gp_practices_geo <- read.csv(paste0(here("data",
                                   "processed",
                                   "contextual",
                                   "gp_practices_geo.csv"))) |>
  filter(!is.na(LAT)) |>
  st_as_sf(coords = c("LON", "LAT"), crs = 4326, remove = FALSE)


# Load Care Sites ---------------------------------------------------------

care_sites_geo <- read.csv(paste0(here("data",
                                       "processed",
                                       "contextual",
                                       "care_sites_geo.csv"))) |>
  filter(!is.na(LAT)) |>
  st_as_sf(coords = c("LON", "LAT"), crs = 4326, remove = FALSE)

# Load Trust Sites --------------------------------------------------------

trust_sites_geo <- read.csv(paste0(here("data",
                                        "processed",
                                        "contextual",
                                        "trust_sites_geo.csv"))) |>
  filter(!is.na(LAT)) |>
  st_as_sf(coords = c("LON", "LAT"), crs = 4326, remove = FALSE)


# Load Pharmacies Locations -----------------------------------------------

pharmacy_geo <- read.csv(paste0(here("data",
                                     "processed",
                                     "contextual",
                                     "pharmacy_geo.csv"))) |>
  filter(!is.na(LAT)) |>
  st_as_sf(coords = c("LON", "LAT"), crs = 4326, remove = FALSE)
