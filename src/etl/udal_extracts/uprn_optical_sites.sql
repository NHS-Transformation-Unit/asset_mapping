SELECT UPRN.[register_id]
      ,UPRN.[ODS_Code]
      ,UPRN.[Role_Id]
      ,UPRN.[Role]
      ,UPRN.[Name]
      ,UPRN.[OrgRecordClass]
      ,UPRN.[Status]
      ,UPRN.[AddrLn1]
      ,UPRN.[AddrLn2]
      ,UPRN.[AddrLn3]
      ,UPRN.[Town]
      ,UPRN.[County]
      ,UPRN.[PostCode]
      ,UPRN.[Country]
      ,UPRN.[UPRN]
      ,UPRN.[LastChangeDate]
      ,UPRN.[Is_Latest]
      ,UPRN.[Effective_From]
      ,UPRN.[Effective_To]
      ,UPRN.[Char_8_ASCII_Index]
      ,UPRN.[UDALFileID]
	  ,PCGEO.[Latitude_1m] AS [PC_Lat]
      ,PCGEO.[Longitude_1m] AS [PC_Lon]
  FROM [UKHD_ODS_API].[vwOrganisation_SCD_IsLatestEqualsOneWithRole] AS UPRN

  LEFT JOIN [UKHD_ODS].[Postcode_Grid_Refs_Eng_Wal_Sco_And_NI_SCD] AS PCGEO
  ON UPRN.[Postcode] = PCGEO.[Postcode_single_space_e_Gif]
  AND PCGEO.[Is_Latest] = 1

  WHERE UPRN.[Status] = 'Active'
  AND UPRN.[Role] LIKE 'OPTICAL SITE'