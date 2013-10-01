proc discrim data = gamblers pool = test slpool = .05 outstat=out1;
title1 'Test for equality of covariance matrices'; 
title2 '(not equal =>quadratic discriminant analysis)';
    class type;
	priors prop;
	var dsm1-dsm12;
proc print data=out1;
where _type_="PCOV";title "Pooled Covariance Matrix";
run; title ;
