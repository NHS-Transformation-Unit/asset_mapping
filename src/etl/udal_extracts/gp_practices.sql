SELECT GP.[Organisation_Code]
      ,GP.[Organisation_Name]
      ,GP.[National_Grouping_Code]
      ,GP.[High_Level_Health_Authority_Code]
      ,GP.[Address_Line_1]
      ,GP.[Address_Line_2]
      ,GP.[Address_Line_3]
      ,GP.[Address_Line_4]
      ,GP.[Address_Line_5]
      ,GP.[Postcode]
      ,GP.[Open_Date]
      ,GP.[Close_Date]
      ,GP.[Status_Code]
	  ,PCGEO.[Latitude_1m] AS [PC_Lat]
      ,PCGEO.[Longitude_1m] AS [PC_Lon]
  
  FROM [UKHD_ODS].[GP_Practices_And_Prescribing_CCs_SCD] AS GP

  LEFT JOIN [UKHD_ODS].[Postcode_Grid_Refs_Eng_Wal_Sco_And_NI_SCD] AS PCGEO
  ON GP.[Postcode] = PCGEO.[Postcode_single_space_e_Gif]
  AND PCGEO.[Is_Latest] = 1

  WHERE GP.[Is_Latest] = 1
  AND GP.[Close_Date] IS NULL
  AND GP.[Status_Code] = 'A'

  ORDER BY GP.[Organisation_Name]
