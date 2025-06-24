
# Join LSOA geospatial and contextual datasets ----------------------------

lsoa_icb_lookup <- lsoa_icb_lookup_raw |>
  select(c(1, 6:8))

lsoa_contextual_geo <- lsoa_geo |>
  left_join(lsoa_contextual, by = c("LSOA21CD" = "LSOA 2021 Code")) |>
  left_join(lsoa_icb_lookup, by = c("LSOA21CD"))


# Write to Processed ------------------------------------------------------

st_write(lsoa_contextual_geo,
         "data/processed/geospatial/lsoa_contextual_geo.gpkg")
