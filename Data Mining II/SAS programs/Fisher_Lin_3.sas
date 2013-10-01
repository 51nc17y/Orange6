proc discrim data = gamblers 
pool=no testdata = gamble_valid testlist;
	class type;
	priors prop;
	var dsm1-dsm12;
run;
