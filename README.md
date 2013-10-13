Orange6
=======

MSA Fall 2 Homework Group (Orange Team 6)

libname Survival 'c:\IAA\Survival Analysis';

/* Test if grouping 2 and 3 errors is a good idea using a chi square test*/
proc phreg data=survival.katrina_fail; /* Combined error model */
	model hour*reason = backup bridgecrane servo elevation slope age;
run;

proc phreg data=survival.katrina_fail; /* Model with just motor errors */
	model hour*reason(1,2,4) = backup bridgecrane servo elevation slope age;
run;

proc phreg data=survival.katrina_fail; /* Model with just surge errors */
	model hour*reason(1,3,4) = backup bridgecrane servo elevation slope age;
run;

proc phreg data=survival.katrina_fail; /* Model with combined surge and motor errors */
	model hour*reason(1,4) = backup bridgecrane servo elevation slope age;
run;

/* Create a new variable h0=0 in order to complete the array so that when you subtract 11 hours you still get a result. */
data survival.katrina;
	set survival.katrina;
	h0=0;
run;

/* Test if more likely to have motor failure if motor runs for 12 consecutive hours */
proc phreg data=survival.katrina;
	model hour*reason(0,1,3,4) = backup bridgecrane servo elevation slope age LongRun;
	array h(*) h0-h48;
		if h[hour]=1 and h[hour-1]=1 and h[hour-2]=1 and h[hour-3]=1 and h[hour-4]=1 and h[hour-5]=1 and h[hour-6]=1 
			and h[hour-7]=1 and h[hour-8]=1 and h[hour-9]=1 and h[hour-10]=1 and h[hour-11]=1 then LongRun=1;
		else LongRun=0;
run;

/* Chose a distribution for each model */
proc lifereg data=survival.katrina;
	model hour*reason(0,1,2,3)= backup bridgecrane servo trashrack elevation slope age / dist=exponential;
	*model hour*reason(0,1,2,3)=backup bridgecrane servo trashrack elevation slope age / dist=weibull;
	*model hour*reason(0,1,2,3)= backup bridgecrane servo trashrack elevation slope age / dist=lnormal;
	*model hour*reason(0,1,2,3)=backup bridgecrane servo trashrack elevation slope age / dist=gamma maxiter=100;
run;

/* Use Log Likelihood to select distribution */
data GOF;
	Exp = -276.1102613;
	Weib = -254.8219716;
	LNorm = -249.1662166;
	GGam = -249.1410014;
			
	LRT1 = -2*(Exp - GGam);
	LRT2 = -2*(Weib - GGam);
	LRT3 = -2*(LNorm - GGam);
			
	P_Value1 = 1 - probchi(LRT1,2);
	P_Value2 = 1 - probchi(LRT2,1);
	P_Value3 = 1 - probchi(LRT3,1);
run;

proc print data=GOF;
	var LRT1-LRT3 P_Value1-P_Value3;
run;

/* Build AFT models with selected distributions */
/* Flood model */
proc lifereg data=Survival.Katrina; 
	model Hour*reason(0,2,3,4) = backup servo slope /  dist=weibull;
run;

/* Motor model */
proc lifereg data=Survival.Katrina;
	model Hour*reason(0,1,3,4) = slope age  /  dist=gamma;
run;

/* Surge model */
proc lifereg data=Survival.Katrina;
	model Hour*reason(0,1,2,4) = age / dist=gamma;
run;

/* Jammed model */
proc lifereg data=Survival.Katrina;
	model Hour*reason(0,1,2,3) = elevation slope age /  dist=lnormal;
run;
