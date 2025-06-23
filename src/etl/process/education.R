
# Clean and convert coordinate system -------------------------------------

school_geo <- school_raw |>
  filter(EstablishmentStatus..name. == "Open",
         !is.na(Easting)) |>
  st_as_sf(coords = c("Easting", "Northing"), crs = 27700) |>
  st_transform(crs = 4326) %>%
  mutate(
    lon = st_coordinates(.)[,1],
    lat = st_coordinates(.)[,2]
  ) %>%
  st_drop_geometry() |>
  select(c(2, 3, 5, 7, 9, 19, 24, 26, 28, 40:43, 134, 135)) |>
  rename("LA_Code" = 1,
         "LA_Name" = 2,
         "Establishment_Name" = 3,
         "Establishment_Type" = 4,
         "Establishment_Group" = 5,
         "Establishment_Phase" = 6,
         "Nursery" = 7,
         "Sixth_Form" = 8,
         "Gender" = 9
  )

write.csv(school_geo,
          paste0(here("data", "processed", "contextual", "schools_geo.csv")))
