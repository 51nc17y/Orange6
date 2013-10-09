*Data Mining Homework 5 - Gamblers Data -Steve Neola - 10/7/13;

*Suppose you work for an analytics consulting agency and have been hired by the Gamblers Anonymous group 
to evaluate their Gamblers Anonymous questionnaire in terms of its accuracy in diagnosing 
whether a person should be classified as a binge, control, or steady gambler. 
As you know, we have talked about one approach to doing this but have used the Diagnostic and Statistical Manual questionnaire to do so.  For this one, let’s leave it open ended like this and see how creative people are in analyzing the data and reporting.  Andrea and I are not “looking for” any particular details but I think we’ll be able to recognize a good analysis & report when we see it.  No ground rules or designation of a particular technique on this one.  
Do what you think is best.;  

** First run Gamblers.sas to get the data ***; 
 ods listing gpath="%sysfunc(pathname(work))";

/*(1)-----------------------------------
|  Fisher Linear Discriminant Function  |
| assuming sample proportions represent |
| population proportions.               |
 ---------------------------------------*/

proc discrim data = gamblers list anova;
	class type;
	priors prop;
	var dsm1-dsm12;
run;

proc discrim data = gamblers list anova;
	class type;
	priors prop;
	var ga1-ga20;
run;

/*(2) -----------------------------------
|  Fisher Linear Discriminant Function   |
| assuming population proportions 1/3    |
| in each group. This is the default.    |
| (priors statement unnecessary)         |
 ---------------------------------------*/

proc discrim data = gamblers list;
	class type;
	priors equal;
	var dsm1-dsm12;
run;

proc discrim data = gamblers list;
	class type;
	priors equal;
	var ga1-ga20;
run;

/*(3) -----------------------------------
|  Fisher Linear Discriminant Function   |
| Specified proportions.                 |
 ---------------------------------------*/

ods trace on; 
ods output postresub=predicted; 
proc discrim data = gamblers list;
id sub;
	class type;
	priors 'Binge'=.4 'Steady'=.4 'Control'=.2;
	var dsm1-dsm12;
run; quit; 
ods trace off; 
*gave prior probabilies (priors) because that is what is in population (see first proc discrim example);

proc print data=predicted; where note="*"; 
run; 
*look at the postresub to see which ones were misclassified.;

** Look at the questions "; 
proc sort data=gamblers; by sub; 
proc sort data=predicted; by sub; 
data all; merge gamblers predicted; by sub; 
drop ga1-ga20 type; 
proc sort data=all; by intotype; 
proc print label noobs data=all; where note = "*"; 
run; 


*test with validation data set;

proc discrim data = gamblers 
pool=no testdata = gamble_valid testlist;
	class type;
	priors prop;
	var dsm1-dsm12;
run;

proc discrim data = gamblers 
pool=no testdata = gamble_valid testlist;
	class type;
	priors prop;
	var ga1-ga20;
run;
*pool = no: already ran the test;
*testlist - validation data;

*Shows that the model is not as accurate with validation data set compared to the training data set. 
(test / val created in initial gamblers.sas program;

** Run Gamblers.sas first to get data ***; 

**(1) Stepwise model selection **; 
proc stepdisc data = gamblers method=stepwise;
	class type;
	var dsm1-dsm12;
Title "Gamblers: stepwise selection"; 
run;

proc stepdisc data = gamblers method=stepwise;
	class type;
	var ga1-ga20;
Title "Gamblers: stepwise selection"; 
run;

proc stepdisc data = gamblers method=stepwise;
	class type;
	var ga1-ga20 dsm1-dsm12;
Title "Gamblers: stepwise selection"; 
run;
*able to reduce down to 4 questions (variables) instead);

**(2) Validation on new data **
**Testing to see how much predictive accuracy you lose by removing the 8 questions.  
**May outway the benefits of having a longer survey;
 
proc discrim data = gamblers 
pool = no testdata = gamble_Valid;
	title2 'validation of stepwise discriminant functions';
	class type;
	priors prop;
	var dsm1 dsm2 dsm4 dsm8;
run; title;

proc discrim data = gamblers 
pool = no testdata = gamble_Valid;
	title2 'validation of stepwise discriminant functions';
	class type;
	priors prop;
	var ga6 ga9 ga10 ga20;
run; title;

*Principal Components;

*DSM;
 proc corr cov data=gamblers nosimple nocorr; 
 var dsm1-dsm12; %labellopper; 
 where type="Control"; run; 

 proc princomp data=gamblers out=prinout; var dsm1-dsm12;
 proc gplot; plot prin1*prin2=type; 
 plot prin3*prin4=type; 
 symbol1 v=circle i=none c=red; 
 symbol2 v=plus i=none c=blue; 
 symbol3 v=star i=none c=black; 
 run;

 *GA - Training;
 proc corr cov data=gamblers nosimple nocorr; 
 var ga1-ga20; %labellopper; 
 where type="Control"; 
*why is type=control in this statement?;
	run; 

 proc princomp data=gamblers out=prinout_ga; var ga1-ga20;
 proc gplot; plot prin1*prin2=type; 
 plot prin3*prin4=type; 
 symbol1 v=circle i=none c=red; 
 symbol2 v=plus i=none c=blue; 
 symbol3 v=star i=none c=black; 
 run;

 *GA - Validation;
  proc corr cov data=gamble_valid nosimple nocorr; 
 var ga1-ga20; %labellopper; 
 where type="Control"; 
*why is type=control in this statement?;
	run; 

 proc princomp data=gamble_valid out=prinout_ga_val; var ga1-ga20;
 proc gplot; plot prin1*prin2=type; 
 plot prin3*prin4=type; 
 symbol1 v=circle i=none c=red; 
 symbol2 v=plus i=none c=blue; 
 symbol3 v=star i=none c=black; 
 run;


*Proc Logistic;
*dsm;
proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = dsm1-dsm12 / link=glogit clodds=pl selection=stepwise;
run;
proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = dsm1-dsm12 / link=glogit clodds=pl selection=forward;
run;
*ga;
proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = ga1-ga20 / link=glogit clodds=pl selection=stepwise;
run;


proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = ga1-ga20 / link=glogit clodds=pl selection=forward;
run;

*combined;
proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = ga1-ga20 dsm1-dsm12  / link=glogit clodds=pl selection=stepwise;
run;

proc logistic data=gamblers plot(only)=oddsratio(range=clip);
	class type(param=ref ref='Control');
	model type (ref='Control') = ga1-ga20 dsm1-dsm12 / link=glogit clodds=pl selection=forward;
run;

*scoring the logistic model. Getting QUASI COMPLETE SEPARATION message. So switching to Principal Components in the model;
proc logistic data=prinout_ga outmodel=score_prep;
	model type (ref='Control') = prin1-prin4 / link=glogit clodds=pl;
run;

proc logistic inmodel=score_prep;
	score data=prinout_ga_val out=score_data;
run;

proc print data = score_data;
run;

proc sql;

*sorting the logistic scoring results - ***work in progress***;
proc sort data=gamblers; by sub; 
proc sort data=predicted; by sub; 
data all; merge gamblers predicted; by sub; 
drop ga1-ga20 type; 
proc sort data=all; by intotype; 
proc print label noobs data=all; where note = "*"; 
run;

Score // Build logistic regression model with principal components 

run prin comp on both training and validation;

*variable reduction w/ proc factor;
	
proc factor with varimax variation
