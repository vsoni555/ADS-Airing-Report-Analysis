--ALTER TABLE DW.ADS_AIRING
--DROP  COLUMN  Broadcast_month


alter table dw.ads_airing
add Duration_Hrs float(50) 


update dw.ads_airing
set Duration_hrs= Round((Duration/3600),2)

Alter table DW.ADS_AIRING
add  Broadcast_Month char(250)

update dw.Ads_Airing
set Quarter= Case when Date between '01/01/2021' AND'03/31/2021' THEN 'Q1'
WHEN Date between '04/01/2021' AND '06/30/2021' THEN 'Q2'
WHEN Broadcast_Month between '07/01/2021' AND '09/30/2021' THEN 'Q3'
ELSE 'Q4'
END 

update dw.Ads_Airing
set Broadcast_Month= Case when Date between '01/01/2021' AND'01/31/2021' THEN 'JAN'
WHEN Date between '02/01/2021' AND '02/28/2021' THEN 'FEB'
WHEN DATE between '03/01/2021' AND '03/31/2021' THEN 'MAR'
WHEN DATE between '04/01/2021' AND '04/30/2021' THEN 'APR'
WHEN DATE between '05/01/2021' AND '05/31/2021' THEN 'MAY'
WHEN DATE between '06/01/2021' AND '06/30/2021' THEN 'JUN'
WHEN DATE between '07/01/2021' AND '07/31/2021' THEN 'JUL'
WHEN DATE between '08/01/2021' AND '08/31/2021' THEN 'AUG'
WHEN DATE between '09/01/2021' AND '09/30/2021' THEN 'SEP'                        `	+	
WHEN DATE between '10/01/2021' AND '10/31/2021' THEN 'OCT'
WHEN DATE between '11/01/2021' AND '11/30/2021' THEN 'NOV'
WHEN DATE between '12/01/2021' AND '12/31/2021' THEN 'DEC'
END 



--Check

SELECT   DISTINCT DATE , Broadcast_Month, Quarter FROM DW.Ads_Airing
WHERE Broadcast_Month='DEC'
ORDER BY 1


--Correct
update dw.Ads_Airing
set quarter = 'Q3'
WHERE cast(date as date) between '07/01/2021' AND '09/30/2021'


update dw.Ads_Airing
set Broadcast_Year=2021 where 
Broadcast_Year=2022



--What is Pod Position? Does the Pod position number affect the amount spent on Ads for a specific period of time by a company? 


SELECT * FROM 
(
SELECT BRAND , Pod_Position, [Spend ]   FROM DW.Ads_Airing

) A 
pivot 
( SUM ([Spend ])    for Pod_Position IN ([1]
,[2]
,[3]
,[4]
,[5]
,[6]
,[7]
,[8]
,[9]
,[10]
,[11]
,[12]
,[13]
,[14]
,[15]
,[16]
,[17]
,[18]
,[19]
,[20]
,[21]
,[22]
,[23]
,[24]
,[25]
,[26]
,[27]
,[28]
,[29]
,[30]
,[31]
)
) b 
order by 1,2


--What is the share of various brands in TV airings and how has it changed from Q1 to Q4 in 2021?

SELECT  Brand, Round(cast(count(id) *100 as float ) / sum(count(ID))   OVER (), 2) as 'Percentage'
FROM  dw.Ads_Airing
where  Quarter='Q4'
GROUP BY Brand 
order by 1


--Total  Quarterly Spend Shares by Companies in a Year



select * from 
(
Select  distinct BRAND,sum([Spend]) OVER (PARTITION BY BRAND) / sum([spend]) over () as Share  from dw.Ads_Airing
where quarter='Q4'

) a 
order by 1


--Conduct a competitive analysis for the brands and define advertisement strategy of different brands and how it differs across the brands. 


-- Duration Ads Aired on DayParts 
select * from 
(
Select  brand, [Duration_Hrs] , Dayparts  from dw.Ads_Airing


) a 
pivot
(
sum ([Duration_Hrs])   for dayparts in ([WEEKEND] , [EARLY FRINGE], [EARLY MORNING], [EVENING NEWS], 
[LATE FRINGE], [OVERNIGHT],[PRIME ACCESS],

[PRIME TIME], [DAYTIME])
 )B


 -- All Key Metrics 
 select  a.*, sum([Total Ads Per Product]) over ( partition by brand) as [Total Ads Per Brand]
 from 
 (
 select  Brand, Product, count(id) as [Total Ads Per Product], round( sum(EQ_Units), 1)  TotaSales , 
 sum(spend) as TotalSpend from dw.Ads_Airing
 group by  brand, product

 )a
 
 -- Duration of the Ads Per Pod Poisition in Hours

 SELECT * FROM 
(
SELECT   Brand,  Pod_Position, Duration_hrs   FROM DW.Ads_Airing

) A 
pivot 
( 
SUM(Duration_hrs)     for Pod_Position IN ([1]
,[2]
,[3]
,[4]
,[5]
,[6]
,[7]
,[8]
,[9]
,[10]

)
) b 




-- Profit Yield Per Brand 


select  Brand,[Total Sales],[Total Spend], [Total Ads],[Total Sales]/[Total Ads] AS [Profit Yield] ,
Round([Total Sales]/[Total Spend],4) AS [Spend Yield]
 from 
 (
 select  Brand,  count(id) as [Total Ads], round( sum(EQ_Units), 1)  [Total Sales] ,Sum ([Spend ]) as [Total Spend]
 from dw.Ads_Airing
 GROUP BY Brand

 ) A 
  order by 2 desc
  
  
  
  
  -- By Network Type 


  Select Brand,  Network_Type , count(id) as Ads from dw.ads_airing
  group by brand, Network_Type
  order  by Brand , 3
  
  
  
  
  --Mahindra and Mahindra wants to run a digital ad campaign to complement its existing TV ads in Q1 of 2022.
  --Based on the data from 2021, suggest a media plan to the CMO of Mahindra and Mahindra. Which audience should they target? 
  --*Assume XYZ Ads has the ad viewership data and TV viewership for the people in India. 
  
  
  
  
  --Profit Yeild
  select * from 
(
Select Brand, ROUND(sum([EQ_Units])  / sum([Spend ]), 5) as Profit_Yield  from dw.Ads_Airing
where quarter='Q4' and Brand ='Mahindra and Mahindra'
group by BRand

) a 
order by 1

  
  
  
  
  
  
  
   -- Duration of the Ads Per Pod Poisition in Hours

 SELECT * FROM 
(
SELECT   Brand,  qUARTER, Duration_hrs   FROM DW.Ads_Airing
where Brand ='Mahindra and Mahindra'

) A 
pivot 
( 
SUM(Duration_hrs)     for qUARTER IN ([Q1]
,[Q2]
,[Q3]
,[Q4]

)
) b 

  
  
   SELECT * FROM 
(
SELECT   Brand,  qUARTER, [SPEND]   FROM DW.Ads_Airing
where Brand ='Mahindra and Mahindra'

) A 
pivot 
( 
SUM([SPEND])     for qUARTER IN ([Q1]
,[Q2]
,[Q3]
,[Q4]

)
) b 

  
  
  -- Duration Ads Aired on DayParts 
select * from 
(
Select  brand, [Duration_Hrs] , Dayparts  from dw.Ads_Airing
where Brand ='Mahindra and Mahindra' and quarter='Q4'

) a 
pivot
(
sum ([Duration_Hrs])   for dayparts in ([WEEKEND] , [EARLY FRINGE], [EARLY MORNING], [EVENING NEWS], 
[LATE FRINGE], [OVERNIGHT],[PRIME ACCESS],

[PRIME TIME], [DAYTIME])
 )B

  
  
  
  
  
  
  -- By product 

  Select Brand, Product , count(id) as Ads from dw.ads_airing
 where  Brand ='Mahindra and Mahindra'
  group by brand, Product
  order  by Brand , 3
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  






































































































































































