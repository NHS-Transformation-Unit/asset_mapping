
# Process raw LSOA deprivation data ---------------------------------------

lsoa_dep <- lsoa_dep_raw |>
  select(c(1, 5, 6))
