
# Load libraries and data -------------------------------------------------

library(sf)
library(dplyr)

shapefile_path <- "data/geospatial/os_greenspace/GB_GreenspaceSite.shp"
output_path <- "data/processed/greenspace_filtered.rds"

greenspace <- st_read(shapefile_path, quiet = TRUE)

greenspace <- greenspace |>
  rename(function_type = function.)

# Filter greenspace data --------------------------------------------------

target_types <- c("Public Park Or Garden",
                  "Play Space",
                  "Playing Field")
greenspace_filtered <- greenspace |>
  filter(function_type %in% target_types)

# Drop empty geometries ---------------------------------------------------

greenspace_filtered <- greenspace_filtered |>
  filter(!st_is_empty(geometry)) |>
  st_zm(drop = TRUE, what = "ZM")

# Transform ---------------------------------------------------------------

greenspace_filtered <- st_simplify(greenspace_filtered, dTolerance = 10)
greenspace_filtered <- st_transform(greenspace_filtered, crs = 4326)

# Save as .RDS ------------------------------------------------------------
dir.create(dirname(output_path), showWarnings = FALSE, recursive = TRUE)
saveRDS(greenspace_filtered, output_path)
