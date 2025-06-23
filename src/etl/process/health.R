
# Load UPRN ---------------------------------------------------------------

uprn <- read.csv(paste0(here("data", "geospatial", "osopenuprn_202506.csv")))


# Link Libraries to UPRN Lookup -------------------------------------------


libs_geo_uprn <- libs_geo_pre |>
  rename("UPRN" = 8) |>
  mutate(UPRN = as.numeric(UPRN)) |>
  left_join(uprn, by = c("UPRN")) |>
  mutate(geo_match = case_when(!is.na(LATITUDE) ~ "UPRN",
                               TRUE ~ "PostCode"))


sum(is.na(libs_geo_uprn$LATITUDE))


# Link Pharmacy Locations to UPRN Lookup ----------------------------------

pharmacy_geo_uprn <- pharmacy_raw |>
  mutate(UPRN = as.numeric(UPRN)) |>
  left_join(uprn, by = c("UPRN")) |>
  mutate(geo_match = case_when(!is.na(LATITUDE) ~ "UPRN",
                               TRUE ~ "PostCode"))

pharmacy_geo <- pharmacy_geo_uprn |>
  mutate(LAT = case_when(!is.na(LATITUDE) ~ LATITUDE,
                         TRUE ~ as.numeric(PC_Lat)),
         LON = case_when(!is.na(LONGITUDE) ~ LONGITUDE,
                         TRUE ~ as.numeric(PC_Lon))) |>
  select(c(2, 4, 5, 28:30))

write.csv(pharmacy_geo,
          paste0(here("data",
                      "processed",
                      "contextual",
                      "pharmacy_geo.csv")))


# Link GP Practices -------------------------------------------------------

gp_practices_geo_uprn <- gp_practices_raw |>
  mutate(UPRN = as.numeric(UPRN)) |>
  left_join(uprn, by = c("UPRN")) |>
  mutate(geo_match = case_when(!is.na(LATITUDE) ~ "UPRN",
                               TRUE ~ "PostCode"))

sum(is.na(gp_practices_geo_uprn$LATITUDE))


gp_practices_geo <- gp_practices_geo_uprn |>
  mutate(LAT = case_when(!is.na(LATITUDE) ~ LATITUDE,
                         TRUE ~ as.numeric(PC_Lat)),
         LON = case_when(!is.na(LONGITUDE) ~ LONGITUDE,
                         TRUE ~ as.numeric(PC_Lon))) |>
  select(1:2, 21:23) |>
  rename("ODS_Code" = 1,
         "Name" = 2) |>
  mutate(Role = "GP PRACTICE") |>
  select(c(1, 6, 2, 3:5))

write.csv(gp_practices_geo,
          paste0(here("data",
                      "processed",
                      "contextual",
                      "gp_practices_geo.csv")))

# Link Care Sites to UPRN Lookup ------------------------------------------

care_sites_geo_uprn <- care_sites_raw |>
  mutate(UPRN = as.numeric(UPRN)) |>
  left_join(uprn, by = c("UPRN")) |>
  mutate(geo_match = case_when(!is.na(LATITUDE) ~ "UPRN",
                               TRUE ~ "PostCode"))

care_sites_geo <- care_sites_geo_uprn |>
  mutate(LAT = case_when(!is.na(LATITUDE) ~ LATITUDE,
                         TRUE ~ as.numeric(PC_Lat)),
         LON = case_when(!is.na(LONGITUDE) ~ LONGITUDE,
                         TRUE ~ as.numeric(PC_Lon))) |>
  select(c(2, 4, 5, 28:30))

write.csv(care_sites_geo,
          paste0(here("data",
                      "processed",
                      "contextual",
                      "care_sites_geo.csv")))


# Link Trust Sites to UPRN Lookup -----------------------------------------

trust_sites_geo_uprn <- trust_sites_raw |>
  mutate(UPRN = as.numeric(UPRN)) |>
  left_join(uprn, by = c("UPRN")) |>
  mutate(geo_match = case_when(!is.na(LATITUDE) ~ "UPRN",
                               TRUE ~ "PostCode"))

trust_sites_geo <- trust_sites_geo_uprn |>
  mutate(LAT = case_when(!is.na(LATITUDE) ~ LATITUDE,
                         TRUE ~ as.numeric(PC_Lat)),
         LON = case_when(!is.na(LONGITUDE) ~ LONGITUDE,
                         TRUE ~ as.numeric(PC_Lon))) |>
  select(c(2, 4, 5, 29:31, 24))

write.csv(trust_sites_geo,
          paste0(here("data",
                      "processed",
                      "contextual",
                      "trust_sites_geo.csv")))
