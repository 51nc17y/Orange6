/***************************************************************/
/* CALCULATE THE VaR USING THE MONTE CARLO SIMULATION APPROACH */
/* THE MODEL USED IS A MIXTURE OF NORMAL DISTRIBUTIONS         */
/***************************************************************/


/* Setable parameters: You can change the number of stocks,    */
/* covariance, number of draws, etc. to see its effects on the */
/* simulation                                                  */

%let num_msft_stocks  = 1500; /*Number of Microsoft stocks in portfolio*/
%let num_apple_stocks = 2500; /*Number of Apple stocks in portfolio*/
%let ndraws = 30000;


%let covar1 = {0.002  0.001,
               0.001  0.0006};
%let covar2 = {0.0004  0.0003,
               0.0003  0.009};
%let percent_covar1_used = 0.35; /*Percentage of times that covar1 is used*/

%let current_msft_price = 28.42;  /*Current Microsoft price*/
%let current_apple_price = 124.63;/*Current Apple price*/

%let seed=12345;/*Random seed to be used in simulation*/
/*END of setable parameters*/



/*- Main simulation code begins here -*/
PROC IML;
    /*Get the Cholesky root of the covariance matrices*/
    chol_root1 = ROOT(&covar1);
    chol_root2 = ROOT(&covar2);

    /*Create standard normal variables*/
    std_normal_values = j(&ndraws, 2, 0);
    DO i=1 TO &ndraws;
       std_normal_values[i,1]=rannor(&seed);
       std_normal_values[i,2]=rannor(&seed);
    END;

    /*Recall that the change in the ln of the prices are normal */
    /*Use the appropriate Cholesky matrix*/
    Delta_p = j(&ndraws, 2, 0);
    DO i=1 TO &ndraws;
       if ranuni(&seed)<&percent_covar1_used then do;
          Delta_p[i,] = std_normal_values[i,]*chol_root1;
       end;
       else do;
          Delta_p[i,] = std_normal_values[i,]*chol_root2;
       end;
    END;


    /*Recall that ln_Estimated_Price_tomorrow = ln_current_price + Delat_p */
    Price_MSFT_tomorrow  = exp(log(&current_msft_price)  + Delta_p[,1]);
    Price_APPLE_tomorrow = exp(log(&current_apple_price) + Delta_p[,2]);


    /*Get the simulated change in the Value of the portfolio*/
    Sim_portfolio_change = &num_msft_stocks*(Price_MSFT_tomorrow - &current_msft_price) + 
                          &num_msft_stocks*(Price_APPLE_tomorrow - &current_apple_price);

    /*Create a SAS dataset with the simulated prices for further analysis*/
    CREATE sim_portfolio_change FROM Sim_portfolio_change [colname="Portfolio_change"];
    APPEND FROM Sim_portfolio_change;
    CREATE sim_deltas FROM delta_p [colname={"Delta_MSFT" , "Delta_APPLE"}];
    APPEND FROM delta_p;
QUIT;

/*Create a plot with the empirical distribution of the portfolio change*/
ods html;
ods graphics on;
goptions device=activex;
PROC KDE DATA=SIM_PORTFOLIO_CHANGE; 
      UNIVAR PORTFOLIO_CHANGE / PLOTS= HISTDENSITY PERCENTILES;
RUN;

PROC KDE DATA=SIM_Deltas; 
      BIVAR Delta_apple Delta_msft / PLOTS= ALL PERCENTILES out=delta_p_density bivstats;
RUN;

proc g3d data=delta_p_density;
plot value1*value2=density;
run;
quit;

ods graphics off;
ods html close;
