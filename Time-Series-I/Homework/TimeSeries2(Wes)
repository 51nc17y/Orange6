Orange6
=======

MSA Fall 2 Homework Group (Orange Team 6)

libname time 'c:\iaa\time series';

/* Create Holdout Set */
data time.telecom_hold;
	set time.telecom;
	where date > mdy(9,10,2009);
run;

/* Delete Holdout Set from Original */
data time.telecom_train;
	set time.telecom;
	if date > mdy(9,10,2009) then delete;
run;

/* Create time series and all autocorrelation plots */
proc arima data=time.telecom_train plot=all;
	identify var=Sales_NA nlag=30; 
	estimate p=2 method=ml;
	forecast lead=16;

	*identify var=Sales_E nlag=30;
	*estimate q=1 method=ml;
	*forecast lead=16;

	*identify var=Sales_A nlag=30;	
	*estimate p=2 q=2  method=ml;
	*forecast lead=16;
run;
quit;

/* Throw the model at the full data set to predict the next 12 observations */
proc arima data=time.telecom plot=all;
	identify var=Sales_NA nlag=30; 
	estimate p=2 method=ml;
	forecast lead=12;

	*identify var=Sales_E nlag=30;
	*estimate q=1 method=ml;
	*forecast lead=12;

	*identify var=Sales_A nlag=30;	
	*estimate p=2 q=2  method=ml;
	*forecast lead=12;
run;
quit;
