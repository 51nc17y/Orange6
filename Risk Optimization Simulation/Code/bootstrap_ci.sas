/*****************************************************************/
/* CALCULATE THE VaR USING THE MONTE CARLO SIMULATION APPROACH   */
/* THE MODEL USED IS THE ONE DESCRIBED IN OUR LECTURE NOTES      */
/* REPEAT THE PROCEDURE 100 TIMES TO GET A CONF. INTERVAL FOR VaR*/
/* NOTE: THIS METHODOLOGY IS SIMILAR, NOT IDENTICAL, TO          */
/*       BOOTSTRAPING                                            */  
/*****************************************************************/


/* Setable parameters: You can change the number of stocks,    */
/* covariance, number of draws, etc. to see its effects on the */
/* simulation                                                  */
%let num_msft_stocks  = 1500; /*Number of Microsoft stocks in portfolio*/
%let num_apple_stocks = 2500; /*Number of Apple stocks in portfolio*/
%let ndraws = 10000;
%let percentile=0.01;

/*Number of times to repeat the simulation*/
%let bootstrap_samples=100;

/*Covariance matrix between the MSFT and APPLE returns*/
%let covar = {0.0002116  0.0001130,
              0.0001130  0.0006032};


%let current_msft_price = 28.42;  /*Current Microsoft price*/
%let current_apple_price = 124.63;/*Current Apple price*/

%let seed=12345; /*Random seed to be used in simulation*/
/*END of setable parameters*/



/*- Main simulation code begins here -*/
PROC IML;
_bootstr_var_=j(&bootstrap_samples,1,0);
do bootstrap=1 to &bootstrap_samples;
	/*The change in the logarithm of the prices are normal */
	/*Sample draws from the standard normal distribution */
	std_normal_values = j(&ndraws, 2, 0);
	DO i=1 TO &ndraws;
   		std_normal_values[i,1]=rannor(1234+bootstrap);
   		std_normal_values[i,2]=rannor(1234+bootstrap);
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

	/*Sort the portfolio values*/
	call sort(sim_portfolio_value,{1});

	/*Find which observation to use for the specific VaR*/
	obs_to_use = round(&percentile*&ndraws,1)+1;

	/*The  VaR value is simply a specific observation*/
	VaR_ = sim_portfolio_value[obs_to_use,1];
	
	_bootstr_var_[bootstrap,1]=VaR_;
end;
	/*Create a SAS dataset with the simulated prices for further analysis*/
	CREATE _bootstr_var_ FROM _bootstr_var_ [colname="Value_at_Risk"];
	APPEND from _bootstr_var_;

QUIT;

/*Create a plot with the empirical distribution of the calculated VaR values*/
ods html;
ods graphics on;

PROC KDE DATA=_bootstr_var_; 
      UNIVAR Value_at_Risk / PLOTS= HISTDENSITY PERCENTILES;
RUN;
ods graphics off;
ods html close;
