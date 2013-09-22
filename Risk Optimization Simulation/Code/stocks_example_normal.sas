/***************************************************************/
/* CALCULATE THE VaR USING THE MONTE CARLO SIMULATION APPROACH */
/* THE MODEL USED IS THE ONE DESCRIBED IN OUR LECTURE NOTES    */
/***************************************************************/


/* Setable parameters: You can change the number of stocks,    */
/* covariance, number of draws, etc. to see its effects on the */
/* simulation                                                  */

%let num_msft_stocks  = 1500; /*Number of Microsoft stocks in portfolio*/
%let num_apple_stocks = 2500; /*Number of Apple stocks in portfolio*/
%let ndraws = 10000;
%let percentile=0.01;

/*Covariance matrix between the MSFT and APPLE returns*/
%let covar = {0.0002116  0.0001130,
              0.0001130  0.0006032};


%let current_msft_price = 28.42;  /*Current Microsoft price*/
%let current_apple_price = 124.63;/*Current Apple price*/

%let seed=12345; /*Random seed to be used in simulation*/
/*END of setable parameters*/



/*- Main simulation code begins here -*/
PROC IML;

    /*The change in the logarithm of the prices are normal */
    /*Sample draws from the standard normal distribution */
    std_normal_values = j(&ndraws, 2, 0);
    DO i=1 TO &ndraws;
        std_normal_values[i,1]=rannor(&seed);
        std_normal_values[i,2]=rannor(&seed);
    END;

    /*Get the Cholesky root of the covariance matrices*/
    chol_root = ROOT(&covar);

    /*Multiply the std normal values with the Cholesky root*/
    /*This will create the simulated values for Delta_p*/
    Delta_p = std_normal_values*chol_root;

    /*Recall that ln_Estimated_Price_tomorrow = ln_current_price + Delta_p */
    Price_MSFT_tomorrow  = exp(log(&current_msft_price)  + Delta_p[,1]);
    Price_APPLE_tomorrow = exp(log(&current_apple_price) + Delta_p[,2]);

    /*Get the simulated Value of the portfolio*/
    Sim_portfolio_value =  &num_msft_stocks*(Price_MSFT_tomorrow - &current_msft_price) + 
                            &num_apple_stocks*(Price_APPLE_tomorrow - &current_apple_price);

    /*Create a SAS dataset with the simulated prices for further analysis*/
    CREATE Sim_portfolio_value FROM Sim_portfolio_value [colname="Portfolio_value"];
    APPEND FROM Sim_portfolio_value;

QUIT;

/*Create a plot with the empirical distribution of the portfolio change*/
ods html;
ods graphics on;

PROC KDE DATA=SIM_PORTFOLIO_VALUE; 
      UNIVAR PORTFOLIO_value / PLOTS= HISTDENSITY PERCENTILES;
RUN;
   ods select Quantiles;
proc univariate data=SIM_PORTFOLIO_VALUE cipctlnormal(alpha=.01);
  var PORTFOLIO_value ;
run;
proc univariate data=SIM_PORTFOLIO_VALUE cipctlcdf(alpha=.01);
  var PORTFOLIO_value ;
run;

ods graphics off;
ods html close;

/*calculate the ES value*/
proc sort data=sim_portfolio_value out=ES;
by portfolio_value;
run;

data _null_;
    x = ceil(&ndraws*&percentile.);
    call symput("obs_to_use",x);
run;

data ES;
    set ES(obs=&obs_to_use);
run;

ods html;
ods graphics on;

PROC KDE DATA=ES; 
      UNIVAR portfolio_value / PLOTS= HISTDENSITY PERCENTILES;
RUN;

ods graphics off;
ods html close; 


