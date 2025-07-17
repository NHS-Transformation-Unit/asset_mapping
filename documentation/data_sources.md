# Asset Mapping Data Sources

This document provides information about the data sources used within the asset 
map and how they can be accessed. This will documentation will be updated as 
new assets are added to the shiny app.

***
<br/>

## Geospatial Datasets

| **Dataset**         | **Description**           | **URL**                   |
|---------------------|---------------------------|---------------------------|
| Ordnance Survey Greenspace | The Ordnance Survey (OS) provide a geospatial dataset with the location of green spaces such as parks, playing fields, allotments etc. This is freely available for download. | [OS Open Greenspace](https://www.ordnancesurvey.co.uk/products/os-open-greenspace) |
| Lower Super Output Area Boundaries | Lower Super Output Area (LSOA) boundaries are available from the Office for National Statistics (ONS) Open Geography portal | Available from [Open Geography Portal](https://geoportal.statistics.gov.uk/search?q=BDY_LSOA%20DEC_2021&sort=Title%7Ctitle%7Casc)
| UPRN Lookup | The OS provide a lookup of every Unique Property Reference Number (UPRN) with their respective geometries such as Longitude and Latitude. | [OS UPRN Lookup Download](https://osdatahub.os.uk/downloads/open/OpenUPRN)
| LSOA to ICB Lookup | The Open Geography portal contains a lookup of LSOAs to their respective ICB | [Open Geography Portal](https://geoportal.statistics.gov.uk/search?sort=Date%20Created%7Ccreated%7Cdesc&tags=LUP_EXACT_LSOA21_SICBL_ICB_CAL) |

<br/>

## Contextual

| **Dataset**         | **Description**           | **URL**                   |
|---------------------|---------------------------|---------------------------|
| Deprivation (IMD)   | IMD Deciles and Ranking for each LSOA based from the 2019 IMD | [IMD 2019](https://www.gov.uk/government/collections/english-indices-of-deprivation) |
| Age Demographics    | Age demographics based on mid-year population estimates are available from the ONS. | [ONS Mid-Year Population Estimates](https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimates)

<br/>

## Assets

| **Asset** | **Description** | **Source** |
|-----------|-----------------|------------|
| GP Practices | Location of active GP Practices within UPRNs sourced from the NHS England Organisation Data Service via the UDAL platform | More information available [here](https://digital.nhs.uk/developer/api-catalogue/organisation-data-service-ord).
| Pharmacies | Location of active Pharmacies within UPRNs sourced from the NHS England Organisation Data Service via the UDAL platform | More information available [here](https://digital.nhs.uk/developer/api-catalogue/organisation-data-service-ord).
| Trust Sites | Location of active Trust sites within UPRNs sourced from the NHS England Organisation Data Service via the UDAL platform | More information available [here](https://digital.nhs.uk/developer/api-catalogue/organisation-data-service-ord).
| Care Sites | Location of active Care sites within UPRNs sourced from the NHS England Organisation Data Service via the UDAL platform | More information available [here](https://digital.nhs.uk/developer/api-catalogue/organisation-data-service-ord).
| Education Sites | Location of education sites such as schools sourced from GOV.UK | Available downloads [here](https://get-information-schools.service.gov.uk/Downloads).