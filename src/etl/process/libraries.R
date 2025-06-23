
# Clean library data ------------------------------------------------------

libs_geo_pre <- libs_raw |>
  filter(is.na(`Year Permanently Closed`)) |>
  mutate(address_concat = paste0(`Name`,
                                 " ",
                                 `Address 1`,
                                 " ",
                                 `Address 2`,
                                 " ",
                                 `Address 3`,
                                 " ",
                                 Postcode)) |>
  select(c(1:9, 55))



# Get location details for locations with uprns ---------------------------

libs_geo_pre_uprn <- libs_geo_pre |>
  filter(!is.na(`Unique property reference number`))

geo_uprn <- data.frame(
  row = seq_len(nrow(libs_geo_pre_uprn)),
  longitude = rep(NA_real_, nrow(libs_geo_pre_uprn)),
  latitude = rep(NA_real_, nrow(libs_geo_pre_uprn))
)

for (i in seq_len(nrow(libs_geo_pre_uprn))) {
  uprn_value <- libs_geo_pre_uprn$`Unique property reference number`[[i]]
  
  if (is.na(query) || query == "") next
  
  res <- GET(
    url = "https://api.os.uk/search/places/v1/uprn",
    query = list(
      uprn = uprn_value,
      format = "JSON",
      lr = "EN",
      output_srs = "WGS84",
      key = api_key
    )
  )
  
  # Check content type is JSON before parsing
  content_type <- headers(res)[["content-type"]]
  
  if (!is.null(content_type) && grepl("application/json", content_type)) {
    data <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
    
    if (length(data$results$DPA) > 0) {
      geo_uprn$longitude[i] <- as.numeric(data$results$DPA$LNG)
      geo_uprn$latitude[i] <- as.numeric(data$results$DPA$LAT)
    }
  } else {
    # Response is not JSON (e.g. HTML error page), skip this row
    geo_uprn$longitude[i] <- NA_real_
    geo_uprn$latitude[i] <- NA_real_
  }
  
  Sys.sleep(1.5)
}




# Sample subset
libs_geo_test <- libs_geo |> slice(1:10)

geo_test <- data.frame(
  row = seq_len(nrow(libs_geo_test)),
  longitude = rep(NA_real_, nrow(libs_geo_test)),
  latitude = rep(NA_real_, nrow(libs_geo_test))
)

for (i in seq_len(nrow(libs_geo_test))) {
  query <- libs_geo_test$address_concat[[i]]
  
  if (is.na(query) || query == "") next
  
  res <- GET(
    url = "https://api.os.uk/search/places/v1/find",
    query = list(
      query = query,
      format = "JSON",
      maxresults = 1,
      lr = "EN",
      output_srs = "WGS84",
      key = api_key
    )
  )
  
  # Check content type is JSON before parsing
  content_type <- headers(res)[["content-type"]]
  
  if (!is.null(content_type) && grepl("application/json", content_type)) {
    data <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
    
    if (length(data$results$DPA) > 0) {
      geo_test$longitude[i] <- as.numeric(data$results$DPA$LNG)
      geo_test$latitude[i] <- as.numeric(data$results$DPA$LAT)
    }
  } else {
    # Response is not JSON (e.g. HTML error page), skip this row
    geo_test$longitude[i] <- NA_real_
    geo_test$latitude[i] <- NA_real_
  }
  
  Sys.sleep(1.5)
}



libs_geo_test <- libs_geo |> slice(1:100)

geo_test <- data.frame(
  row = seq_len(nrow(libs_geo_test)),
  longitude = rep(NA_real_, nrow(libs_geo_test)),
  latitude = rep(NA_real_, nrow(libs_geo_test))
)

for (i in seq_len(nrow(libs_geo_test))) {
  uprn_value <- libs_geo_test$`Unique property reference number`[[i]]
  
  if (is.na(query) || query == "") next
  
  res <- GET(
    url = "https://api.os.uk/search/places/v1/uprn",
    query = list(
      uprn = uprn_value,
      format = "JSON",
      lr = "EN",
      output_srs = "WGS84",
      key = api_key
    )
  )
  
  # Check content type is JSON before parsing
  content_type <- headers(res)[["content-type"]]
  
  if (!is.null(content_type) && grepl("application/json", content_type)) {
    data <- fromJSON(content(res, as = "text", encoding = "UTF-8"))
    
    if (length(data$results$DPA) > 0) {
      geo_test$longitude[i] <- as.numeric(data$results$DPA$LNG)
      geo_test$latitude[i] <- as.numeric(data$results$DPA$LAT)
    }
  } else {
    # Response is not JSON (e.g. HTML error page), skip this row
    geo_test$longitude[i] <- NA_real_
    geo_test$latitude[i] <- NA_real_
  }
  
  Sys.sleep(1.5)
}
