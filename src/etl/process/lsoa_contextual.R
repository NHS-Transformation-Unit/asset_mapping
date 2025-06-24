
# Join LSOA contextual data -----------------------------------------------

lsoa_contextual <- lsoa_demo_age |>
  left_join(lsoa_dep, by = c("LSOA 2021 Code" = "LSOA code (2011)"))


# Write processed LSOA contextual data ------------------------------------

write.csv(lsoa_contextual,
          paste0(here("data",
                      "processed",
                      "contextual",
                      "lsoa_contextual.csv")))
