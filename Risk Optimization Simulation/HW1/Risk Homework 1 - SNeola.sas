libname survival clear ;
libname risk 'C:\Users\sneola\Documents\Risk Management & Simulation\Homework';

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
%let beta0 = -13;
%let beta1 = .21;
%let beta2 = -.9;
%let beta3 = 3.45;

******************************************************
* Generate data from a linear model that satifies the* 
* properties described above. The model used is the  *
* following:                                         *
* Y = beta0 + beta1*X1 + beta2*X2 + beta3*X3 + error                       *
* X1~uniform(10,20)
* X2~chi_square(10 df)
* X3 ~ N(18,15)
* error ~ N(0, 100)                                  * 
******************************************************;

data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
	X1 = rand('uniform')*10+10;
	X2 = rand('chisq',10);
	X3 = rand('normal',18,sqrt(15));
    err= sqrt(100)*rand('normal');
    Y=&beta0 + &beta1.*X1 + &beta2.*X2 + &beta3.*X3 + err;
    output;
  end;
end;
run;
*why do the macros have a . after them? Indicates the end of the macro name?;


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
*_type_ is the name of the variable titled 'Type of Statistics' 
and Parms is one of the values;

proc univariate data=work.simulation_results;
var intercept x1 x2 x3;
histogram intercept x1 x2 x3/ normal(mu=est sigma=est) kernel;
probplot intercept x1 x2 x3/ normal(mu=est sigma=est);
run;

*Using a level of a=5%, how many times do you, incorrectly, reject H0: B2 = -.9?;

proc sql;
	select x2 
		from simulation_results 
		where x2 gt -.5176 and x2 lt -.51684;
quit;

proc sql;
	select count(x2) 
		from simulation_results 
		where x2 gt -0.51684 or x2 lt -1.27866;
quit;


****REDO?? ***


*3.	Repeat steps 1-6, with the only difference that the variance of the error is defined as variance = 10*X1, 
i.e. make the variance of the residuals a function of X1. ;

data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
	X1 = rand('uniform')*10+10;
	X2 = rand('chisq',10);
	X3 = rand('normal',18,sqrt(15));
     err= sqrt(10*X1)*rand('normal');
    Y=&beta0 + &beta1.*X1 + &beta2.*X2 + &beta3.*X3 + err;
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
*_type_ is the name of the variable titled 'Type of Statistics' 
and Parms is one of the values;

proc univariate data=work.simulation_results;
var intercept x1 x2 x3;
histogram intercept x1 x2 x3/ normal(mu=-.9 sigma=est) kernel;
probplot intercept x1 x2 x3/ normal(mu=-.9 sigma=est);
run;

*4.	Repeat steps 1 through 6, but on step 4 run a regression of Y on X1 and X2 only (omit X3). ;

data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
	X1 = rand('uniform')*10;
	X2 = rand('chisq',10);
	X3 = rand('normal',18,sqrt(15));
    err= sqrt(100)*rand('normal');
    Y=&beta0 + &beta1.*X1 + &beta2.*X2 + &beta3.*X3 + err;
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
*_type_ is the name of the variable titled 'Type of Statistics' 
and Parms is one of the values;

proc univariate data=work.simulation_results;
var intercept x1 x2;
histogram intercept x1 x2/ normal(mu=est sigma=est) kernel;
probplot intercept x1 x2/ normal(mu=est sigma=est);
run;


/*TWO-SIDED TEST FOR BETA1_HAT = BETA1_TRUE*/
/*select only the upper and lower bounds for the variable of interest*/
data _temp_(drop=_depvar_ _rmse_ _model_ y intercept);
set sim_results(where=(_type_ in ('L95B' 'U95B') ));
run;
/*Transpose the results*/ 
proc transpose data=_temp_ out=beta1_ci(drop=_name_);
by sim;
var x1;
id _type_ ;
run;
/*Calculate Type-I error*/
proc sql;
select count(*)/&nsims as _type1_error_ label="Type-I Error (alpha=5%)" format=percent8.5
from beta1_ci 
where &beta1 not between L95B and U95B;
quit; 


*5.	Suppose that X2 and X3 have a correlation of 0.6. Make sure that you use that assumption in step 1 of your analysis. 
Then, follow the same steps as in question (d) above.;

**Process Flow:
*calc x1x2 correlation -> run simulation -> create y (via equation in data step)-> run proc reg -> Validate distributions;


************************************************
*   This program will generate two correlated  *
*   series, X1 and X2, with prespecified       *
*   marginal distributions                     *
************************************************;


/*Set the required correlation coefficient and */
/*the number of simulated points below         */
%let correlation_coef= 0.6;
%let num_of_simulated_points = 2000000;

/*Create a dataset that holds the correlation   */
/*matrix between X2 and X3*/
data _correl_matrix_;
  _type_ = "corr";
  _name_ = "X2";
  X2 = 1.0;
  X3 = &correlation_coef.;
  output;
  _name_ = "X3";
  X2 = &correlation_coef.; 
  X3 = 1.0;
  output;
run;

/*Initial "naive" data for X2 and X3*/
data _naive_data_;
X2=0;
X3=0;
run;

/*Generate X2 and X3*/
proc model noprint;
*by sim;
x2 = 0;
errormodel x2 ~chisquared(10);
x3 = 18;
errormodel x3 ~normal(15);
solve X2 X3/ random=&num_of_simulated_points sdata=_correl_matrix_
data=_naive_data_ out=x2_and_x3(keep=x2 x3);
run;
quit;

/*Generate X2 and X3*/
proc model noprint;
/*Set the mean of X2 here (e.g. 3)*/
X3 = 17.99876;
/*Set the distributiuon of x1 here; for the normal*/
/*case, the statement normal(4) assumes that the  */
/*error is normally distributed with mean 0 and variance 4*/
errormodel X3 ~normal(18,sqrt(15));

/*Set the mean of X2 here (e.g. 0)*/
X2 = 9.995011;
/*Set the distributiuon of x2 here*/
errormodel X2 ~CHISQUARED(10);
/*Generate the data and store them in the*/
/*SAS dataset x2_and_x3 */
solve X2 X3/ random=&num_of_simulated_points sdata=_correl_matrix_
data=_naive_data_ out=x2_and_x3(keep=x2 x3);
run;
quit;

/*Drop first observation to get are the final simulated data*/
data x2_and_x3;
set x2_and_x3(firstobs=2);
run;

/*Bivariate plot of X2 and X3*/
/*Show the marginal and joint distribution*/
proc kde data=work.x2_and_x3; 
  univar x2 / plots= histdensity percentiles  unistats ;
  univar x3 / plots= histdensity percentiles  unistats ;
  bivar x2 x3 / plots= histsurface out=biv_x2_x3 bivstats;
run;


*Merge X2,x3 into data set with x1;

*calc x1x2 correlation -> run simulation -> create y -> run proc reg;



data work.x1_and_err;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
	X1 = 10+rand('uniform')*10;
	*X2 = rand('chisq',10);
	*X3 = rand('normal',18,sqrt(15));
    err= sqrt(100)*rand('normal');
    *Y=&beta0 + &beta1.*X1 + &beta2.*X2 + &beta3.*X3 + err;
    output;
  end;
end;
run;

data work.x1;
merge  work.x2_and_x3 x1_and_err;
run;

data work.y_var;
set x1;
Y=&beta0 + &beta1.*X1 + &beta2.*X2 + &beta3.*X3 + err;
run;

/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=y_var outest=sim_results tableout noprint;
model y = x1 x2;
by sim;
run;


/*TWO-SIDED TEST FOR BETA1_HAT = BETA1_TRUE*/
/*select only the upper and lower bounds for the variable of interest*/
data _temp_(drop=_depvar_ _rmse_ _model_ y intercept);
set sim_results(where=(_type_ in ('L95B' 'U95B') ));
run;
/*Transpose the results*/ 
proc transpose data=_temp_ out=beta1_ci;
by sim;
var x1;
id _type_ ;
run;

proc transpose data=_temp_ out=beta2_ci;
by sim;
var x2;
id _type_ ;
run;

*(drop=_name_);
/*Calculate Type-I error*/
proc sql;
select count(*)/&nsims as _type1_error_ label="Type-I Error (alpha=5%)" format=percent8.5
from beta1_ci 
where &beta1 not between L95B and U95B;
quit; 

*4.40% Type1 error;

/*Calculate Type-I error*/
proc sql;
select count(*)/&nsims as _type1_error_ label="Type-I Error (alpha=5%)" format=percent8.5
from beta2_ci 
where &beta2 not between L95B and U95B;
quit; 

*100% type 1 error;



/*Normally distributed?*/
data simulation_results;
set sim_results(where=(_type_ in ('PARMS')));
run;
*_type_ is the name of the variable titled 'Type of Statistics' 
and Parms is one of the values;

proc univariate data=work.y_var;
var x1;
histogram x1/ normal(mu=.21 sigma=est) kernel;
probplot x1/ normal(mu=.21 sigma=est);
run;

proc univariate data=work.simulation_results;
var x2;
histogram x2/ normal(mu=est sigma=est) kernel;
probplot x2/ normal(mu=est sigma=est);
run;

**CHECkOUT: MODEL, NAIVE
