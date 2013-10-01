** Run Gamblers.sas first to get data ***; 

**(1) Stepwise model selection **; 
proc stepdisc data = gamblers method=stepwise;
	class type;
	var dsm1-dsm12;
Title "Gamblers: stepwise selection"; 
run;

**(2) Validation on new data **; 
proc discrim data = gamblers 
pool = no testdata = gamble_Valid;
	title2 'validation of stepwise discriminant functions';
	class type;
	priors prop;
	var dsm1 dsm2 dsm4 dsm8;
run; title;
