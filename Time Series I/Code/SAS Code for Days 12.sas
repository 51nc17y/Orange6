/*-----------------------------*/
/* Introduction to Forecasting */
/*  and Time Series Structure  */
/*                             */
/*        Dr Aric LaBarr       */
/*       MSA Class of 2013     */
/*-----------------------------*/

/* Correlation Functions */

proc arima data=Time.AR2 plot(unpack)=all;
	identify var=y nlag=10;
run;
quit;

proc sgplot data=Time.USAirlines;
	series x=Date y=Passengers;
	title 'Southwest Airlines Stock Price';
run;

proc arima data=Time.USAirlines plot(unpack)=all;
	identify var=Passengers nlag=40;
run;
quit;


/* White Noise Tests */

proc arima data=Time.AR2 plot(unpack)=all;
	identify var=y nlag=10;
	estimate method=ML;
run;
quit;

proc arima data=Time.AR2 plot(unpack)=all;
	identify var=y nlag=10;
	estimate p=2 method=ML;
run;
quit;
