*****************************************************
*     Using OLS to analyze the properties of simple * 
*                    regression                     *
*                                                   *
* ASSUMPTIONS OF SLR                                *
*  Linearity of the mean (Errors have zero mean)    *
*  Errors are Normally distributed around the linear* 
*  relationship                                     *
*  Errors have equal variance                       *
*  Errors are independent                           *
*****************************************************;

/*Set the number of observations to use in each regression*/
%let nobs=100;

/*Set the number of simulations to run*/
%let nsims=20000;

/*Set the intercept and slope*/
%let beta0 = 13;
%let beta1 = 0.21;
%let beta2 = -0.9;
%let beta3 = 3.45;

title 'PART A&B'; 
data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
    	x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(100));
    Y=&beta0 + &beta1 *X1 + &beta2 *X2 + &beta3 *X3 + e;
    output;
  end;
end;
run;


/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=simulation outest=sim_results tableout noprint;
model y = x1 x2 x3;
by sim;
run;


/*Are the parameters unbiased?*/
/*Normally distributed?*/
data simulation_results;
set sim_results(where=(_type_ in ('PARMS')));
run;

proc univariate data=work.simulation_results;
	var intercept x1 x2 x3;
	histogram intercept x1 x3/ normal(mu=est sigma=est) kernel;
	histogram x2 /normal(mu=-.9 sigma=est) kernel; 
	probplot intercept x1 x3/ normal(mu=est sigma=est);
	probplot intercept x2/ normal(mu=-.9 sigma=est);
run;

title2 = 'Out of Bounds Counts'; 
data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc sql; 
	select 	count(x2) Label= "Out of Bounds"
	from 	simulation_bounds
	where 	_type_ = 'U95B' and x2<-0.9 
		or	_type_ = 'L95B' and x2>-0.9 ;
quit; 


title 'PART C - New variance in the error term'; 
data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
    	x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(10*x2));
    Y=&beta0 + &beta1 *X1 + &beta2 *X2 + &beta3 *X3 + e;
    output;
  end;
end;
run;


/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=simulation outest=sim_results tableout noprint;
	model y = x1 x2 x3;
	by sim;
run;


/*Are the parameters unbiased?*/
/*Normally distributed?*/
data simulation_results;
	set sim_results(where=(_type_ in ('PARMS')));
run;

data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc univariate data=work.simulation_results;
	var intercept x1 x2 x3;
	histogram intercept x1 x2 x3/ normal(mu=est sigma=est) kernel;
	histogram x2 /normal(mu=-.9 sigma=est) kernel; 
	probplot intercept x1  x3/ normal(mu=est sigma=est);
	probplot intercept x2/ normal(mu=-.9 sigma=est);
run;

title2 = 'Out of Bounds Counts'; 
data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc sql; 
	select 	count(x2) Label= "Out of Bounds"
	from 	simulation_bounds
	where 	_type_ = 'U95B' and x2<-0.9 
		or	_type_ = 'L95B' and x2>-0.9 ;
quit; 

title 'PART D - Omitting X3'; 
data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
    	x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		e  = rand('NORMAL', 0, sqrt(10*x2));
    Y=&beta0 + &beta1 *X1 + &beta2 *X2  + e;
    output;
  end;
end;
run;


/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=simulation outest=sim_results tableout noprint;
	model y = x1 x2 ;
	by sim;
run;


/*Are the parameters unbiased?*/
/*Normally distributed?*/
data simulation_results;
	set sim_results(where=(_type_ in ('PARMS')));
run;

data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc univariate data=work.simulation_results;
	var intercept x1 x2 ;
	histogram intercept x1 x2 / normal(mu=est sigma=est) kernel;
	histogram x2 /normal(mu=-.9 sigma=est) kernel; 
	probplot intercept x1  / normal(mu=est sigma=est);
	probplot intercept x2/ normal(mu=-.9 sigma=est);
run;

title2 = 'Out of Bounds Counts'; 
data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc sql; 
	select 	count(x2) Label= "Out of Bounds"
	from 	simulation_bounds
	where 	_type_ = 'U95B' and x2<-0.9 
		or	_type_ = 'L95B' and x2>-0.9 ;
quit; 

title 'PART E'; 
title2 'Correlation between X2 and X3'; 

************************************************
*   This program will generate two correlated  *
*   series, X1 and X2, with prespscified       *
*   marginal distributions                     *
************************************************;

/*Set the required correlation coefficient and */
/*the number of simulated points below         */
%let correlation_coef= 0.6;
%let num_of_simulated_points = 2000000;




/*Create a dataset that holds the correlation   */
/*matrix between X1 and X2*/
data _correl_matrix_;
  _type_ = "corr";
  _name_ = "X1";
  X2 = 1.0; 
  X3 = &correlation_coef.;
  output;
  _name_ = "X2";
  X2 = &correlation_coef.; 
  X3 = 1.0;
  output;
run;

/*Initial "naive" data for X1 and X2*/
data _naive_data_;
X2=0;
X3=0;
sim=1; 
run;

/*Generate X1 and X2*/
proc model noprint;
/*Set the mean of X1 here (e.g. 3)*/
X2 = 10;
/*Set the distributiuon of x1 here; for the normal*/
/*case, the statement normal(4) assumes that the  */
/*error is normally distributed with mean 0 and variance 4*/
errormodel X2 ~chisquared(10);

/*Set the mean of X2 here (e.g. 0)*/
X3 = 18;
/*Set the distributiuon of x2 here*/
errormodel X3 ~normal(15);

/*Generate the data and store them in the*/
/*SAS dataset x1_and_x2 */
solve X2 X3/ random=&num_of_simulated_points sdata=_correl_matrix_
data=_naive_data_ out=x2_and_x3(keep=x2 x3);
run;
quit;

/*Drop first observation to get are the final simulated data*/
data x2_and_x3;
set x2_and_x3(firstobs=2);
run;

/*Bivariate plot of X1 and X2*/
/*Show the marginal and joint distribution*/
proc kde data=work.x2_and_x3; 
  univar x2 / plots= histdensity percentiles  unistats ;
  univar x3 / plots= histdensity percentiles  unistats ;
  bivar x2 x3 / plots= histsurface out=biv_x2_x3 bivstats;
run;

data simulationE;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
    	x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		e  = rand('NORMAL', 0, sqrt(100));
    Y=&beta0 + &beta1 *X1 + &beta2 *X2  + e;
    output;
  end;
end;
run;


/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=simulation outest=sim_results tableout noprint;
model y = x1 x2 ;
by sim;
run;

data simulation_results;
	set sim_results(where=(_type_ in ('PARMS')));
run;

data simulation_bounds ; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc univariate data=work.simulation_results;
	var intercept x1 x2 ;
	histogram intercept x1 x2 / normal(mu=est sigma=est) kernel;
	histogram x2 /normal(mu=-.9 sigma=est) kernel; 
	probplot intercept x1  / normal(mu=est sigma=est);
	probplot intercept x2/ normal(mu=-.9 sigma=est);
run;

title2 = 'Out of Bounds Counts'; 

data simulation_bounds; 
	set sim_results (where=(_type_ in ('L95B', 'U95B'))); 
run; 

proc sql; 
	select 	count(x2) Label= "Out of Bounds"
	from 	simulation_bounds
	where 	_type_ = 'U95B' and x2<-0.9 
		or	_type_ = 'L95B' and x2>-0.9 ;
quit; 
