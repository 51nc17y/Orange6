
/*First we just do a simple survival curve so we can remember the data with which we are working*/
proc lifetest data=survival.katrina alpha=0.03;
	*where reason2=1;
	time hour;
run;
/*Next we specify the censored observations as 0, 2, 3, and 4 as indicated in the homework*/
proc lifetest data=survival.katrina alpha=0.03;
	*where reason2=1;
	time hour*reason(0,2,3,4);
run;




/*Now we add the S, LS, and LLS plot options as specified in the homework*/
proc lifetest data=survival.katrina method=life alpha=0.03 plots=(S,LS,LLS) outsurv=Pred_Surv width=1;
	*where reason2=1;
	time hour*reason(0,2,3,4);
run;

/*Now we build an AFT model with PROC LIFEREG,with the following variables:
  backup, bridgecrane, servo, trashrack, elevation, slope, and age*/
/*We also fit one model using the lognormal, weibull, and gamma distributions in order to determine the correct distribution*/

proc lifereg data=survival.katrina outest=beta1;
	model hour*reason(0,2,3,4) = backup bridgecrane servo trashrack elevation slope age /dist=exponential;
	title 'Testing for Lognormal distribution';
run;
	 
proc lifereg data=survival.katrina outest=beta1;
	model hour*reason(0,2,3,4) = backup bridgecrane servo trashrack elevation slope age /dist=lnormal;
	title 'Testing for Lognormal distribution';
run;
proc lifereg data=survival.katrina outest=beta2;
	model hour*reason(0,2,3,4) = backup bridgecrane servo trashrack elevation slope age /dist=weibull;
	title 'Testing for Weibull distribution';
run;

proc lifereg data=survival.katrina outest=beta3;
	model hour*reason(0,2,3,4) = backup bridgecrane servo trashrack elevation slope age /dist=gamma maxiter=100;
	title 'Testing for Gamma distribution';
run;



data GOF;
Exponential=-312.7401776; 
Lnormal=-308.0054322;
Weibull=-304.2308704;
GGamma=-304.0876426;

LRT1=-2*(Exponential - GGamma);
LRT2=-2*(Weibull - GGamma);
LRT3=-2*(Lnormal-Ggamma);

P_Value1= 1-probchi(LRT1,2);    /*P value for exponential*/
P_Value2=1-probchi(LRT2,1);     /*P value for Weibull*/
P_Value3=1-probchi(LRT3,1);     /*P value for Lognormal*/

proc print data=GOF;
title 'Goodness of Fit Data';
run;

/*Now that we have determined that Weibull is the correct distribution, we rerun the lifereg weibull to test for significant variables*/

proc lifereg data=survival.katrina outest=beta2;
	model hour*reason(0,2,3,4) = backup servo slope /dist=weibull;
	title 'Testing for Significant Variables with the Weibull distribution';
run;

/*By eliminating non significant variables one by one, we eventually reach this model that has three significant variables, which is what LaBarr said when I asked him in his office.
  I did this two times (see above) and got the same results*/
proc lifereg data=survival.katrina outest=beta2;
	model hour*reason(0,2,3,4) = backup servo slope /dist=weibull;
	title 'Final Model of Significant Variables';
run;


/*Try and upgrade servo and backup since those are the variables we have control over*/

proc means data=survival.katrina;
where reason=2;
var hour;
run;


libname survive "C:\Users\Marc\Documents\Analytics NC State\Survival Analysis";

/* Create survival curve censoring all but the flood errors */
proc lifetest data=survive.katrina method=life width=1 plots=h OUTSURV=survive.katrina_hazard;
	time hour*reason(0,2,3,4);
run;

/* Create new variables for the log of the survival likelihood and log of time and graph them */
data survive.katrina_hazard;
	set survive.katrina_hazard;
	survive_log=-log(Survival);
	survive_log2=log(-log(Survival));
	time_log=log(hour);
	label hour='Time in Hours';
	label survive_log='Log of Survival Likelihood';
	label survive_log2='Log Log of Survival Likelihood';
	label time_log='Log of Time';
run;

proc gplot survive.katrina_hazard;
	plot survive_log*hour;
	plot survive_log2*time_log;
run;
