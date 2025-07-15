# Load packages and data --------------------------------------------------

library(here)
library(dplyr)
library(readxl)
library(tidyr)
library(scales)
library(sf)
library(leaflet)
library(shiny)
library(shinycssloaders)

# Load project sources
source(paste0(here("src", "requirements", "packages.R")))
source(paste0(here("src", "config", "shape_colours.R")))
source(paste0(here("src", "config", "tu_palette.R")))
source(paste0(here("src", "etl", "load_geospatial", "lsoa_contextual_geo.R")))
source(paste0(here("src", "etl", "load_processed", "greenspace_filtered.R")))
source(paste0(here("src", "etl", "load_processed", "health.R")))
source(paste0(here("src", "etl", "load_reference", "icb_centres.R")))
source(paste0(here("src", "helpers", "utils.R")))

# Processing --------------------------------------------------------------

lsoa_contextual_geo$IMD <- factor(lsoa_contextual_geo$Index.of.Multiple.Deprivation..IMD..Decile)

# UI ----------------------------------------------------------------------

ui <- fluidPage(
  
  tags$link(rel = "stylesheet", type = "text/css", href = "config/app_theme.css"),
  
  navbarPage(
    title = "Asset Map",
    id = "navbar",
    
    tabPanel("Introduction",
             fluidPage(
               tags$img(src = "images/TU_logo_large.png", height = "80px", style = "float: right; margin-top: 10px;"),
               h1("Asset Map"),
               hr(),
               h3("Introduction"),
               p("The ", tags$a("NHS 10 Year Plan", href = "https://assets.publishing.service.gov.uk/media/6866387fe6557c544c74db7a/fit-for-the-future-10-year-health-plan-for-england.pdf", target = "_blank"),
                 " has the ambitions of moving care closer to home and focussing on prevention. For these 
                 ambitions to be realised there needs to be an understanding of the range of health and care 
                 services that currently exist across localities. These ", strong("health assets"), " can include:",
                 tags$ul(
                   tags$li("GP Practices"),
                   tags$li("Hospital Sites"),
                   tags$li("Pharmacies")
                 )),
               p("However, there are other assets that are important to the health and wellbeing of the local population such as:",
                 tags$ul(
                   tags$li("Greenspaces such as parks and playing fields"),
                   tags$li("Education facilities"),
                   tags$li("Libraries")
                 )),
               p("Information about the location of health assets is publicly available, but it's often scattered across 
                 multiple sources. This makes it difficult to understand how these assets align with the needs of local populations. 
                 To address this, we’ve created this app as a centralised platform that brings together data on health assets and 
                 population need, helping you explore their distribution in one place."),
               br(),
               h3("How to use the app"),
               p("To view the map navigate to the ", strong("ICB Map"), " tab located in the navigation bar at the top. Follow 
                 the instructions below to change the information shown on the map:"),
               br(),
               h4("Select an ICB"),
               p("Use the drop-down menu to select the ICB that you are interested in. This will update the map to centre 
                 and zoom in on that specific ICB."),
               h4("Select layers to display"),
               p("Tick the check boxes to determine which layers on the map you want to show. For example, the boundaries 
                 of each Lower Super Output Area (LSOA) within the ICB or the location of green spaces identified by the 
                 Ordnance Survey (OS). These choices will update the map and enable the selection of specific assets for 
                 those choices."),
               h4("Colour LSOAs"),
               p("You can choose to colour each LSOA by a population demographic metric such as the population of paitents 
                 who are aged 75 years or older or the deprivation decile based on the 2019 Index of Multiple Deprivation (IMD)."),
               h4("Additional Asset Selections"),
               p("When you choose what layers you want to display on the map you may be presented with additional check boxes 
                 that present assets you wish to show at a more granular layer. Select those assets that you wish to show on the map."),
               h4("Navigating the map"),
               p("You can navigate the map using the zoom controls and by dragging your mouse to move around the ICB or zoom in on a 
                 specific area to see this in more detail. Clicking on the layers in the map will present more information such as the 
                 name of a GP practice or the deprivation decile of that LSOA."),
               br(),
               h3("Metadata and Code"),
               p("This app has been developed by ", tags$a("Andy Wilson", href = "https://github.com/ASW-Analyst", target = "_blank"), 
                 "Modelling and Analytics lead at the ", tags$a("NHS Transformation Unit", href = "https://transformationunit.nhs.uk/", target = "_blank"),
                 ". At the Transformation Unit we are committed to the transparency of our work. Therefore, all the information about 
                 the sources of data and the code used to create this app are available in the ", tags$a("GitHub Repository", href = "https://github.com/NHS-Transformation-Unit/asset_mapping", target = "_blank"),
                 ".")
             )
    ),
    
    tabPanel("ICB Map",
             sidebarLayout(
               sidebarPanel(
                 selectInput("icb_select", "Select ICB:", choices = NULL),
                 hr(),
                 checkboxGroupInput("layer_select", "Select layers to display:",
                                    choices = c("LSOA Boundaries" = "lsoa",
                                                "Green Spaces" = "greenspace",
                                                "Health Sites" = "health"),
                                    selected = c("lsoa", "greenspace")),
                 hr(),
                 selectInput("lsoa_color_var", "Colour LSOAs by:",
                             choices = c("None" = "none",
                                         "Percentage Aged 75+" = "pop_75_person_perc",
                                         "Percentage Aged Under 18" = "pop_17u_person_perc",
                                         "IMD Decile" = "IMD"),
                             selected = "none"),
                 hr(),
                 conditionalPanel(
                   condition = "input.layer_select.indexOf('greenspace') > -1",
                   checkboxGroupInput(
                     "greenspace_types",
                     "Select Greenspace Types:",
                     choices = greenspace_types_list,
                     selected = c("Public Park Or Garden", "Play Space", "Playing Field")
                   )
                 ),
                 hr(),
                 conditionalPanel(
                   condition = "input.layer_select.indexOf('health') > -1",
                   checkboxGroupInput(
                     "health_types",
                     "Select Health Site Types:",
                     choices = c("GP Practices" = "gp",
                                 "Pharmacies" = "pharmacy",
                                 "Hospital Trust Sites" = "hospital",
                                 "Care Trust Sites" = "care"),
                     selected = c("gp", "pharmacy", "hospital", "care")
                   )
                 )
               ),
               
               mainPanel(
                 withSpinner(leafletOutput("map", height = "800px"), type = 4, color = "#407EC9")
               )
             )
    )
  )
)

# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
  updateSelectInput(session, "icb_select",
                    choices = sort(unique(lsoa_contextual_geo$ICB24NM)),
                    selected = "NHS Greater Manchester Integrated Care Board")
  
  selected_icb_centre <- reactive({
    req(input$icb_select)
    icb_centres |>
      filter(ICB24NM == input$icb_select)
  })
  
  filtered_data <- reactive({
    req(input$icb_select)
    
    lsoa_filtered <- lsoa_contextual_geo |>
      filter(ICB24NM == input$icb_select)
    
    lsoa_filtered <- st_transform(lsoa_filtered, crs = st_crs(greenspace_site))
    greenspace_filtered <- st_filter(greenspace_site, lsoa_filtered, .predicate = st_intersects)
    
    health_types <- input$health_types %||% c("gp", "pharmacy", "hospital", "care")
    
    health_filter <- function(df) {
      st_filter(st_transform(df, crs = st_crs(lsoa_filtered)),
                lsoa_filtered,
                .predicate = st_intersects)
    }
    
    list(
      lsoa = st_transform(lsoa_filtered, crs = 4326),
      greenspace = st_transform(greenspace_filtered, crs = 4326),
      gp = if ("gp" %in% health_types) st_transform(health_filter(gp_practices_geo), crs = 4326) else NULL,
      pharmacy = if ("pharmacy" %in% health_types) st_transform(health_filter(pharmacy_geo), crs = 4326) else NULL,
      hospital = if ("hospital" %in% health_types) st_transform(health_filter(trust_sites_geo), crs = 4326) else NULL,
      care = if ("care" %in% health_types) st_transform(health_filter(care_sites_geo), crs = 4326) else NULL
    )
  })
  
  output$map <- renderLeaflet({
    centre <- selected_icb_centre()
    leaflet() |>
      addProviderTiles(providers$CartoDB.Positron) |>
      setView(lng = centre$LONG_C, lat = centre$LAT_C, zoom = centre$ZOOM)
  })
  
  observeEvent(input$icb_select, {
    centre <- selected_icb_centre()
    leafletProxy("map") |>
      setView(lng = centre$LONG_C, lat = centre$LAT_C, zoom = centre$ZOOM)
  })
  
  update_map_layers <- function() {
    if (is.null(input$icb_select) || is.null(input$layer_select) || is.null(input$lsoa_color_var)) return()
    if (is.null(lsoa_contextual_geo) || !input$icb_select %in% lsoa_contextual_geo$ICB24NM) return()
    
    data <- tryCatch({
      filtered_data()
    }, error = function(e) {
      message("filtered_data() failed: ", e$message)
      return(NULL)
    })
    
    if (is.null(data)) return()
    
    proxy <- leafletProxy("map") |>
      clearShapes() |>
      clearMarkers() |>
      clearControls()
    
    # LSOA polygons
    if ("lsoa" %in% input$layer_select) {
      lsoa_data <- data$lsoa
      var <- input$lsoa_color_var
      
      if (var != "none") {
        values <- lsoa_data[[var]]
        valid_idx <- !is.na(values) & !st_is_empty(lsoa_data) & !is.na(st_dimension(lsoa_data))
        lsoa_data <- lsoa_data[valid_idx, ]
        values <- lsoa_data[[var]]
        
        var_labels <- c(
          "pop_75_person_perc" = "Percentage Aged 75+",
          "pop_17u_person_perc" = "Percentage Aged Under 18",
          "IMD" = "IMD Decile"
        )
        label <- var_labels[[var]]
        
        fill_values <- if (var == "IMD") {
          suppressWarnings(as.numeric(as.character(values)))
        } else {
          values
        }
        
        palette_func <- if (var == "IMD") {
          colorNumeric("Blues", domain = fill_values, na.color = "#808080", reverse = TRUE)
        } else if (is.numeric(fill_values)) {
          colorNumeric("YlOrRd", domain = fill_values, na.color = "#808080")
        } else {
          colorFactor("Set3", domain = fill_values, na.color = "#808080")
        }
        
        lsoa_data <- lsoa_data[!is.na(fill_values) & !st_is_empty(lsoa_data), ]
        fill_values <- fill_values[!is.na(fill_values)]
        
        if (nrow(lsoa_data) > 0) {
          lsoa_data$fillCol <- palette_func(fill_values)
        }
        
        formatted_values <- case_when(
          var %in% c("pop_75_person_perc", "pop_17u_person_perc") ~ paste0(round(fill_values * 100, 1), "%"),
          TRUE ~ as.character(fill_values)
        )
        
        if (nrow(lsoa_data) > 0 && "fillCol" %in% colnames(lsoa_data)) {
          proxy <- proxy |> addPolygons(
            data = lsoa_data,
            color = "black", weight = 0.25,
            fillColor = ~I(fillCol),
            fillOpacity = 0.6,
            popup = paste0(
              "<strong>LSOA: </strong>", lsoa_data$LSOA21NM, "<br/>",
              "<strong>", label, ": </strong>", formatted_values
            )
          ) |>
            addLegend("bottomright", pal = palette_func, values = fill_values, title = label,
                      opacity = 0.7,
                      labFormat = if (var %in% c("pop_75_person_perc", "pop_17u_person_perc")) {
                        labelFormat(suffix = "%", transform = function(x) x * 100)
                      } else labelFormat())
        }
        
      } else {
        if (nrow(lsoa_data) > 0) {
          proxy <- proxy |> addPolygons(
            data = lsoa_data,
            color = "black", weight = 0.25,
            fillColor = "#407EC9", fillOpacity = 0.1,
            popup = ~paste0("<strong>LSOA: </strong>", LSOA21NM)
          )
        }
      }
    }
    
    # Greenspace
    if ("greenspace" %in% input$layer_select) {
      greenspace_types <- input$greenspace_types %||% c("Public Park Or Garden", "Play Space", "Playing Field")
      if (length(greenspace_types) > 0) {
        gs <- data$greenspace |>
          filter(function_type %in% greenspace_types) |>
          mutate(
            fillCol = as.character(function_colors[function_type]),
            fillCol = ifelse(is.na(fillCol), "#CCCCCC", fillCol)
          )
        
        if (nrow(gs) > 0) {
          proxy <- proxy |> addPolygons(
            data = gs,
            color = "black", weight = 1,
            fillColor = ~I(fillCol),
            fillOpacity = 0.5,
            popup = ~paste0(
              "<strong>Greenspace Name: </strong>", distName1, "<br/>",
              "<strong>Function: </strong>", function_type
            )
          ) |>
            addLegend("bottomright",
                      colors = unname(function_colors[greenspace_types]),
                      labels = greenspace_types,
                      title = "Greenspace Function",
                      opacity = 0.7)
        }
      }
    }
    
    # Health Sites
    health_colors <- c(
      "gp" = palette_tu[1],
      "pharmacy" = palette_tu[6],
      "hospital" = palette_tu[7],
      "care" = palette_tu[2]
    )
    
    if ("health" %in% input$layer_select) {
      health_types <- input$health_types %||% c("gp", "pharmacy", "hospital", "care")
      
      if ("gp" %in% health_types && !is.null(data$gp)) {
        proxy <- proxy |> addCircleMarkers(
          data = data$gp,
          radius = 5,
          fillColor = as.character(health_colors["gp"]),
          color = health_colors["gp"],
          fillOpacity = 0.8,
          stroke = TRUE, weight = 1,
          popup = ~paste0("<strong>GP Practice: </strong><br/>", Name)
        )
      }
      if ("pharmacy" %in% health_types && !is.null(data$pharmacy)) {
        proxy <- proxy |> addCircleMarkers(
          data = data$pharmacy,
          radius = 5,
          fillColor = as.character(health_colors["pharmacy"]),
          color = health_colors["pharmacy"],
          fillOpacity = 0.8,
          stroke = TRUE, weight = 1,
          popup = ~paste0("<strong>Pharmacy: </strong><br/>", Name)
        )
      }
      if ("hospital" %in% health_types && !is.null(data$hospital)) {
        proxy <- proxy |> addCircleMarkers(
          data = data$hospital,
          radius = 6,
          fillColor = as.character(health_colors["hospital"]),
          color = health_colors["hospital"],
          fillOpacity = 0.8,
          stroke = TRUE, weight = 1,
          popup = ~paste0("<strong>Hospital Site: </strong><br/>", Name)
        )
      }
      if ("care" %in% health_types && !is.null(data$care)) {
        proxy <- proxy |> addCircleMarkers(
          data = data$care,
          radius = 5,
          fillColor = as.character(health_colors["care"]),
          color = health_colors["care"],
          fillOpacity = 0.8,
          stroke = TRUE, weight = 1,
          popup = ~paste0("<strong>Care Trust Site: </strong><br/>", Name)
        )
      }
      
      if (length(health_types) > 0) {
        proxy <- proxy |> addLegend(
          position = "bottomleft",
          colors = health_colors[health_types],
          labels = c(
            "gp" = "GP Practice",
            "pharmacy" = "Pharmacy",
            "hospital" = "Hospital Site",
            "care" = "Care Trust Site"
          )[health_types],
          title = "Health Site Type",
          opacity = 0.8
        )
      }
    }
  }
  
  observe({
    req(input$icb_select, input$layer_select, input$lsoa_color_var)
    update_map_layers()
  })
  
  observeEvent(input$icb_select, {
    req(input$layer_select, input$lsoa_color_var)
    update_map_layers()
  }, ignoreInit = FALSE)
  
  observeEvent(input$map_bounds, {
    update_map_layers()
  }, once = TRUE, ignoreNULL = TRUE)
}


# Run the App -------------------------------------------------------------
shinyApp(ui, server)
