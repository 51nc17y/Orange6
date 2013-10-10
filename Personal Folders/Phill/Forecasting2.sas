proc import datafile='C:\Users\Phill\Documents\GitHub\Orange6\Time Series I\Homework\HW2\HW2data.csv' 
			out  = HW2data
			dbms = csv 
			REPLACE; 
run; 

proc sort data=hw2data; 
	by Date; 
run; 

proc sql; 
	create table  hw2val as
		select *
		from hw2data
		where date>18144;
quit; 

proc sql; 
	create table  hw2 as
		select *
		from hw2data
		where date<=18144;
quit; 

title 'Sales_NA'; 
proc arima data=hw2 plot=all;
	identify var = sales_na minic scan esacf ;
	estimate p=2 q=0 method=ML;
	forecast lead = 16 interval=week ID=date out=hw2_NA;  
run; quit;  

title 'Sales_E'; 
proc arima data=hw2 plot=all;
	identify var = sales_E minic scan esacf;
	estimate q=1 method=ML;
	forecast lead = 16 interval=week ID=date out=hw2_E;  
run; quit;  

title 'Sales_A'; 
proc arima data=hw2 plot=all;
	identify var = sales_A minic scan esacf;
	estimate p=(1) q=(2,3) method=ML; 
	forecast lead = 16 interval=week ID=date out=hw2_A; 
run; quit;  

title 'Sales_North America 12 week Forecast'; 
proc arima data=hw2data plot=all;
	identify var = sales_na;
	estimate p=2 q=0 method=ML;
	forecast lead = 16 interval=week ID=date out=hw2_NA;  
run; quit;  

title 'Sales_Europe 12 week Forecast'; 
proc arima data=hw2data plot=all;
	identify var = sales_E;
	estimate q=1 method=ML;
	forecast lead = 12 interval=week ID=date out=hw2_E;  
run; quit;  

title 'Sales_Asia 12 week Forecast'; 
proc arima data=hw2data plot=all;
	identify var = sales_A;
	estimate p=(1) q=(2,3) method=ML; 
	forecast lead = 12 interval=week ID=date out=hw2_A; 
run; quit;  
 
