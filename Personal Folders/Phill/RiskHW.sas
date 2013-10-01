/*Number of Simfilations*/
%let nsims=20000; 

/*Number of Observations*/
%let nobs = 100;

/*Creating the random Data*/
data Risk ; 
  do sim = 1 to &nsims; 
	do i=1 to &nobs;
		x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(100));
		Y  = -13+0.21*x1-0.9*x2+3.45*x3+e;
		output;
	end; 
  end; 
run; 

proc reg data=Risk outest=sim_results tableout noprint;
	model y = x1 x2 x3;
	by sim;
run;

data simulation_results;
	set sim_results(where=(_type_ in ('PARMS')));
run;

proc univariate data=work.simulation_results; 
	var x1; 
	histogram x1/ normal (mu=.9 sigma=est) kernel; 
	probplot x1 / normal (mu=.9 sigma=est); 
run ; 

proc univariate data=work.simulation_results;
	var intercept x1 x2 x3;
	histogram intercept x1 x2 x3/ normal(mu=est sigma=est) kernel;
	probplot intercept x1 x2 x3/ normal(mu=est sigma=est);
run;

*****************************************************************
*					Errors Function of X1						*
*****************************************************************; 
title 'Error Function of X1'; 
data Risk ; 
  do sim = 1 to &nsims; 
	do i=1 to &nobs;
		x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(10*x1));
		Y  = -13+0.21*x1-0.9*x2+3.45*x3+e;
		output;
	end; 
  end; 
run; 

proc reg data=Risk outest=sim_results2 tableout noprint;
	model y = x1 x2 x3;
	by sim;
run;

data simulation_results2;
	set sim_results2(where=(_type_ in ('PARMS')));
run;

proc univariate data=work.simulation_results2; 
	var x1; 
	histogram x1/ normal (mu=.9 sigma=est) kernel; 
	probplot x1 / normal (mu=.9 sigma=est); 
run ; 

proc univariate data=work.simulation_results2;
	var intercept x1 x2 x3;
	histogram intercept x1 x2 x3/ normal(mu=est sigma=est) kernel;
	probplot intercept x1 x2 x3/ normal(mu=est sigma=est);
run;
title; 

*****************************************************************
*							Omitting X3							*
*****************************************************************; 
title 'Omitting X3'; 
data Risk ; 
  do sim = 1 to &nsims; 
	do i=1 to &nobs;
		x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(100));
		Y  = -13+0.21*x1-0.9*x2+3.45*x3+e;
		output;
	end; 
  end; 
run; 

proc reg data=Risk outest=sim_results3 tableout noprint;
	model y = x1 x2 ;
	by sim;
run;

data simulation_results3;
	set sim_results3(where=(_type_ in ('PARMS')));
run;

proc univariate data=work.simulation_results3; 
	var x1; 
	histogram x1/ normal (mu=.9 sigma=est) kernel; 
	probplot x1 / normal (mu=.9 sigma=est); 
run ; 

proc univariate data=work.simulation_results3;
	var intercept x1 x2 ;
	histogram intercept x1 x2 / normal(mu=est sigma=est) kernel;
	probplot intercept x1 x2 / normal(mu=est sigma=est);
run;
title; 

proc sql;
	select avg(x2), avg(x3)
	from risk; 
quit;  

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
  _name_ = "X2";
  X1 = 1.0; 
  X2 = &correlation_coef.;
  output;
  _name_ = "X3";
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
X2 = 10;
/*Set the distributiuon of x1 here; for the normal*/
/*case, the statement normal(4) assumes that the  */
/*error is normally distributed with mean 0 and variance 4*/
errormodel X2 ~ CHISQUARED(10);

/*Set the mean of X2 here (e.g. 0)*/
X3 = 0;
/*Set the distributiuon of x2 here*/
errormodel X3 ~NORMAL(Sqrt(15));
/*Generate the data and store them in the*/
/*SAS dataset x1_and_x2 */
solve X2 X3/ random=&num_of_simulated_points sdata=_correl_matrix_
data=_naive_data_ out=x1_and_x2(keep=x1 x2);
run;
quit;

/*Drop first observation to get are the final simulated data*/
data x2_and_x3;
set x2_and_x3(firstobs=2);
run;

/*Bivariate plot of X1 and X2*/
/*Show the marginal and joint distribution*/
proc kde data=work.x1_and_x2; 
  univar x2 / plots= histdensity percentiles  unistats ;
  univar x3 / plots= histdensity percentiles  unistats ;
  bivar x2 x3 / plots= histsurface out=biv_x1_x2 bivstats;
run;
