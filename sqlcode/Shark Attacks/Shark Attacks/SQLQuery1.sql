--p6400 sheet 1-GSAF a1
use kubrick
go
create schema staging

select
*
from staging.GSAF
where try_cast([Date] as date) is null

select
	*
from staging.GSAF
where try_cast(replace([Date],'Reported ','') as date) is null


select
	try_cast(replace([Date],'Reported ','') as date) clean_date
	,*
from staging.GSAF


select
	case
		when isnumeric(left(replace(replace([Date],'Reported ',''),'.',''),2)) = 0 
		then try_cast('01-' + replace(replace([Date],'Reported ',''),'.','') as date)
	else try_cast(replace(replace([Date],'Reported ',''),'.','') as date)
	end
	,*
from staging.GSAF

select
	distinct [Fatal (Y/N)]
from staging.GSAF

select
	distinct [Fatal (Y/N)]
	,count(*) rowcoun
from staging.GSAF
group by [Fatal (Y/N)]

select * from staging.GSAF where [Fatal (Y/N)] = 'M'


select
	distinct 
		case
			when [Fatal (Y/N)]='M'
			then replace([Fatal (Y/N)],'M','N')

			when [Fatal (Y/N)] is null
			then 'UNKNOWN'

			else ltrim([Fatal (Y/N)])
		end clean_fatal
		,count(*)
from staging.GSAF
group by [Fatal (Y/N)]

--lawrence solution
select
	REPLACE(LTRIM(isnull([fatal (Y/N)],'UNKNOWN')),'M','N')
	,count(*) rowcoun
from staging.GSAF
group by (REPLACE(LTRIM(isnull([fatal (Y/N)],'UNKNOWN')),'M','N'))


--final

if object_id ('dbo.shark_attack')is not null
begin
	drop table dbo.shark_attack
end

declare @avgage tinyint
select @avgage = avg(try_cast(age as tinyint)) from staging.GSAF

select
	case
		when isnumeric(left(replace(replace([Date],'Reported ',''),'.',''),2))=0
		then try_cast('01-'+replace(replace([Date],'Reported ',''),'.','') as date)
	else try_cast(replace(replace([Date],'Reported ',''),'.','')as date)
	end clean_date
	,REPLACE(LTRIM(isnull([fatal (Y/N)], 'UNKNOWN')),'M','N')[Is Fatal]
	,country
	,activity
	,[sex] sex
	,isnull(try_cast(age as tinyint), @avgage) age
into dbo.shark_attack
from staging.GSAF
where try_cast(
	case
		when isnumeric(left(replace(replace([Date],'Reported ',''),'.',''),2))=0
		then try_cast('01-'+replace(replace([Date],'Reported',''),'.','')as date)
	else try_cast(replace(replace([Date],'Reported ',''),'.','') as date)
end as date) is not null

SELECT
	clean


----

USE [kubrick]
GO

SELECT DATENAME(qq,[clean_date]) as quart
      ,datename(mm,[clean_date]) as mnth
	  ,datename(yy,[clean_date]) as yr
	  ,datename(dw,[clean_date]) as wkday
	  ,[clean_date]
	  ,[clean_date]
	  ,[Is Fatal]
      ,[country]
      ,[activity]
      ,[sex]
      ,[age]
  FROM [dbo].[shark_attack]
GO
		