/*  Program to check the discriminant formulas in the clss notes  */; 

data discrim; 
type = "A"; do i=1 to 5; 
x1 = 80 + .9*round(10*normal(123)); 
X2 = 20 + .9*round(10*normal(123)); 
output; end; 
type = "B"; do i=1 to 5; 
x1=  20 + .9*round(10*normal(123)); 
X2 = 80 + .9*round(10*normal(123)); 
output; end; 

** get the means **; 
proc means mean; var x1 x2; by type; run;

** get the pooled variance matrix **; 
proc discrim pool=test outstat=out1; 
 class type;  
 var x1 x2; 
run; 
proc print data=out1;
where _type_="PCOV";  
run; 

** Show that the SAS Fisher Linear Discriminant matches the class notes ***;
** Only keeping 2 decimal places in sigma (small discrepancies will arise) **;  
proc iml; 
  sig = {44.15 -11.14, -11.14 71.12}; sinv=inv(sig); 
  mu1 = {82.70, 21.26}; mu2 = {23.60,72.26}; 
  disc1 = -0.5*(mu1`*sinv*mu1||(-2*mu1`*sinv)); * || stack horizontally; 
  disc2 = -0.5*(mu2`*sinv*mu2||(-2*mu2`*sinv));
  print disc1 disc2; 
  * optional: classify point (50,30) *; 
  newpoint={1, 50, 30};       *{   } a matrix, row by row; 
  Fisher=disc1//disc2;        *//stack vertically;
  print Fisher newpoint;  
  Which_pop=Fisher*newpoint; 
  Prob_pop = exp(Which_pop); print Prob_pop; 
  Prob_pop = Prob_pop/Prob_pop[+, ]; * [+, ]sum rows for all columns; 
  print Which_pop Prob_pop; 
run;  
