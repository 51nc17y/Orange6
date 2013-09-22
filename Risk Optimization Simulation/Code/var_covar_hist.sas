/****************************************************************************************
 * PURPOSE: Calculate VaR using the Delta-Normal & historical simulation approaches     *
 *                                                                                      *                    
 *   USAGE: %var_covar_hist(ver_percentile=0.005, msft_investment=20000,                *
 *             aapl_ivestment=100000,util_macro_path=C:\My_Path_To_Utility_Macros);     *               
 *                                                                                      *
 *   INPUTS                                                                             *
 *       var_percentile: The percentile level where VaR will be computed                *
 *                       (any real value between 0 and 1)                               *
 *      msft_investment: Monetary amount invested in Microsoft stocks                   *
 *                       (real positive number)                                         *
 *       aapl_ivestment: Monetary amount invested in Apple stocks                       *
 *                       (real positive number)                                         *
 *      util_macro_path: Path where the utility macros "get_stocks.sas"                 *
 *                       and "download.sas" are located, e.g.                           *
 *                        C:\Users\me\desktop\my_utility_macros                         * 
 *                                                                                      *       
 *   NOTES: We use the same mechanism as the one discussed in class, i.e.               *
 *          variance-covariance assuming normality of stocks' returns.                  *
 *          The numerical differences from the class-example are due to the             *
 *          fact that we are using the most up-to-date data.                            *   
 ***************************************************************************************/

%macro var_covar_hist(var_percentile=0.05, msft_investment=200000, 
                      aapl_investment=100000,
                      util_macro_path=C:\Users\Kostas\Desktop\macros); 

  /*Begin: Error checking */
  /*VaR percentile should be between 0 and 1*/
  %if %sysevalf((0 le &var_percentile) and(1 ge &var_percentile)) ne 1 %then %do;
   %put ERROR: var_percentile should be a number between 0 and 1.;
   %return;
  %end;  
  /*Stock holdings cannot be negative, i.e. no short positions*/
  %if %sysevalf(&msft_investment ge 0) ne 1 %then %do;  
   %put ERROR: msft_investment should be a non-negative number.;
   %return;
  %end;  
  %if %sysevalf(&aapl_investment ge 0) ne 1 %then %do;  
   %put ERROR: aapl_ivestment should be a non-negative number.;
   %return;
  %end;    
  /*The total amount invested in the portfolio should be strictly positive*/
  %if %sysfunc(sum(&aapl_investment,&msft_investment)) le 0 %then %do;  
   %put ERROR: Total investment in the portfolio should be a strictly positive number.;
   %return;
  %end;      
  /*End: Error checking */
  
  
  *Update the SAS macro-search path;
  %let autolist=%sysfunc(compress(%sysfunc(getoption(sasautos)),%str(%(%))));
  options sasautos=(&autolist "&util_macro_path");

  *Retrieve data on Apple and Microsoft stocks;
  %let stocks =aapl msft;
  %get_stocks(&stocks,01JAN2010, 01JAN2012,keepPrice=1);
    
  *Merge returns and prices. Output current and historical data ; 
  data stocks current;
    merge prices returns(rename=(aapl=r_aapl msft=r_msft)) end=eof;
    by date;
    if eof then output current;
    else output stocks;
  run;

  ods html;
  ods graphics on;

  /* Use the CORR Procedure and create the following SAS macros:
     var_msft : Variance of Microsoft's returns 
     var_apple: Variance of Apple's returns
       covar: Covariance of returns */
  proc corr data=stocks cov out=covar_results plots noprint;
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

  *Print invested amount;
  options nosource nosource2;
  %put NOTE: Amount invested in MSFT = &msft_investment;
  %put NOTE: Amount invested in AAPL = &aapl_investment;
  *Print variances and correlations;
  %put NOTE: stdev(AAPL) = %sysevalf(&var_aapl.**0.5);
  %put NOTE: stdev(MSFT) = %sysevalf(&var_msft.**0.5);
  %put NOTE: correl(AAPL,MSFT) = %sysevalf(&covar/((&var_aapl**0.5)*(&var_msft**0.5)));
  options source source2;

  /*Invoke IML for the analysis*/
  proc iml;
  /*---------------------------VARIANCE COVARIANCE APPROACH------------------*/ 
  title 'VaR Results';

  /*FIND THE WEIGHTS OF EACH POSITION IN THE PORTFOLIO */
  msft_portf_weight = &msft_investment/(&msft_investment + &aapl_investment);
  apple_portf_weight = &aapl_investment/(&msft_investment + &aapl_investment);

  /*find the portfolio's return variance*/
  portf_variance =  &var_msft*(msft_portf_weight)**2 + 
                    &var_aapl*(apple_portf_weight)**2 
                    + 2*apple_portf_weight*msft_portf_weight*&covar;
  portf_stdev=sqrt(portf_variance);
  print portf_stdev;

  /**************************************************************************** 
   * 0.95 CI for portfolios stdev, based on the assumption that returns are 
   * normal
   * ==> If X~N(mu, sigma^2), then (n-1)s^2/sigma^2 ~ chisq(n-1 d.f.)         *
   ***************************************************************************/

  sigma_low = sqrt(portf_variance*(500-1)/cinv(0.975,500-1) );
  sigma_up = sqrt(portf_variance*(500-1)/cinv(0.025,500-1) );
  print sigma_low sigma_up;


  /*FIND THE PORTFOLIO'S VAR, ASSUMING NORMAL, 0 MEAN RETURNS*/
  VaR_normal = (&msft_investment + &aapl_investment)*
                  probit(&var_percentile)*sqrt(portf_variance);
  VaR_L= (&msft_investment + &aapl_investment)*probit(&var_percentile)*
                 (sigma_low);
  VaR_U= (&msft_investment + &aapl_investment)*probit(&var_percentile)*
                 (sigma_up);
  print var_normal var_l var_u;
  pi=3.14159265;
  ES_normal = -(&msft_investment + &aapl_investment)*sqrt(portf_variance)*
            exp(-0.5*(probit(&var_percentile))**2)/(&var_percentile.*sqrt(2*pi));

  PRINT "Daily VaR (Percentile level: &var_percentile); Delta-Normal" VaR_normal[format=dollar15.2];

  PRINT "Daily CVaR/ES (Percentile level: &var_percentile); Delta-Normal" ES_normal[format=dollar15.2];


  /*------------------------------HISTORICAL APPROACH------------------------*/ 
  /*Read in the stocks's returns*/
  USE stocks var {r_msft r_aapl}; 
  read all var _all_ into returns;

  /*Calculate the portfolio return in dollar terms*/
  portfolio_return = &msft_investment*returns[,1]+&aapl_investment*returns[,2];

  /*Sort the portfolio values*/
  call sort(portfolio_return,{1});
  /*Get the number of observations in the dataset*/
  number_of_observations = nrow(portfolio_return);

  /*Find which observation to use for the specific VaR*/
  obs_to_use = round(&var_percentile*number_of_observations,1)+1;

  /* The historical VaR value is simply a specific observation, e.g. the 6th, *
   * from the sorted dataset                                                 */
  VaR_historical = portfolio_return[obs_to_use,1];

  PRINT "Daily VaR (Percentile level: &var_percentile); Historical" VaR_historical[format=dollar15.2];

  /*Calculate the ES*/
  ES = sum(portfolio_return[1:obs_to_use,1])/(obs_to_use-1);
  PRINT "Daily CVaR/ES (Percentile level: &var_percentile level); Historical" ES[format=dollar15.2];


  title;
  QUIT;
  ods graphics off;
  ods html close;

%mend var_covar_hist;
