
ods listing gpath="%sysfunc(pathname(work))";
%let sigma2=.25; * default sigma - try changing;

%macro GenNorm(mu=0, sigma=1);
	do i=1 to 351; 
		X=&mu+0.02*(i-175)*&sigma; 
		SSq = ((X-&mu)/&sigma)**2; 
		Y=exp(-0.5*SSq)/(sqrt(2*3.1415926)*&sigma);
		put _all_; 
output; end; %mend; 
ods listing gpath="%sysfunc(pathname(work))";
Data Normals; 
color=1; %GenNorm(mu=3); 
color=2; %Gennorm(mu=2,sigma=&sigma2); 


** Computing crossing points **; 
** Skip for class presentation **; 
** Set two normal density functions equal then solve for X **; 

data _null_;
	file print; 
	mu1=3; mu2=2; s1=1*1; s2=&sigma2*&sigma2; **(macro has sigma, need variance here)**; 
	c=mu1*mu1/s1-mu2*mu2/s2 + log(s1/s2); 
	b=2*mu2/s2-2*mu1/s1; a=1/s1 - 1/s2; 
	det=b*b-4*a*c; 
	put a b c det; 
	if s1=s2 then do; 
		root1=(mu1+mu2)/2; root2 = root1; root2A=.; end; 
	else do; 
	root1=(-b+sqrt(det))/(2*a); 
	root2 = (-b-sqrt(det))/(2*a); root2A = root2; end; 
	put "Roots: " root1 root2; 
	call symput("root1",root1); 
	call symput("root2",root2); 
	call symput("root2A",root2A); 
run; quit; 


proc sgplot; 
series X=X Y=Y / group=color lineattrs=(thickness=2);
refline &root1  &root2/axis=X; 
Title "Crossing point(s) &root1 &root2A";  
run; quit; 
