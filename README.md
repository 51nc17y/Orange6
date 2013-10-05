Orange6
=======

MSA Fall 2 Homework Group (Orange Team 6)

libname aaem 'c:\iaa\data mining';

/* Create type_num variable to use Type as an ordinal variable */
data aaem.gamblers_edit;
	set aaem.gamblers;
	if type='Control' then type_num='1';
	if type='Steady' then type_num='2';
	if type='Binge' then type_num='3';
run;

data aaem.valid_edit;
	set aaem.gamble_valid;
	if type='Control' then type_num='1';
	if type='Steady' then type_num='2';
	if type='Binge' then type_num='3';
run;

/* Use created models */
proc logistic data=aaem.gamblers_edit;
	model type_num=ga1-ga20 ga1*ga3 ga1*ga5 ga10*ga14 ga3*ga15 ga7*ga17 ga4*ga16 ga7*ga12 ga3*ga18 / clodds=pl
		selection=stepwise slentry=0.01 slstay=0.01; 
run;

proc logistic data=aaem.gamblers_edit outmodel=work.model_1;
	model type_num=ga1 ga3 ga4 ga5 ga6 ga7 ga9 ga10 ga14 ga15 ga16 ga17 ga19 ga20 ga1*ga3 ga1*ga5 ga10*ga14 ga3*ga15 ga7*ga17 ga4*ga16;
run;

proc logistic data=aaem.gamblers_edit outmodel=work.model_2;
	model type_num=ga10 ga20;
run;

/*  Test new model on the validation data set */
proc logistic inmodel=work.Model_1;
	score data=aaem.valid_edit;
run;

proc logistic inmodel=work.Model_2;
	score data=aaem.valid_edit;
run;

proc freq data=data24;
	tables F_Type_Num*I_Type_Num;
	title 'Crosstabulation of Observed by Predicted Responses';
run;

proc freq data=data25;
	tables F_Type_Num*I_Type_Num;
	title 'Crosstabulation of Observed by Predicted Responses';
run;

/* Use Linear Discrim Analysis to compare to models */
proc stepdisc data=aaem.gamblers method=stepwise;
	class type;
	var ga1-ga20;
run;

/* Once you find the significant variables use them against the validation data set */
proc discrim data=aaem.gamble_valid pool=test outstat=out1;
	class type;
	var ga6 ga9 ga10 ga20;
	priors prop;
run;

proc print data=out1;
	where _type_="PCOV";
run;

/*  Combined DSM and GA */
proc logistic data=aaem.gamblers outmodel=work.model_3;
	model type(event='Binge')=ga10 ga20 dsm1 dsm4 dsm8 / clodds=pl;
run;

proc logistic inmodel=work.Model_3;
	score data=aaem.gamble_valid;
run;

proc freq data=data4;
	tables F_Type*I_Type;
	title 'Crosstabulation of Observed by Predicted Responses';
run;

