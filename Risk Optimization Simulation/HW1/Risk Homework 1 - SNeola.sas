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

*5.	Suppose that X2 and X3 have a correlation of 0.6. Make sure that you use that assumption in step 1 of your analysis. 
Then, follow the same steps as in question (d) above. 
*Not sure how to do the last part even after reviewing Kostas' code. ;
