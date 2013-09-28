*Homework 1 - Time Series & Forecasting - Steve Neola - 092713;
libname time clear;
libname time 'C:\Users\sneola\Documents\Time Series & Forecasting\Homework';

proc import datafile="C:\Users\sneola\Documents\Time Series & Forecasting\Homework\HW1data.csv"
     out=fxdata
     dbms=csv
     replace;
     
run;


*Plot the data series (include the plot in your report) and 
describe any characteristics you notice about the series.;
title 'Foreign Exchange Data';
Proc sgplot data=work.fxdata; 
	series x=Date y=Value;
run;

*Plot the ACF, PACF, and IACF (include the plots in your report) and 
describe any characteristics/interpretations that you notice about these plots.;
proc arima data=work.fxdata plot(unpack)=all;
	identify var=value nlag=20;
	run;
	quit;

	proc arima data=work.fxdata plot(unpack)=all;
	identify var=value nlag=20 alpha=.01;
	run;
	quit;

*Check to see if the data itself is white noise using an official test. 
Create a plot that shows this characteristic and summarize what you find.;
	proc arima data=work.fxdata plot(unpack)=all;
	identify var=value nlag=20;
	estimate method=ML;
	run;
	quit;

*List the first two values (lags 1 and 2) of the autocorrelation function and 
	interpret their meaning.;

ods graphics off;
ods output AutoCorrGraph=work.fxdata
			PACFGraph=work.fxdata
			IACFGraph=work.fxdata;
proc arima data=work.fxdata plot(unpack)=all;
	identify var=value;
run;
quit
ods graphics on;
