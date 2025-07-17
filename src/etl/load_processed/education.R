
# Load Processed Schools Data ---------------------------------------------

school_geo <- read.csv(paste0(here("data",
                                   "processed",
                                   "contextual",
                                   "schools_geo.csv"))) |>
filter(!is.na(lat)) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)