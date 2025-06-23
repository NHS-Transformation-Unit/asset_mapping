SELECT TRUST_SITES.[Organisation_Code]
      ,TRUST_SITES.[Organisation_Name]
      ,TRUST_SITES.[National_Grouping_Code]
      ,TRUST_SITES.[High_Level_Health_Authority_Code]
      ,TRUST_SITES.[Address_Line_1]
      ,TRUST_SITES.[Address_Line_2]
      ,TRUST_SITES.[Address_Line_3]
      ,TRUST_SITES.[Address_Line_4]
      ,TRUST_SITES.[Address_Line_5]
      ,TRUST_SITES.[Postcode]
      ,TRUST_SITES.[Open_Date]
      ,TRUST_SITES.[Close_Date]
      ,TRUST_SITES.[Parent_Organisation_Code]
      ,TRUST_SITES.[Organisation_Sub_Type_Code]
	  ,TRUST.[Organisation_Name] AS [Parent_Organisation_Name]
	  ,TRUST_TYPE.[Org_Type]
	  ,PCGEO.[Latitude_1m] AS [PC_Lat]
      ,PCGEO.[Longitude_1m] AS [PC_Lon]
  FROM [UKHD_ODS].[NHS_Trust_Sites_Assets_And_Units_SCD] AS TRUST_SITES

  LEFT JOIN [UKHD_ODS].[NHS_Trusts_SCD] AS TRUST
  ON TRUST_SITES.[Parent_Organisation_Code] = TRUST.[Organisation_Code]
  AND TRUST.[Is_Latest] = 1
  AND TRUST.[Close_Date] IS NULL

  LEFT JOIN [Internal_ESRReference].[REF_ORGANISATION] AS TRUST_TYPE
  ON TRUST.[Organisation_Code] = TRUST_TYPE.[Org_Code_For_Join]

  LEFT JOIN [UKHD_ODS].[Postcode_Grid_Refs_Eng_Wal_Sco_And_NI_SCD] AS PCGEO
  ON TRUST_SITES.[Postcode] = PCGEO.[Postcode_single_space_e_Gif]
  AND PCGEO.[Is_Latest] = 1

  WHERE TRUST_SITES.[Is_Latest] = 1
  AND TRUST_SITES.[Close_Date] IS NULL

  ORDER BY TRUST_SITES.[Organisation_Code]


