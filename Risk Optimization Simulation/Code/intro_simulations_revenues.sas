/******************************************************************************
 * Simple simulation case of sales' revenues                                  *
 *****************************************************************************/
 
/*Generate data*/
data simple_simulation(drop=i);
  format price var_cost fixed_cost net_revenue dollar6.2 units nlnum18.2;
  label price="Price";
  label units="Units Sold";
  label var_cost="Variable Cost (VC)";
  label fixed_cost="Fixed Cost (FC)";
  label net_revenue="Net Revenues";
  do i=1 to 10000;
    /*Units sold follow a triangular distribution on the interval (500,2000) with */
    /*mode 1500 */
    units = (2000-500)*rantri(2345,(1500-500)/(2000-500))+500;
    /*Variable cost is a function of units sold; a random shock is also assumed */
    /*in this model*/
    var_cost = 1 + 0.004*units + sqrt(0.8)*rannor(12345);
    /*Fixed costs*/ 
    fixed_cost = 2500;
    /*The company is a price taker. The price follows a triangular distribution */
    /*on the interval (8,11) with mode 10*/
    price = (11-8)*rantri(12345,(10-8)/(11-8))+8;
    /*Calculate Net Revenues*/
    net_revenue=(price-var_cost)*units - fixed_cost;
    output;
  end;
run; 

/*Start ODS*/
ods html;
ods graphics on;
/*Kernel Estimate of net_revenues*/
proc kde data=work.simple_simulation; 
  univar net_revenue / plots= histdensity percentiles  unistats /*histdensity histogram*/;
run;

/*Bivariate kernel dist.*/
proc kde data=work.simple_simulation; 
  bivar units price / plots= histsurface bivstats;
  bivar units var_cost / plots= histsurface out=biv_units_var_cost bivstats;
run;

/*G3D and activex alternative*/
goptions device=activex;
proc g3d data=biv_units_var_cost;
  plot value1*value2=density;
  run;
quit;

/*End ODS*/
ods graphics off;
ods html close;
