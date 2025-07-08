
# Process raw data into demographic metrics -------------------------------

lsoa_demo_age <- lsoa_demo_age_raw |>
  rowwise() |>
  mutate(pop_75_person = rowSums(across(c(81:96, 172:187))),
         pop_75_f = rowSums(across(c(81:96))),
         pop_75_m = rowSums(across(c(172:187))),
         pop_17u_person = rowSums(across(c(6:23, 97:114))),
         pop_17u_f = rowSums(across(c(6:23))),
         pop_17u_m = rowSums(across(c(97:114)))) |>
  select(c(1:5, 188:193))

rm(lsoa_demo_age_raw)

lsoa_demo_age <- lsoa_demo_age |>
  mutate(pop_75_person_perc = pop_75_person / Total,
         pop_75_f_perc = pop_75_f / Total,
         pop_75_m_perc = pop_75_m / Total,
         pop_17u_person_perc = pop_17u_person / Total,
         pop_17u_f_perc = pop_17u_f / Total,
         pop_17U_m_perc = pop_17u_m / Total)
