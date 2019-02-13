/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.2002)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [ClientHealth]
GO
/****** Object:  StoredProcedure [dbo].[up_get_OS_Summary_data]    Script Date: 2/13/2019 8:34:18 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_OS_Summary_data]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_flat]    Script Date: 2/13/2019 8:34:18 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_ClientData_flat]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_ActionResult]    Script Date: 2/13/2019 8:34:18 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_ClientData_ActionResult]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_ActionResult]    Script Date: 2/13/2019 8:34:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_ClientData_ActionResult      ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for Action Result (SUM) Data     ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/13/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_ClientData_ActionResult]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --

    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')

	begin
		Select 'ClientCertificate' as 'Component_Name',
			sum(case when ClientCertificate = 'OK' then 1 else 0 end) as Component_Count_OK, 
			sum(case when ClientCertificate <> 'OK' then 1 else 0 end) as Component_Count_ERROR 
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter
		
		union 
		Select 'ProvisioningMode' as 'Component_Name', 
			sum(case when ProvisioningMode = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when ProvisioningMode <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'DNS' as 'Component_Name',
			sum(case when DNS = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when DNS <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'Drivers' as 'Component_Name', 
			sum(case when Drivers = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Drivers <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'PendingReboot' as 'Component_Name', 
			sum(case when PendingReboot = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when PendingReboot <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'Services' as 'Component_Name', 
			sum(case when Services = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Services <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'AdminShare' as 'Component_Name', 
			sum(case when AdminShare = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when AdminShare <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union
		Select 'StateMessages' as 'Component_Name',
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 
	
		union 
		Select 'WUAHandler' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'WMI' as 'Component_Name', 
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'BITS' as 'Component_Name',
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		order by Component_Name  
	end

	-- query for all data
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 

		Select 'ClientCertificate' as 'Component_Name', 
			sum(case when ClientCertificate = 'OK' then 1 else 0 end) as Component_Count_OK, 
			sum(case when ClientCertificate <> 'OK' then 1 else 0 end) as Component_Count_ERROR 
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter

		union 
		Select 'ProvisioningMode' as 'Component_Name', 
			sum(case when ProvisioningMode = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when ProvisioningMode <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'DNS' as 'Component_Name', 
			sum(case when DNS = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when DNS <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'Drivers' as 'Component_Name', 
			sum(case when Drivers = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Drivers <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'PendingReboot' as 'Component_Name',
			sum(case when PendingReboot = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when PendingReboot <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'Services' as 'Component_Name', 
			sum(case when Services = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Services <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'AdminShare' as 'Component_Name', 
			sum(case when AdminShare = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when AdminShare <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union
		Select 'StateMessages' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 
	
		union 
		Select 'WUAHandler' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'WMI' as 'Component_Name', 
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'BITS' as 'Component_Name',
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 
		order by Component_Name
	end
end 
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_flat]    Script Date: 2/13/2019 8:34:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_ClientData_flat              ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for OS Summary Data              ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/09/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_ClientData_flat]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --
    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')
	-- check @UseHistorydate
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 
		-- select all data from actual and historie togehter 
		select * from [dbo].[v_ClientData_ALL] 
		where Timestamp > @DateFilter
		order by hostname, Timestamp desc 
	end
	if @UseHistorydate = 0
	begin
		-- select only data from actual
		select * from [dbo].[v_ClientData_Actual]
		where Timestamp > @DateFilter
		order by hostname, Timestamp desc 
	end
end
GO
/****** Object:  StoredProcedure [dbo].[up_get_OS_Summary_data]    Script Date: 2/13/2019 8:34:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_OS_Summary_data              ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for OS Summary Data              ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/06/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_OS_Summary_data]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --
    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')
	-- check @UseHistorydate
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 
	end

	SELECT [OperatingSystem],
		Count (HOSTNAME) as TotalCount,
		SUM(Case when ClientCertificate = 'OK' then 1 else 0 end ) as ClientCertificate_OK,
		SUM(Case when ClientCertificate <> 'OK' then 1 else 0 end ) as ClientCertificate_Error, 
		SUM(Case when ClientVersion = @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Actual, 
		SUM(Case when ClientVersion > @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Newer, 
		SUM(Case when ClientVersion < @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Older, 
		SUM(Case when ProvisioningMode = 'OK' then 1 else 0 end ) as ProvisioningMode_OK,
		SUM(Case when ProvisioningMode <> 'OK' then 1 else 0 end ) as ProvisioningMode_Error,
		SUM(Case when DNS = 'OK' then 1 else 0 end ) as DNS_OK,
		SUM(Case when DNS <> 'OK' then 1 else 0 end ) as DNS_Error,
		SUM(Case when Drivers  = 'OK' then 1 else 0 end ) as Drivers_OK,
		SUM(Case when Drivers <> 'OK' then 1 else 0 end ) as Drivers_Error,
		SUM(Case when PendingReboot   = 'OK' then 1 else 0 end ) as PendingReboot_OK,
		SUM(Case when PendingReboot <> 'OK' then 1 else 0 end ) as PendingReboot_Error,
		SUM(Case when Services = 'OK' then 1 else 0 end ) as Services_OK,
		SUM(Case when Services <> 'OK' then 1 else 0 end ) as Services_Error,
		SUM(Case when AdminShare = 'OK' then 1 else 0 end ) as AdminShare_OK,
		SUM(Case when AdminShare <> 'OK' then 1 else 0 end ) as AdminShare_Error,
		SUM(Case when StateMessages = 'OK' then 1 else 0 end ) as StateMessages_OK,
		SUM(Case when StateMessages <> 'OK' then 1 else 0 end ) as StateMessages_Error,
		SUM(Case when WUAHandler = 'OK' then 1 else 0 end ) as WUAHandler_OK,
		SUM(Case when WUAHandler <> 'OK' then 1 else 0 end ) as WUAHandler_Error,
		SUM(Case when WMI = 'OK' then 1 else 0 end ) as WMI_OK,
		SUM(Case when WMI <> 'OK' then 1 else 0 end ) as WMI_Error,
		SUM(Case when BITS = 'OK' then 1 else 0 end ) as BITS_OK,
		SUM(Case when BITS <> 'OK' then 1 else 0 end ) as BITS_Error
	FROM [ClientHealth].[dbo].[Clients] 
	where Timestamp > @DateFilter
	group by [OperatingSystem]
END
GO
