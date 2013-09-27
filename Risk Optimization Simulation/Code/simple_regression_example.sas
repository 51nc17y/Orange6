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
%let nobs=30;

/*Set the number of simulations to run*/
%let nsims=10000;

/*Set the intercept and slope*/
%let beta0 = 10.5;
%let beta1 = 2.55;

******************************************************
* Generate data from a linear model that satifies the* 
* properties described above. The model used is the  *
* following:                                         *
* Y = beta0 + beta1*X1 + error                       *
* X1~chi_square(10 df)                               *
* error ~ N(0, 100)                                  * 
******************************************************;
data simulation;
do sim=1 to &nsims;
  do obs=1 to &nobs;
    call streaminit(12345);
    X1 = rand('chisq',10);
    err=sqrt(100)*rand('normal');
    Y=&beta0 + &beta1.*X1 + err;
    output;
  end;
end;
run;


/* Run one regression per simulation set. Store the  */
/* estimated parameters, p-values, std errors, etc., */
/* in the dataset sim_results.                       */
proc reg data=simulation outest=sim_results tableout noprint;
model y = x1;
by sim;
run;


/*Are the parameters unbiased?*/
/*Normally distributed?*/
data simulation_results;
set sim_results(where=(_type_ in ('PARMS')));
run;
proc univariate data=work.simulation_results;
var intercept x1;
histogram intercept x1/ normal(mu=est sigma=est) kernel;
probplot intercept x1/ normal(mu=est sigma=est);
run;
