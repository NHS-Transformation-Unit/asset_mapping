
# Load LSOA geospatial contextual dataset ---------------------------------

lsoa_contextual_geo <- st_read(paste0(here("data",
                                           "processed",
                                           "geospatial",
                                           "lsoa_contextual_geo.gpkg")))
