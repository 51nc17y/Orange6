/***************************************************************/
/* CALCULATE THE VaR USING THE VARIANCE-COVARIANCE AND THE     */
/* HISTORICAL SIMULATION APPROACHES                            */
/***************************************************************/

%let autolist=%sysfunc(compress(%sysfunc(getoption(sasautos)),%str(%(%))));
%let util_macros="Z:\Desktop\MSA Class\Spring_2013_material\Risk Analytics and Simulation\macros";
options sasautos=(&autolist &util_macros);

/*Get a dataset with the Apple and Microsoft stocks*/
%let stocks =aapl msft;

/*Count the number of stocks in the portfolio*/
%let n_stocks=%sysfunc(countw(&stocks));

/*Download stocks*/
%get_stocks(&stocks,01JAN2010,,keepPrice=1);

/*Merge returns and prices*/
data stocks;
  merge prices returns(rename=(aapl=r_aapl msft=r_msft));
  by date;
  if _n_=1 then delete;
run;

/* Setable parameters */
%let msft_holding = 10; /*Holdings in Microsoft stocks */
%let aapl_holding = 10;  /*Holdings in Apple stocks     */
%let var_percentile=0.05;     /*Level of Value at Risk measure      */
/*==================================================================*/

ods html;
ods graphics on;

/* Use the CORR Procedure to create the
   following SAS macros:
 var_msft : Variance of Microsoft's returns 
 var_apple: Variance of Apple's returns
 covar    : Covariance of returns */
proc corr data=stocks cov out=covar_results plots;
var r_msft r_aapl;
run;

data _null_;
set covar_results(where = (_type_ eq 'COV'));
if upcase(_name_) eq 'R_MSFT' then do;
  call symput("var_msft",r_msft);
  call symput("covar",r_aapl);
end;
if upcase(_name_) eq 'R_AAPL' then do;
  call symput("var_aapl",r_aapl);
end;
run;
%put var_apple is equal to &var_aapl;

/*Get the current total value of holdings*/
data _null_;
set stocks end=eof;
if eof then do;
   msft_position= msft*&msft_holding;call symput("msft_position",msft_position);
   aapl_position= aapl*&aapl_holding;call symput("aapl_position",aapl_position);
end;
run; 
%put Amount invested in MSFT = &msft_position;
%put Amount invested in AAPL = &aapl_position;
proc iml;
/*----------------------------VARIANCE COVARIANCE APPROACH----------------------------*/ 
title 'VaR Results';

/*FIND THE WEIGHTS OF EACH POSITION IN THE PORTFOLIO */
MSFT_PORTF_WEIGHT = &MSFT_POSITION/(&MSFT_POSITION + &AAPL_POSITION);
APPLE_PORTF_WEIGHT = &AAPL_POSITION/(&MSFT_POSITION + &AAPL_POSITION);

/*FIND THE PORTFOLIO'S RETURN VARIANCE*/
PORTF_VARIANCE =  &VAR_MSFT*(MSFT_PORTF_WEIGHT)**2 + &VAR_AAPL*(APPLE_PORTF_WEIGHT)**2 
                   + 2*APPLE_PORTF_WEIGHT*MSFT_PORTF_WEIGHT*&COVAR;
PORTF_STDEV=sqrt(PORTF_VARIANCE);
print PORTF_STDEV;

/*0.95 CI for portfolios stdev*/
sigma_low = sqrt(PORTF_VARIANCE*(500-1)/cinv(0.975,500-1) );
sigma_up = sqrt(PORTF_VARIANCE*(500-1)/cinv(0.025,500-1) );
print sigma_low sigma_up;


/*FIND THE PORTFOLIO'S VAR, ASSUMING NORMAL, 0 MEAN RETURNS*/
VaR_normal = (&MSFT_POSITION + &AAPL_POSITION)*PROBIT(&var_percentile)*SQRT(PORTF_VARIANCE);
VaR_L= (&MSFT_POSITION + &AAPL_POSITION)*PROBIT(&var_percentile)*(sigma_low);
VaR_U= (&MSFT_POSITION + &AAPL_POSITION)*PROBIT(&var_percentile)*(sigma_up);
print var_normal var_l var_u;
pi=3.14159265;
ES_normal = -(&MSFT_POSITION + &AAPL_POSITION)*SQRT(PORTF_VARIANCE)*exp(-0.5*(PROBIT(&var_percentile))**2)/(&var_percentile.*sqrt(2*pi));

PRINT "Daily VaR (Percentile level: &var_percentile); Delta-Normal" VaR_normal[format=dollar15.2];

PRINT "Daily CVaR/ES (Percentile level: &var_percentile); Delta-Normal" ES_normal[format=dollar15.2];


/*------------------------------HISTORICAL APPROACH-----------------------------------*/ 
/*Read in the stocks's returns*/
USE stocks var {r_msft r_aapl}; 
read all var _all_ into returns;

/*Calculate the portfolio return in dollar terms*/
portfolio_return = &msft_position*returns[,1] + &aapl_position*returns[,2];

/*Sort the portfolio values*/
call sort(portfolio_return,{1});
/*Get the number of observations in the dataset*/
number_of_observations = nrow(portfolio_return);

/*Find which observation to use for the specific VaR*/
obs_to_use = round(&var_percentile*number_of_observations,1)+1;

/*The historical VaR value is simply a specific observation, e.g. the 6th, from the sorted dataset */
VaR_historical = portfolio_return[obs_to_use,1];

PRINT "Daily VaR (Percentile level: &var_percentile); Historical" VaR_historical[format=dollar15.2];

/*Calculate the ES*/
ES = sum(portfolio_return[1:obs_to_use,1])/(obs_to_use-1);
PRINT "Daily CVaR/ES (Percentile level: &var_percentile level); Historical" ES[format=dollar15.2];


title;
QUIT;
ods graphics off;
ods html close;
