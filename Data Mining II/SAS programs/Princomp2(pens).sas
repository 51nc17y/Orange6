libname AAEM "C:\workshop\winsas\aaem"; 
proc print data=aaem.pensall(obs=30); 
run ;
proc corr data=aaem.pensall nosimple nomiss; var x1-x16; 
run; 
%macro interpret(number); 
proc means data=aaem.pensall; var x1-x16; where digit=&number; 
output out=out1 mean=m1-m16; run; 
proc print data=out1; run;
data next; set out1; 
X=m1;  Y=m2;  output; 
X=m3;  Y=m4;  output;
X=m5;  Y=m6;  output; 
X=m7;  Y=m8;  output; 
X=m9;  Y=m10; output; 
X=m11; Y=m12; output;
X=m13; Y=m14; output; 
X=m15; Y=m16; output; 
proc gplot; plot Y*X; 
symbol1 v=dot i=join; title "Pattern for digit &number"; 
run;
%mend; 

%macro examples(number);  
data dots; set aaem.pensall; 
example+1; 
X=x1;  Y=x2;  output; 
X=x3;  Y=x4;  output;
X=x5;  Y=x6;  output; 
X=x7;  Y=x8;  output; 
X=x9;  Y=x10; output; 
X=x11; Y=x12; output;
X=x13; Y=x14; output; 
X=x15; Y=x16; output; 
proc gplot; plot Y*X=example/nolegend;where digit=&number;  
symbol1 v=dot i=join r=100; 
run; 
%mend; 

%interpret(2);%examples(2);
%interpret(7); %examples(7);
%interpret(1);%examples(1);  
 
proc princomp data=aaem.pensall out=aaem.pensprin; 
var x1-x16; 
run; 


/*--------------------------------------------------------------------------------
| Get into INSIGHT, use pensprin.  Make a rotataing scatter plot with PRIN1-3.     |
| Color by DIGIT using DIGIT histogram or the rainbow color gradient.             |
 --------------------------------------------------------------------------------*/
 
