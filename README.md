<img src="images/TU_logo_large.png" alt="TU logo" width="200" align="right"/>

# Health and Care Asset Mapping

This is a Shiny app developed by the [NHS Transformation Unit](https://transformationunit.nhs.uk/) 
to visualise the distribution of health and wellbeing assets across England, 
alongside population needs. This has been created in response to the ambitions 
within the [10 Year Plan](https://www.gov.uk/government/publications/10-year-health-plan-for-england-fit-for-the-future) of:

- Moving care closer to home
- Focussing on prevention

The app helps users explore the spatial distribution of:
- Health sites (e.g. GP practices, hospitals, pharmacies)
- Green spaces (e.g. parks, play areas)
- Population metrics (e.g. demographics, deprivation) at LSOA level

## Accessing the App
The app is deployed on [shinyapps.io](https://nhs-tu-andy-wilson.shinyapps.io/asset_mapping/). 
Our plan is to update the app with a greater range of health assets.

## Data Sources
The app has been created with publicly available data using:

- Locations of green spaces produced by the Ordnance Survey
- Boundaries of ICBs and LSOAs from the Open Geography Portal
- Locations of health and care locations from the Organisation Data Service (ODS)
- Population needs information such as ONS demographics and deprivation statistics

The full metadata of datasets used within the app will be made available in the `documentation` folder.

## Repository Structure

The current structure of the repository is detailed below:

``` plaintext

├───README.md
├───.gitignore
├───app.R
├───data
    ├───contextual
    ├───geospatial
    ├───processed
    └───reference
├───documentation    
├───images
├───src
    ├───config
    ├───etl
        ├───load
        ├───load_geospatial
        ├───load_processed
        ├───load_reference
        ├───process
        └───udal_extracts
    ├───helpers
    └───requirements
└───www

```

The repository contains:

- `README.md`: This README providing an overview of the repository.
- `.gitignore`: Determines which files to not track.
- `app.R`: The shiny app for producing the asset map.
- `data`: Contains the raw data files, geospatial data, processed data files for loading into the app and reference data.
- `documentation`: Will contain documentation on the data sources used to produce the app along with a brief user guide.
- `images`: Contains logos and the data pipeline diagram.
- `src`: Contains the code for processing data and building the app.
  - `config`: Contains the tu palette hex colour codes and shape colours for the leaflet maps.
  - `etl`: Contains the scripts for processing the raw data files, transforming geospatial data and then loading relevant files into the app.
  - `helpers`: Contains the `utils.R` file with utility functions for the app.
  - `requirements`: Contains the R packages required for running the pipeline and app.
- `www`: Contains images and css theme file for the shiny app.


## Data Pipeline
The diagram below provides a summary of how the data is processed, the scripts that perform these actions and the process for loading this into the app:

<img src="images/pipeline.drawio.svg" alt="Data Pipeline"/>

## Contributors
This repository has been created and developed by:

-   [Andy Wilson](https://github.com/ASW-Analyst)
