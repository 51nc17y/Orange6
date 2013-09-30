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
