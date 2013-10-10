*********************************************************************
*					DEFINE YOUR PROJECT DATA PATH					*
*********************************************************************;

%let path=C:\Users\Phill\Documents\GitHub\Orange6\Time Series I\Project\data;

libname electric "&path";

*********************************************************************
*					CREATE ELECTRIC LOAD DATA						*
*********************************************************************;

PROC IMPORT OUT= WORK.Load_2011 DATAFILE= "&path\Electric Load.xlsx" 
            DBMS=xlsx REPLACE;
     SHEET="2011"; 
     GETNAMES=YES;
RUN;

PROC IMPORT OUT= WORK.Load_2012 DATAFILE= "&path\Electric Load.xlsx" 
            DBMS=xlsx REPLACE;
     SHEET="2012"; 
     GETNAMES=YES;
RUN;

PROC IMPORT OUT= WORK.Load_2013 DATAFILE= "&path\Electric Load.xlsx" 
            DBMS=xlsx REPLACE;
     SHEET="2013"; 
     GETNAMES=YES;
RUN;

DATA Electric.Load_Data; 
	set Load_2011 Load_2012 Load_2013; 
run; 

*********************************************************************
*					CREATE TEMPERATURE DATA							*
*********************************************************************;

%macro loop; 
%do i = 11 %to 13; 
%do j = 1 %to 12; 
    %let year = &i; 
    %let month = %sysfunc(putn(&j, z2.));
    data _&year&month ;
        length Date 5 _Time $4 Time 8 Month $3 Day $2 Year $4 temp 3; 
          format Date DATE9.; 
        infile "&path\hr_pit_&year..&month..txt" firstobs=27;  

    input _time $ Month $ 10-13 Day Year temp 32-34; 
    _time = right(_time);
    Date = input(Day||Month||Year, date9.);
    if _time = '12AM' or (_time ne '12PM' and index(_time, 'PM') > 1 )
            then time=input(_time, 2.) + 12;
    else time=input(_time, 2.);
    time = time * 100;
    drop month day year;
run; 
     /* gather all data in one table */
    proc append base=work.all_data data=work._&year&month;
    run;
%end; 
%end; 
%mend; 

%loop; 

proc sql;
create table electric.temp_data as
	select Date, Time, Temp
	from work.all_data; 
drop table work.all_data;
create table electric.master as
	select temp_data.Date, temp_data.Time as Hour, Load_Data.DUQ, temp_data.Temp
	from electric.temp_data, electric.load_data
	where temp_data.Date = load_data.day and temp_data.time = load_data.hour
	order by temp_data.date desc, temp_data.time desc;
drop table electric.temp_data, electric.load_data; 
quit;

data Electric.Master; 
	set Electric.Master;

	if weekday(date) in(1, 7) then Weekend = 1; 
	else Weekend = 0; 

	if hour = '100' then AM01 = 1; else AM01 = 0;
	if hour = '200' then AM02 = 1; else AM02 = 0;
	if hour = '300' then AM03 = 1; else AM03 = 0;
	if hour = '400' then AM04 = 1; else AM04 = 0;
	if hour = '500' then AM05 = 1; else AM05 = 0;
	if hour = '600' then AM06 = 1; else AM06 = 0;
	if hour = '700' then AM07 = 1; else AM07 = 0;
	if hour = '800' then AM08 = 1; else AM08 = 0;
	if hour = '900' then AM09 = 1; else AM09 = 0;
	if hour = '1000' then AM10 = 1; else AM10 = 0;
	if hour = '1100' then AM11 = 1; else AM11 = 0;
	if hour = '1200' then PM12 = 1; else PM12 = 0;
	if hour = '1300' then PM01 = 1; else PM01 = 0;
	if hour = '1400' then PM02 = 1; else PM02 = 0;
	if hour = '1500' then PM03 = 1; else PM03 = 0;
	if hour = '1600' then PM04 = 1; else PM04 = 0;
	if hour = '1700' then PM05 = 1; else PM05 = 0;
	if hour = '1800' then PM06 = 1; else PM06 = 0;
	if hour = '1900' then PM07 = 1; else PM07 = 0;
	if hour = '2000' then PM08 = 1; else PM08 = 0; 
 	if hour = '2100' then PM09 = 1; else PM09 = 0;
	if hour = '2200' then PM10 = 1; else PM10 = 0;
	if hour = '2300' then PM11 = 1; else PM11 = 0;
	if hour = '2400' then AM12 = 1; else AM12 = 0;	
run; 

proc sql; 
	create table Electric.Train as 
		select 	*
		from 	Electric.Master
		where 	Date<19624;
	create table Electric.Val as
		select 	*
		from 	Electric.Master
		where	Date>=19624; 
quit;  
