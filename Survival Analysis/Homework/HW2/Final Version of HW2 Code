
libname Survive 'C:\Users\Marc\Documents\Analytics NC State\Survival Analysis';

/* Create train and validation data sets - DO WE NEED TO DO THIS*/
data Survive.Katrina_Train (drop=TrainData) Survive.Katrina_Valid (drop=TrainData); 
	set Survive.Katrina;
	Train_Pct=0.80;
	Rand=ranuni(12345);
	drop Rand Train_Pct;
	If rand le Train_Pct then do;
			TrainData=1;
			output survive.katrina_train;
		end;
	else do;
			TrainData=0;
			output survive.katrina_valid;
		end;
run;

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

/*  Build AFT models to find the Log Likelihood for each distribution */
proc lifereg data=survive.katrina_train;
	model hour*reason(0,2,3,4)= backup bridgecrane servo trashrack elevation slope age / dist=exponential;
	*model hour*reason(0,2,3,4)=backup bridgecrane servo trashrack elevation slope age / dist=weibull;
	*model hour*reason(0,2,3,4)= backup bridgecrane servo trashrack elevation slope age / dist=lnormal;
	*model hour*reason(0,2,3,4)=backup bridgecrane servo trashrack elevation slope age / dist=gamma maxiter=100;
run;

/* Use Log Likelihood to select distribution */
data GOF;
	Exp = -312.7402;
	Weib = -304.2309;
	LNorm = -308.0054;
	GGam = -304.0876;
			
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
 
/*  Check choice of distribution with the validation data set to compare Weibull to Gamma */
proc lifereg data=survive.katrina_valid;
	*model hour*reason(0,2,3,4)=backup bridgecrane servo trashrack elevation slope age / dist=weibull;
	model hour*reason(0,2,3,4)=backup bridgecrane servo trashrack elevation slope age / dist=gamma maxiter=100;
run;

data GOF2;
	Weib = -65.6329;
	GGam = -62.6979;
			
	LRT1 = -2*(Weib - GGam);
			
	P_Value1 = 1 - probchi(LRT1,2);
run;
		
proc print data=GOF2;
	var LRT1 P_Value1;
run;

/* After selecting Weibull as the best distribution, servo, slope, and backup are the signicant variables */
proc  lifereg data=survive.katrina outest=Beta;
	model hour*reason(0,2,3,4)= servo slope backup / dist=weibull;
run;

/* Create macro variables for coefficients to be used in calculations */ 
data _null_; 
 set Beta; 
 call symput('b_Int', Intercept); 
 call symput('sigma', _SCALE_); 
 call symput('b_servo', servo); 
 call symput('b_slope', slope); 
 call symput('b_backup', backup); 
run; 
 



/*This code has been altered from the original HW2 code. It now accurately reflects the homework instructions, which were to calculate the statistics for pumps that failed due
  to flooding, AND did not have the servo AND backup upgrades. Previously, the code (and the resulting summary statistics in the report) only reflected subsets for pumps that
  failed due to flooding and did not have 1 of the 2 upgrades. In essence, if servo = 1 then delete and if backup=1 then delete needed to be included in both of the calculations
  because that is what the homework instructed (for unknown reasons)*/


data servo;
 set survive.katrina;
 if reason in (0,2,3,4) then delete;  
 if servo = 1 or backup = 1 then delete;
run;

data backup;
 set survive.katrina;
 if reason in (0,2,3,4) then delete;  
 if servo = 1 or backup = 1 then delete;
run;




/*  Calculate benefits of SERVO upgrade */
data servo; 
 set survive.katrina;
 if reason in (0,2,3,4) then delete; 
 if servo = 1 then delete; 
 if backup = 1 then delete;
 Survival = exp(-(hour*exp(-(&b_Int + &b_backup*backup + &b_servo*servo + &b_slope*slope)))**(1/&sigma)); 
 Old_t = (-log(Survival))**(&sigma)*exp(&b_Int + &b_backup*backup + &b_servo*servo + &b_slope*slope); 
 New_t = (-log(Survival))**(&sigma)*exp(&b_Int + &b_servo + &b_backup*backup + &b_slope*slope); 
 Difference = New_t - Old_t; 
run; 
 
proc means data=servo mean median min max; 
 var Difference; 
run;


/*  Calculate benefits of BACKUP upgrade */
data backup; 
 set survive.katrina; 
 if reason in (0,2,3,4) then delete;
 if backup = 1 then delete; 
 if servo = 1 then delete;
 Survival = exp(-(hour*exp(-(&b_Int + &b_backup*backup + &b_servo*servo + &b_slope*slope)))**(1/&sigma)); 
 Old_t = (-log(Survival))**(&sigma)*exp(&b_Int + &b_backup*backup + &b_servo*servo + &b_slope*slope); 
 New_t = (-log(Survival))**(&sigma)*exp(&b_Int + &b_backup + &b_servo*servo + &b_slope*slope); 
 Difference = New_t - Old_t; 
run; 
 
proc means data=backup mean median min max; 
 var Difference; 
run;
