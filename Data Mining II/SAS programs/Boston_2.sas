%let split = 6.3; 
Data housing; set housing; 
group=(rm>&split); label NOx="NOx"; 
label rm="Rooms"; 
label MEDV="$$";  
if rm>&split then cval="green"; else cval="black";
run; 

ods output overallanova=anova; 
proc glm; class group; model medv=group; 
run; quit;
Data anova; set anova; if Fvalue > 0.0; split=&split; 
keep  Fvalue  split; 
proc print data=anova; title "Split at rooms> &split"; run; 
run; 

proc append base=splitstats data=anova; 
proc sort; by split; proc print; run; 

* /* ; * Graphics; 
goptions reset=all;  
proc gplot data=housing; 
bubble Nox*rm=medv/
    href=&split bcolor = red;  
run; 
proc g3d data=housing; 
scatter Nox*rm=medv/shape="balloon"
color=cval;  
run; 
proc gplot; plot Fvalue*split;
symbol1 v=dot i=join;  
run; * (why does this work on splitstats, 
        not housing??); 

*  */; 

 /* How to delete datasets;

proc datasets;  
delete anova splitstats;  
run;

* */ ;

/*  How to delete the whole graphics catalog 
    CLOSE the graph window first to unlock it **; 

proc catalog cat=work.gseg kill; run; 

* */;

/*  How to define a key to submit code

tools->options->keys  
Find a key you don't want and type:
        submit "proc catalog cat=work.gseg kill; run;"

*  */;
