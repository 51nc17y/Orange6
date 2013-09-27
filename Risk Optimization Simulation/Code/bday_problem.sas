/* You run into an office that employs 23 people. 
   What is the probability that two of the employees 
   have the same birthday? For the purposes of the problem, 
   ignore February 29. */
%let nsims=3000;
%let employees=23;
data simulate_birthdays;
do simulation=1 to &nsims;
  do person=1 to &employees;
    bday=ceil(365*ranuni(123));
    output;
  end;
 end;
run;

proc sort data=simulate_birthdays;
by simulation bday;
run;

data same_bdays;
set simulate_birthdays;
by simulation bday;
same_bday=0;
if bday=lag(bday) then same_bday=1;
if first.bday then same_bday=0;
run;

proc means data=same_bdays sum noprint;
var same_bday;
by simulation;
output out=identify_same_bdays_per_sim sum=total;
run;

proc sql noprint;
select count(*)/&nsims into :prob_of_same_bdays
from identify_same_bdays_per_sim
where total>0;
quit;

data _null_;
format _x_ percent8.4;
_x_=&prob_of_same_bdays;
put "NOTE: The probability of having at least two people with the same birthday is: " _x_;
run; 
