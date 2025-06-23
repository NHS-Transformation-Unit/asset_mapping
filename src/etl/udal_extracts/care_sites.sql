SELECT CARE.[Organisation_Code]
      ,CARE.[Organisation_Name]
      ,CARE.[National_Grouping_Code]
      ,CARE.[High_Level_Health_Authority_Code]
      ,CARE.[Address_Line_1]
      ,CARE.[Address_Line_2]
      ,CARE.[Address_Line_3]
      ,CARE.[Address_Line_4]
      ,CARE.[Address_Line_5]
      ,CARE.[Postcode]
      ,CARE.[Open_Date]
      ,CARE.[Close_Date]
	  ,CARE.[Parent_Organisation_Code]
	  ,PRO.[Organisation_Name]
	  ,PCGEO.[Latitude_1m] AS [PC_Lat]
      ,PCGEO.[Longitude_1m] AS [PC_Lon]
  FROM [UKHD_ODS].[Care_Trust_Sites_SCD] AS CARE

  LEFT JOIN [UKHD_ODS].[All_Providers_SCD] AS PRO
  ON CARE.[Parent_Organisation_Code] = PRO.[Organisation_Code]
  AND PRO.[Is_Latest] = 1
  AND PRO.[Close_Date] IS NULL

  LEFT JOIN [UKHD_ODS].[Postcode_Grid_Refs_Eng_Wal_Sco_And_NI_SCD] AS PCGEO
  ON CARE.[Postcode] = PCGEO.[Postcode_single_space_e_Gif]
  AND PCGEO.[Is_Latest] = 1

  WHERE CARE.[Is_Latest] = 1
  AND CARE.[Close_Date] IS NULL

  ORDER BY CARE.[Organisation_Name]
