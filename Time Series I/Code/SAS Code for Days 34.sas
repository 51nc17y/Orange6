/*-----------------------------*/
/*      Stationary Models      */
/*                             */
/*        Dr Aric LaBarr       */
/*       MSA Class of 2013     */
/*-----------------------------*/

/* Building an Autoregressive Model */

proc arima data=Time.AR2 plot=all;
	identify var=y nlag=10;
	estimate p=2 method=ML;
run;
quit;

proc arima data=Time.USAirlines plot=all;
	identify var=Passengers nlag=40;
	estimate p=1 method=ML maxiter=100;
	estimate p=6 method=ML maxiter=100;
	estimate p=(6) method=ML maxiter=100;
	estimate p=(1,2,3,6) method=ML maxiter=100;
run;
quit;


/* Building a Moving Average Model */

proc arima data=Time.SimMA1 plot=all;
	identify var=Y nlag=12;
	estimate q=1 method=ML;
run;
quit;

proc arima data=Time.AR2 plot=all;
	identify var=y nlag=10;
	estimate q=2 method=ML;
run;
quit;


/* Building an Autoregressive Moving Average Model */

proc arima data=Time.SimARMA plot=all;
	identify var=Y nlag=12;
	estimate p=1 q=1 method=ML;
run;
quit;

proc arima data=Time.USAirlines plot=all;
	identify var=Passengers nlag=40;
	estimate p=1 q=1 method=ML;
	estimate p=(2,3,6,12) q=1 method=ML;
run;
quit;


/* Model Identification */

proc arima data=Time.Hurricanes plot(unpack);
	identify var=MeanVMax nlag=12 minic scan esacf P=(0:12) Q=(0:12);
run;
quit;


/* Forecasting */

proc arima data=Time.Hurricanes plot(unpack)=forecast(all);
	identify var=MeanVMax nlag=12 minic scan esacf P=(0:12) Q=(0:12);
	estimate p=2 q=3;
	forecast lead=12;
run;
quit;
