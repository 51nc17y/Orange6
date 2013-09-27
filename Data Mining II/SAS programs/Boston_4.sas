/*---------------------------------------------------------------
| Boston_3.sas takes a while to run.  This is because wrapping   |
| PROCs in a macro is very inefficient.  Here we use the hand    |
| formulas for the F test which greatly speeds up the comp-      |
| utations. Also we have tried every possible split here versus  |
| a grid of equally spaced splits.                               |
 ---------------------------------------------------------------*/

*** Step 1: get overall stats (sums, n, corrected total SS etc.);
proc means data=housing noprint; 
output out=a sum=sum n=n css=css; var medv; 
proc print data=a;

*** Step 2: sort on rm ; 
proc sort data=housing; by rm; 

*** Step 3: Recursively move medv values from second group to 
first then compute ANOVA F test with hand formulas.  Take note 
when F exceeds the current Fmax and replace Fmax and minrms to 
update; 

data compute; set housing(keep=medv rm)  end=eof; 
retain sum sum1 df css n ct maxF minrm; 
if _n_=1 then do; set a; df=n-2; maxF=0; CT=sum*sum/n; minrm=rm; end;
n1+1; n2=n-n1;  
sum1 + medv; sum2=sum-sum1; 
ssmodel = sum1*sum1/n1+sum2*sum2/n2-ct; 
MSE = (css-ssmodel)/df;
F=ssmodel/MSE; if F>maxF then do;  
maxF=F; minrm=rm; id="****"; 
call symput('bestsplit',rm); 
probF = 1-probF(F,1,df); logworth=-log10(probF); end; 
Keep F maxF rm minrm logworth id probF logworth; 
/* If EOF then */ output; 

*** Step 4: Print and plot the results; 
proc print data=compute; var F maxF rm minrm id ProbF logworth; run; 
proc print data=compute; var maxF minrm; 
Title "Winning split: &bestsplit";run;
proc gplot data=compute; plot F*rm; 
run; 
