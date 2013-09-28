*Survival Analysis - Homework 1 - 09/25/13;
libname time clear;
libname survival 'C:\Users\sneola\Documents\Survival Analysis\Data';

*1	Provide summary statistics for each of the types of pump station failure. 
What percentage of pumps survived the hurricane? 
What percentages of pumps are in each failure? 
What is their average survival time? Are these averages different?;

proc freq data=survival.katrina_v2;
	tables reason;
run;

*Average survival time;
proc means data=survival.katrina_v2;
	var hour;
	by reason;
run;

*2: Plot two graphs (include these in the report):
	The survival curve for all surviving pumps
	The overlapping survival curves stratifying the data into reasons for failure.
	Discuss any interesting things you find.;
title;
proc lifetest data=survival.katrina_v2 maxtime=48;
	time hour;
	run;

proc lifetest data=survival.katrina_v2 maxtime=48;
	time hour;
	strata reason;
	run;

*3: Do the four major types of pump failures have similar survival curves? 
	Use the DIFF=ALL option in the STRATA statement in SAS to get all pairwise tests.;

proc lifetest data=survival.katrina_v2 maxtime=48;
	time hour;
	strata reason / diff=all;
	run;

*Hazard probabilities are sometimes more intuitive than hazard rates. 
	Unfortunately, SAS does not provide a graph of these by default. 
	Take the following steps to create your own:
o	Use the METHOD=LIFE option in the PROC LIFETEST statement with a WIDTH=1.
o	In the PROC LIFETEST statement, use the OUTSURV=… option 
		where the “…” is the name of a data set that will contain all of the needed information.
o	In this data set is a list of variables including PDF and SURVIVAL.
o	The hazard probability is the product of these two variables.;

proc lifetest data=survival.katrina_v2 method=life width=1 plots=h outsurv=hpprep;
strata reason / diff=all;
time hour ;
run;

data work.hpcalc;
	set hpprep;
	hp = pdf*survival;
run;


*Plot the hazard probabilities for each failure type on one graph.;
title 'Hazard Probabilities';
proc sgplot data=hpcalc;
	series y=hp x=hour;
run;
