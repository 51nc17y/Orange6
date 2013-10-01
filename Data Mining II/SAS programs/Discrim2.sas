%macro pdf(mu1,mu2,Y); 
  det= s11*s22-s12*s12; *<--- determinant of Sigma; 
  * inverse of s11 s12  is   _1_  s22 -s12
               s21 s22       det -s12  s11 ;
   &Y = 1/(2*3.14159*sqrt(s11*s22-s12*s12))*
   exp(-.5*
  (s22*(X1-&mu1)**2 - 2*s12*(X1-&mu1)*(X2-&mu2) + s11*(X2-&mu2)**2)
   /det); 
 %mend pdf; 

 data discrim; keep x1 x2 f color; 
 s11 = 10; s12 = 4; 
           s22 = 8; 
do x1 = -20 to 20 by .5; 
  do x2 = -20 to 20 by .5; 
    %pdf(20,20,Y1); 
	%pdf(5,-3,Y2); 
	%pdf(-2,2,Y3); 
color = "green"; f = max(y1,y2,y3); 
  If Y1>max(Y2,y3) then color="red"; 
  if y2>max(Y1,Y3) then color="blue"; 
  output; end; end; 
proc g3d; scatter X1*X2 = f/shape = "balloon" color=color size=.3; 
proc gplot; plot x1*x2=color; 
symbol1 v=plus i=none; 
run; 

