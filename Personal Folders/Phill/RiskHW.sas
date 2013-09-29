/*Number of Simfilations*/
%let nsims=10000; 

/*Number of Observations*/
%let nobs = 100;

/*Creating the random Data*/
data Risk ; 
	do i=1 to &nobs;
		x1 = rand('UNIFORM')*10+10; 
		x2 = rand('CHISQUARE', 10); 
		x3 = rand('NORMAL',18, sqrt(15));
		e  = rand('NORMAL', 0, sqrt(100));
		Y  = -13+0.21*x1-0.9*x2+3.45*x3+e;
		output;
	end; 
run; 

proc print data=risk; 
run; 
