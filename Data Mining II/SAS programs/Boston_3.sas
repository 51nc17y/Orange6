*  Write a macro loop to run the program 50 times.  Need to call symput to create the 
macro variable &split from the SAS variable split; 

%macro manysplit;
%do i = 1 %to 65; 
Data housing; set housing; 
split = 3.58 + &i*0.08;  group=(rm>split); 
call symput("split",split);  
run; 

ods output overallanova=anova; 
ods listing close; 
proc glm; class group; model medv=group; run; 
quit;
ods listing; 
Data anova; set anova; if Fvalue > 0.0; split=&split; 
logworth = -log10(65*probF); ** Using # splits checked **; 
keep  Fvalue  split logworth; 
proc print data=anova; title "Split at rooms> &split"; run; 
run; 
proc append base=splitstats data=anova; 
%end;
%mend; 
** Initialize data set ***; 
data splitstats; Fvalue=.; split=.; logworth=.; run; 
%manysplit; 

** Use a null data step to find optimal split point and 
   store it as a macro variable **; 
options symbolgen; 
data _null_; set splitstats; if _n_=1 then maxF=0; retain maxF;
  if Fvalue>MaxF then do; maxF=Fvalue; 
  put Fvalue= maxF= split=;
  call symput("vref",-log10(65*(1-probF(0,1,504))));
  call symput("href",split); end; 

proc sort data=splitstats; by split; proc print; run; 

proc gplot; plot (logworth Fvalue)*split/href=&href vref=0 &vref;
symbol1 v=dot i=join;  label split="Rooms split point";
title "Best split at &href";
run; 



/* proc datasets;  delete anova splitstats;  run; */
