************************************************
*   This program will generate two correlated  *
*   series, X1 and X2, with prespscified       *
*   marginal distributions                     *
************************************************;

/*Set the required correlation coefficient and */
/*the number of simulated points below         */
%let correlation_coef= 0.6;
%let num_of_simulated_points = 50000;




/*Create a dataset that holds the correlation   */
/*matrix between X1 and X2*/
data _correl_matrix_;
  _type_ = "corr";
  _name_ = "X1";
  X1 = 1.0; 
  X2 = &correlation_coef.;
  output;
  _name_ = "X2";
  X1 = &correlation_coef.; 
  X2 = 1.0;
  output;
run;

/*Initial "naive" data for X1 and X2*/
data _naive_data_;
X1=0;
X2=0;
run;

/*Generate X1 and X2*/
proc model noprint;
/*Set the mean of X1 here (e.g. 3)*/
X1 = 3;
/*Set the distributiuon of x1 here; for the normal*/
/*case, the statement normal(4) assumes that the  */
/*error is normally distributed with mean 0 and variance 4*/
errormodel X1 ~normal(4);

/*Set the mean of X2 here (e.g. 0)*/
X2 = 0;
/*Set the distributiuon of x2 here*/
errormodel X2 ~CHISQUARED(3);
/*Generate the data and store them in the*/
/*SAS dataset x1_and_x2 */
solve X1 X2/ random=&num_of_simulated_points sdata=_correl_matrix_
data=_naive_data_ out=x1_and_x2(keep=x1 x2);
run;
quit;

/*Drop first observation to get are the final simulated data*/
data x1_and_x2;
set x1_and_x2(firstobs=2);
run;

/*Bivariate plot of X1 and X2*/
/*Show the marginal and joint distribution*/
proc kde data=work.x1_and_x2; 
  univar x1 / plots= histdensity percentiles  unistats ;
  univar x2 / plots= histdensity percentiles  unistats ;
  bivar x1 x2 / plots= histsurface out=biv_x1_x2 bivstats;
run;
