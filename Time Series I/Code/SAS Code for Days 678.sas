/*-----------------------------*/
/*     Non-Stationary Models   */
/*                             */
/*        Dr Aric LaBarr       */
/*       MSA Class of 2013     */
/*-----------------------------*/

/* Linear Trend */

libname Time 'C:\Users\Phill\Documents\GitHub\Orange6\Time Series I\Data';

data Time.Leadyear;
	set Time.Leadyear end=eof;
	Time+1;
	output;
	if (eof) then do future = 1 to 20;
		Primary = .;
		Secondary = .;
		Total = .;
		Time+1;
		Date = intnx("year",Date,1);
		output;
	end;
	drop future;
run;
run;

proc arima data=Time.Leadyear plot=all;
	identify var=Primary nlag=12 crosscorr=Time;
	estimate Input=Time;
run;
quit;


/* Linear Trend + Residual Pattern */

proc arima data=Time.Leadyear plot=all;
	identify var=Primary nlag=12 crosscorr=Time;
	estimate Input=Time p=2;
run;
quit;


/* Stochastic Trend - Differencing */

proc arima data=Time.Leadyear plot=all;
	identify var=Primary(1) nlag=12;
run;
quit;

proc arima data=Time.Leadyear plot=all;
	identify var=Primary(1) nlag=12;
	estimate q=1 method=ML;
	forecast lead=20;
run;
quit;


/* Stochastic Trend - Seasonal Differencing */

proc arima data=Time.USAirlines plot=all;
	identify var=Passengers nlag=40;
	identify var=Passengers(12) nlag=40;
	identify var=Passengers(1 12) nlag=40;
run;
quit;


/* Augmented Dickey-Fuller Testing */

proc arima data=Time.Ebay9899 plot=all;
	identify var=DailyHigh nlag=10 stationarity=(adf=2);
	identify var=DailyHigh(1) nlag=10 stationarity=(adf=2);
run;
quit;


/* Seasonal Augmented Dickey-Fuller Testing */

proc arima data=Time.USA_TX_NOAA plot=all;
	identify var=Temperature nlag=60 stationarity=(adf=2 dlag=12);
	identify var=Temperature(12) stationarity=(adf=2);
run;
quit;

proc arima data=Time.USA_TX_NOAA(where=('01JAN1994'd <= Date <= '01JAN2009'd)) plot=all;
	identify var=Temperature nlag=60 stationarity=(adf=2 dlag=12);
	identify var=Temperature(12) stationarity=(adf=2);
run;
quit;
