/*These are the best models thus far*/


/*ALL WHITE NOISE!!!!!!!!!*/
proc arima data=electric.training1 plot(unpack)=all;
	identify var=DUQ (1 24) nlag=100;
	estimate p=(1,2,3,7,9,12,15,17,20,24,48,72) q= (12) (24) method=ML;
	forecast lead=168;
run;
quit;

/*Best White Noise Plot so Far!*/
proc arima data=electric.training1 plot(unpack)=all;
	identify var=DUQ (1 24) nlag=100;
	estimate p=(1,2,7,9,12,15,17,20,48,72,96) q= (12) (24) method=ML;
	forecast lead=168;
run;
quit;

proc arima data=electric.training1 plot(unpack)=all;
	identify var=DUQ (1 24) nlag=100;
	estimate p=(1,2,3,4,7,9,12,15,17,20,48,72,96) q= (12) (24) method=ML;
	forecast lead=168;
run;
quit;

/*Still good White Noise after adding 5*/
proc arima data=electric.training1 plot(unpack)=all;
	identify var=DUQ (1 24) nlag=100;
	estimate p=(1,2,3,4,5,7,9,12,15,17,20,48,72,96) q= (12) (24) method=ML;
	forecast lead=168;
run;
quit;

/*Still very good White Noise: maybe best yet?*/
proc arima data=electric.training1 plot(unpack)=all;
	identify var=DUQ (1 24) nlag=100;
	estimate p=(1,2,3,4,7,9,12,15,17,20,48,72,96) q= (12) (24) (48) method=ML;
	forecast lead=168;
run;
quit;
