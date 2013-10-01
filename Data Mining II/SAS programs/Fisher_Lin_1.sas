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
proc print data=predicted; where note="*"; 
run; 

** Look at the questions "; 
proc sort data=gamblers; by sub; 
proc sort data=predicted; by sub; 
data all; merge gamblers predicted; by sub; 
drop ga1-ga20 type; 
proc sort data=all; by intotype; 
proc print label noobs data=all; where note = "*"; 
run; 
