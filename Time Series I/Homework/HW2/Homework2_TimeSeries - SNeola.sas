* Homework 2 - Time Series - Steve Neola - 10-3-13;
libname _all_ clear ;
libname forecast "C:\Users\sneola\Documents\Time Series & Forecasting\Homework";

*Import this data into SAS. Take out the last 16 observations and save them for a validation set.;

proc import datafile="C:\Users\sneola\Documents\Time Series & Forecasting\Homework\HW2data.csv"
     out=salesdata
     dbms=csv
     replace;
run;

data salesdata_train;
	set salesdata (obs=244);
run;

data salesdata_val;
	set salesdata (firstobs=245);
run;

*Plot the data, the ACF, PACF, and the IACF.
describe what characteristics you see from all the plots (attach the plots to the report as well).;

*Sales_NA;
proc arima data=salesdata_train;
	identify var=Sales_NA nlags=30;
	run;
	quit;

*Sales_E;
	proc arima data=salesdata_train;
	identify var=Sales_E nlags=50;
	run;
	quit;
*Sales_A;
	proc arima data=salesdata_train;
	identify var=Sales_A nlags=25;
	run;
	quit;

*Try to identify the appropriate models to use for the three regions. 
	Use plotting patterns and automatic selection techniques to select a few models to try.;
*Sales_NA;
proc arima data=salesdata_train;
	identify var=Sales_NA nlags=22 minic scan esacf P=(0:22) Q=(0:22);
run;
quit;

*Sales_E;
proc arima data=salesdata_train;
	identify var=Sales_E nlags=50 minic scan esacf P=(0:50) Q=(0:50);
run;
quit;

*Sales_A;
proc arima data=salesdata_train;
	identify var=Sales_A nlags=25 minic scan esacf P=(0:25) Q=(0:25);
run;
quit;


*Check the white noise plots to see if the residuals are just white noise for each of your models. 
*Sales_NA ;
proc arima data=salesdata_train;
	identify var=Sales_NA nlags=30;
	estimate p=1 q=2 method=ML;
	estimate p=2 q=0 method=ML;
	run;
	quit;
*Sales_E;
	proc arima data=salesdata_train;
	identify var=Sales_E nlags=50;
	*estimate p=1 q=2 method=ML;
	*estimate p=5 q=5 method=ML;
	run;
	quit;

*Sales_A;
	*Insert;

*Use your model to forecast the next 16 observations. 
Compare these 16 observations to your validation data set. 
How well do you feel you model did using MAPE? ;

*Sales_NA;
proc arima data=salesdata_train;
	identify var=Sales_NA nlags=30;
	estimate p=1 q=2 method=ML;
	forecast lead=16 out=Forecast_NA;
	run;
	quit;


data MAPE_NA;
	merge Forecast_NA (firstobs=244) salesdata_val;
	Residual = sales_na - forecast;
	mape_res = 100 * (abs(residual) / sales_na);
	*mape_res + final = 1/16 * sum(mape_res);
run;

proc sql;
	select avg(mape_res)
		from MAPE_NA;
quit;

*After selecting your final model, put in the 16 observations from your validation set 
and use the model you selected previously to forecast the first 12 observations of 2010.;

*Sales_NA;

proc arima data=salesdata;
	identify var=Sales_NA nlags=30;
	estimate p=1 q=2 method=ML;
	forecast lead=12;
	run;
	quit;

*Sales_E;
	*Insert;
*Sales_A;
	*Insert;
