/*-----------------------------*/
/*       Survival Curves       */
/*                             */
/*        Dr Aric LaBarr       */
/*       MSA Class of 2013     */
/*-----------------------------*/

/* Survival Curves */

proc lifetest data=Survival.Loyalty;
	time Tenure;
run;

proc lifetest data=Survival.Loyalty maxtime=48;
	time Tenure;
run;


/* Stratified Survival Curves */

proc lifetest data=Survival.Loyalty maxtime=48;
	time Tenure;
	strata Loyalty;
run;


/* Life-Table (Actuarial) Method */

proc lifetest data=Survival.Loyalty method=life;
	time Tenure;
	strata Loyalty;
run;

proc lifetest data=Survival.Loyalty method=life width=6;
	time Tenure;
	strata Loyalty;
run;
