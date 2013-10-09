/*proc logistic score model*/ 
proc logistic inmodel=gamblers;
score data=gamble_valid out=scored_data;
run;

********   Create macros *************************; 
%macro makelabels; 
  label sub  ="Subject";      
  label dsm1 ="Wished stop thkg re gambling";             
  label dsm2 ="Wished stop thkg re get money";            
  label dsm3 ="Felt need to bet more and more";           
  label dsm4 ="Rely on others for funds";  
  label dsm5 ="Gamble to escape";          
  label dsm6 ="Lie about how much I gamble";              
  label dsm7 ="Relaxing difficult if not gambling";       
  label dsm8 ="Win back money next day";   
  label dsm9 ="Felt I should cut back on gambling";       
  label dsm10 ="Illegal acts to pay for gambling";         
  label dsm11 ="Danger of losing relationship";            
  label dsm12 ="Danger of losing job";      
  label ga1  ="Lost time from work from gambling";        
  label ga2  ="Gambling made home life unhappy";          
  label ga3  ="Gambling affected reputation";             
  label ga4  ="Felt remorse after  gambling";              
  label ga5  ="Gamble to get money for debts";            
  label ga6  ="Caused decreased ambition/efficiency";     
  label ga7  ="Felt must return win back losses";         
  label ga8  ="After win want to return win more";        
  label ga9  ="Gambled until last dollar gone";           
  label ga10 ="Borrowed to finance  gambling";             
  label ga11 ="Sold things to finance  gambling";          
  label ga12 ="Kept gambling money for  gambling";         
  label ga13 ="Gambling->Careless of self/family";        
  label ga14 ="Gambled longer than planned";              
  label ga15 ="Gambled to escape worry/trouble";          
  label ga16 ="Illegal act to finance  gambling";          
  label ga17 ="Gambling caused difficulty sleeping";      
  label ga18 ="Arguments, frustration ->  gambling";       
  label ga19 ="Good fortune->  gambling";   
  label ga20 ="Gambling -> suicidal ideation";
  %mend makelabels; 
  
%macro labellopper; 
%do i=1 %to 12; 
 label dsm&i = " "; 
%end; 
%mend; 

  options macrogen; 
****************************************************;

Data gamblers;   
length type $8.; 
input sub $ dsm1-dsm12 ga1-ga20 type $; 
     %makelabels; 
datalines; 
  1 3 3 3 1 0 0 0 1 3 0 0 2 3 0 2 3 0 1 4 3 1 1 0 4 1 1 0 3 0 0 0 4 Steady
  2 2 3 4 0 4 3 4 1 2 0 3 1 1 4 1 3 4 2 2 2 1 2 1 3 4 1 4 2 1 4 3 2 Control
  3 3 3 4 4 1 2 0 4 4 3 2 2 2 1 2 4 1 3 4 3 2 3 3 4 2 4 0 3 4 0 2 3 Binge
  4 0 0 0 3 2 2 3 4 0 4 4 3 4 3 4 0 2 2 0 0 4 4 3 0 3 4 4 0 3 2 2 0 Binge
  5 0 0 0 0 3 4 4 1 2 1 2 0 0 3 0 2 4 0 0 0 1 0 1 1 4 1 3 2 0 3 4 1 Control
  6 1 0 0 2 1 1 0 1 0 2 1 1 1 2 3 1 1 1 0 1 1 1 1 1 0 1 2 1 1 1 0 0 Control
  7 1 0 2 1 2 2 4 1 0 1 0 3 2 2 3 0 2 4 1 2 2 3 2 1 1 2 2 2 2 3 3 1 Control
  8 3 4 4 4 3 1 3 3 1 3 1 4 3 2 3 3 0 3 3 4 3 3 4 3 2 3 3 3 3 2 2 3 Binge
  9 2 2 1 2 1 2 1 1 3 1 0 2 2 2 0 1 1 0 2 1 1 1 1 2 1 0 0 1 1 1 1 2 Control
 10 2 3 1 1 0 2 0 1 2 1 4 1 2 3 0 2 1 2 2 2 2 1 0 3 2 1 0 1 2 0 0 2 Control
 11 2 2 2 0 0 4 0 0 3 0 4 0 0 4 0 1 0 0 1 2 0 0 0 1 4 0 1 2 0 0 0 2 Control
 12 4 4 4 1 2 2 2 2 4 3 1 1 3 0 1 4 1 2 4 4 1 1 3 4 0 3 2 4 2 3 2 4 Control
 13 3 1 2 4 1 3 1 4 3 4 2 4 3 3 1 2 3 4 3 3 3 3 3 2 3 3 3 2 4 2 1 1 Control
 14 1 0 2 2 1 4 1 3 1 2 2 2 2 2 3 1 4 3 1 0 2 2 2 1 3 2 2 1 4 3 4 0 Control
 15 4 4 2 1 1 0 4 0 4 1 1 1 0 1 2 4 3 0 4 4 0 0 1 4 1 2 4 4 1 4 3 4 Steady
 16 1 2 1 4 0 2 1 4 1 4 2 3 4 3 4 2 1 4 0 0 3 4 3 1 2 4 0 1 4 2 2 1 Binge
 17 4 4 4 3 2 3 1 3 4 1 2 2 3 3 1 4 2 1 4 4 3 2 2 4 0 2 3 4 0 0 3 4 Binge
 18 3 3 1 3 4 2 3 3 3 1 2 1 2 2 1 2 3 1 2 2 1 3 1 3 2 3 3 3 1 4 4 3 Binge
 19 2 1 2 2 0 1 0 3 2 3 2 2 2 1 3 1 0 1 1 1 2 1 3 2 1 2 0 2 2 0 0 2 Control
 20 1 1 3 0 2 0 2 0 2 1 0 0 0 0 0 2 2 0 2 2 0 0 0 1 0 1 3 3 0 4 3 1 Control
 21 1 3 3 1 2 1 1 0 2 2 2 1 1 4 1 0 1 2 3 3 3 1 2 2 2 4 1 2 3 0 1 2 Control
 22 0 2 3 3 4 1 4 3 1 2 3 2 4 0 3 2 4 1 1 2 3 3 2 1 2 3 4 2 2 4 4 1 Binge
 23 0 1 1 0 2 4 2 0 1 1 4 0 1 2 1 2 2 1 1 1 2 1 0 2 3 0 3 0 1 1 3 1 Control
 24 0 0 0 2 1 1 2 2 1 1 3 1 2 1 0 0 2 1 0 0 2 3 3 0 3 2 1 1 2 0 3 0 Control
 25 4 4 4 1 0 1 0 0 4 1 1 0 0 0 0 4 0 0 4 4 2 0 0 4 1 1 0 4 3 0 0 4 Steady
 26 1 3 4 3 2 4 2 3 1 4 3 4 4 2 4 2 4 4 2 1 4 3 4 2 2 4 4 2 3 3 3 2 Binge
 27 2 1 0 0 3 0 3 2 1 0 0 1 1 0 1 3 3 1 2 3 2 1 2 3 0 1 3 2 1 3 3 2 Control
 28 3 4 2 1 2 4 3 0 2 0 4 0 0 4 0 3 3 0 2 4 1 0 0 4 4 0 1 3 0 2 2 3 Steady
 29 4 3 4 1 1 0 0 1 4 0 0 1 0 0 1 4 0 1 4 4 0 2 2 4 2 0 0 4 0 1 1 4 Steady
 30 4 4 4 2 4 2 4 2 4 3 3 2 4 2 2 4 4 3 2 3 4 2 1 4 2 2 4 4 2 4 4 4 Steady
 31 2 2 2 0 1 2 2 1 3 0 3 0 0 3 0 3 1 0 2 3 0 0 1 3 1 0 2 2 0 1 3 3 Control
 32 4 2 3 4 4 0 3 3 3 4 2 4 3 1 4 4 4 3 4 3 4 4 3 4 1 4 4 4 4 2 3 3 Binge
 33 3 2 4 2 4 1 3 0 4 1 1 1 2 1 2 2 4 0 3 2 1 0 2 2 1 1 4 4 1 4 4 4 Steady
 34 1 3 4 1 4 4 4 1 2 1 3 1 0 4 0 1 3 0 3 3 0 0 0 1 4 1 4 4 0 3 2 4 Control
 35 1 1 0 3 3 0 3 4 1 4 0 4 3 0 4 1 2 4 1 1 3 2 3 2 0 3 2 1 3 3 3 0 Control
 36 3 3 2 0 4 0 2 1 3 3 1 2 2 0 1 2 4 0 3 3 1 0 2 1 1 0 3 3 0 2 4 0 Control
 37 4 4 4 3 1 3 2 4 4 2 3 3 3 4 2 4 1 4 4 4 3 2 4 3 4 4 0 4 4 1 1 3 Control
 38 3 3 2 1 3 4 2 0 4 1 3 1 0 4 0 3 4 1 4 1 0 1 1 2 4 1 4 1 0 2 4 4 Steady
 39 3 3 3 0 4 1 4 0 4 0 4 0 0 2 0 4 4 0 3 4 0 1 0 2 2 0 4 3 0 4 4 3 Steady
 40 4 4 3 2 0 1 0 2 3 2 1 4 2 1 3 4 2 2 4 4 2 2 3 4 1 3 2 4 3 2 1 4 Steady
 41 2 2 1 3 3 4 4 4 2 3 4 3 4 4 4 2 4 4 2 1 4 4 4 2 4 4 3 0 3 3 2 2 Control
 42 2 2 2 0 3 0 3 2 0 0 0 0 1 1 1 3 3 2 1 2 1 2 1 3 0 2 4 2 1 4 2 1 Control
 43 1 1 1 2 3 0 2 4 0 2 1 3 4 0 4 1 3 3 2 1 3 4 3 1 1 4 3 0 3 4 4 1 Control
 44 3 3 3 2 4 1 4 2 3 3 1 3 2 1 2 3 3 2 4 2 2 4 3 2 0 3 4 3 2 4 3 3 Steady
 45 0 0 0 2 3 4 2 3 0 3 4 2 1 4 3 0 1 2 0 0 3 2 0 0 3 2 3 0 3 2 3 0 Control
 46 1 1 0 0 1 2 2 0 1 1 3 0 1 3 0 0 2 1 0 0 0 0 0 0 3 0 1 1 1 2 2 1 Control
 47 4 4 4 0 0 4 0 0 4 0 0 1 1 3 1 4 0 0 4 4 0 2 0 4 1 1 0 4 2 0 0 4 Steady
 48 1 0 1 4 1 3 3 3 0 3 1 3 2 2 3 0 2 3 0 0 3 3 4 0 3 4 2 1 3 1 0 0 Control
 49 0 0 0 0 0 3 0 1 0 4 4 2 2 4 2 1 2 2 1 0 1 1 1 0 4 1 1 0 1 0 0 0 Control
 50 3 4 3 2 3 3 3 1 3 3 3 2 2 3 2 4 2 1 4 4 1 2 3 3 2 1 3 3 2 3 2 3 Steady
 51 0 1 0 4 2 4 1 3 0 4 4 4 3 3 4 1 1 3 1 1 3 3 4 0 4 4 2 0 4 2 2 1 Binge
 52 0 1 1 0 3 0 3 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 3 1 0 3 2 0 Control
 53 0 2 1 0 1 0 0 0 1 0 0 0 1 0 1 1 0 1 0 1 0 0 0 1 0 0 0 0 1 1 0 1 Control
 54 1 1 1 1 4 0 4 2 2 2 1 3 1 0 1 0 4 2 1 2 2 1 2 0 0 1 4 1 3 4 2 1 Control
 55 0 1 2 1 3 0 1 2 1 2 1 3 3 0 2 0 1 4 2 1 2 1 3 0 1 2 2 0 3 3 1 1 Control
 56 1 2 2 0 3 0 2 2 1 3 0 2 2 0 1 1 2 3 0 1 1 2 2 1 1 3 2 2 2 1 1 2 Control
 57 4 4 4 1 2 2 3 2 4 3 2 2 2 1 3 3 3 2 4 4 2 2 1 4 1 4 3 4 2 1 1 4 Steady
 58 4 3 4 1 2 0 1 0 4 0 0 0 0 0 0 3 2 0 3 2 0 0 2 4 0 0 1 4 0 2 2 3 Steady
 59 0 0 0 1 2 3 3 0 0 0 2 0 0 3 0 1 1 0 0 0 0 0 0 0 3 0 1 0 0 1 2 0 Control
 60 1 0 0 2 4 3 4 1 0 1 2 2 3 2 2 0 4 3 1 0 2 3 4 0 3 2 4 0 3 4 4 0 Control
 61 2 2 3 1 1 0 2 0 2 2 1 0 0 1 2 2 3 1 3 2 1 1 0 0 0 0 2 0 0 2 3 2 Control
 62 1 1 1 0 1 1 2 0 3 0 0 0 1 0 0 3 0 1 1 3 0 0 0 2 0 1 1 3 0 0 1 1 Control
 63 2 4 2 2 0 3 0 1 2 2 4 2 1 4 4 3 0 3 3 2 3 3 2 3 3 2 0 3 2 0 0 3 Control
 64 2 2 1 0 4 3 4 1 1 0 4 1 1 1 1 1 4 0 2 2 0 1 1 2 4 0 2 2 1 4 4 2 Control
 65 3 4 3 3 2 2 1 2 3 2 2 3 2 3 3 3 2 2 1 4 3 2 1 2 3 1 2 3 2 1 4 3 Binge
 66 0 1 1 3 3 1 1 2 1 1 0 3 1 2 1 0 1 0 1 0 1 3 2 0 0 1 1 1 1 2 1 2 Binge
 67 1 1 1 4 4 4 4 4 0 4 4 4 4 4 4 1 4 4 0 0 4 4 2 0 4 3 4 0 3 4 4 0 Binge
 68 3 3 2 0 1 3 0 1 3 2 1 1 1 1 2 3 0 1 2 4 2 1 1 4 2 3 1 2 2 1 1 3 Steady
 69 3 3 4 3 3 3 3 3 3 3 3 4 3 4 2 3 1 3 4 4 4 2 3 3 4 3 2 3 4 2 3 3 Binge
 70 2 0 1 4 0 2 1 3 1 4 0 4 3 0 3 1 1 4 1 1 4 4 3 0 2 3 0 0 4 1 2 3 Binge
 71 4 3 3 4 4 1 4 4 2 4 1 4 4 1 4 4 1 4 3 3 4 3 3 3 0 4 3 3 4 3 4 3 Binge
 72 2 2 3 3 3 3 3 4 2 2 3 3 4 4 3 4 3 3 3 4 2 4 4 3 3 4 2 3 4 4 1 3 Control
 73 0 0 2 3 4 2 3 3 1 3 3 4 3 4 2 2 3 4 1 2 2 3 4 2 4 3 2 2 4 3 3 2 Binge
 74 4 4 3 2 2 1 3 2 3 2 2 2 1 2 3 3 1 3 4 3 3 1 1 4 2 4 2 4 2 2 0 4 Steady
 75 4 2 2 1 1 3 0 1 3 1 2 2 0 2 0 3 0 3 4 2 2 3 2 3 3 0 1 4 1 1 0 2 Steady
 76 3 1 2 4 3 4 4 4 2 4 0 4 4 2 4 2 2 4 3 1 4 4 4 3 4 4 3 1 4 4 3 2 Binge
 77 4 4 3 4 0 3 0 4 4 4 3 3 4 2 3 3 0 2 3 3 3 4 4 4 4 2 0 4 3 0 0 4 Binge
 78 3 3 3 4 3 0 2 2 2 2 0 3 4 1 2 2 2 2 3 3 3 4 3 3 2 2 1 2 3 3 3 3 Binge
 79 4 3 3 4 2 4 2 3 4 3 1 4 3 3 4 4 1 4 4 3 4 2 4 3 2 2 2 4 1 2 1 4 Binge
 80 2 4 0 0 2 3 3 2 2 1 4 0 0 3 1 0 3 2 2 1 0 0 0 1 3 2 2 0 1 3 2 0 Control
 81 1 0 0 3 4 2 4 3 0 4 4 4 4 1 4 0 4 4 1 0 4 4 4 1 2 3 4 1 3 4 4 0 Binge
 82 0 1 1 3 2 2 1 3 0 3 1 3 1 1 3 1 3 3 0 1 3 3 2 1 0 2 1 1 3 1 0 1 Binge
 83 2 2 2 1 0 2 0 2 2 0 3 0 0 2 0 0 0 0 3 3 0 0 0 3 1 0 1 0 1 1 1 2 Control
 84 3 2 3 3 0 0 0 3 4 2 0 2 3 0 2 4 0 3 3 2 1 3 1 2 0 1 0 3 2 0 0 4 Binge
 85 0 1 1 3 4 3 4 2 1 4 2 3 3 3 3 0 3 4 0 0 4 4 3 0 4 3 4 0 3 3 4 0 Control
 86 3 3 3 4 4 4 4 4 3 3 4 3 2 4 2 3 4 3 2 4 3 3 2 2 4 4 4 3 4 4 4 3 Binge
 87 1 0 0 2 3 3 2 4 2 1 3 0 0 4 1 0 3 1 0 1 1 1 1 1 4 0 3 1 0 3 3 1 Control
 88 2 2 2 4 4 1 4 4 1 3 2 3 4 0 4 2 4 4 2 1 4 4 3 2 1 3 4 2 4 4 4 2 Binge
 89 4 4 4 2 2 1 0 3 4 2 2 3 4 1 3 4 3 2 3 3 1 2 4 4 2 2 1 3 2 1 1 4 Steady
 90 0 0 0 3 3 4 3 1 0 2 2 1 1 4 2 0 3 2 0 0 4 2 4 0 3 3 3 0 2 3 4 0 Binge
 91 2 2 3 3 0 4 0 4 3 4 4 1 3 4 4 2 0 2 3 3 1 2 2 3 3 2 0 3 1 0 0 2 Binge
 92 0 0 0 3 0 1 1 2 0 3 3 4 3 1 3 0 0 3 0 0 4 4 4 0 1 3 0 0 4 1 1 0 Binge
 93 4 4 4 1 1 1 1 0 4 0 1 1 1 1 2 4 2 2 3 4 0 1 0 4 0 0 1 4 0 1 1 4 Control
 94 0 0 0 2 0 0 1 0 0 0 0 0 0 2 0 1 1 0 1 0 0 0 1 1 0 0 1 1 0 0 2 0 Control
 95 2 1 4 4 0 2 1 4 3 4 1 4 4 2 4 2 0 4 2 2 4 4 4 2 1 4 0 2 4 0 0 1 Binge
 96 3 1 1 2 0 3 1 1 0 0 4 1 3 4 1 1 0 1 0 1 2 0 1 3 3 1 1 2 1 0 0 1 Control
 97 2 2 1 4 1 4 2 4 2 4 3 4 4 3 4 2 2 4 2 3 4 4 4 1 3 4 3 1 4 2 1 2 Binge
 98 1 0 0 4 0 2 1 4 1 4 3 4 4 3 4 1 0 4 1 2 4 4 4 1 2 4 0 1 4 0 0 1 Binge
 99 4 4 4 4 2 4 2 3 4 4 4 4 4 3 4 4 4 3 4 4 4 4 4 4 4 3 1 4 4 3 2 4 Binge
100 0 0 0 2 1 1 1 2 0 2 4 2 2 3 3 0 2 1 0 0 3 3 2 0 3 2 0 0 2 2 1 0 Control
;
data Gamble_valid;   
length type $8.;  
input sub $ dsm1-dsm12 ga1-ga20 type $; 
     %makelabels; 
datalines; 
  1 3 3 3 1 0 0 0 1 3 0 0 2 3 0 3 3 0 1 4 3 1 1 0 4 1 1 0 3 0 0 0 4 Steady
  2 2 2 4 0 4 3 4 1 2 0 3 0 1 4 2 4 4 2 2 2 1 2 1 3 4 2 4 2 1 4 3 2 Control
  3 3 3 4 4 1 2 1 4 4 3 2 2 2 2 2 4 1 3 4 2 2 3 3 4 2 4 0 3 4 0 2 3 Binge
  4 0 1 0 2 2 2 3 4 0 4 4 2 4 3 4 0 2 2 0 0 4 4 3 0 3 4 4 0 3 2 2 0 Binge
  5 0 0 0 0 3 4 4 1 2 1 2 0 0 3 0 2 4 0 1 0 1 0 0 1 4 1 4 2 1 3 4 1 Steady
  6 1 0 0 1 1 1 0 1 0 2 1 1 1 2 3 1 1 1 0 1 1 1 1 1 0 2 2 1 1 2 0 0 Control
  7 1 1 2 1 2 2 4 1 0 1 0 3 3 2 3 0 2 4 1 1 2 2 2 0 1 2 2 2 2 3 2 1 Control
  8 3 4 4 4 3 1 4 4 2 3 2 4 3 2 3 4 0 3 3 4 3 2 4 3 1 3 4 3 2 1 1 3 Binge
  9 2 1 1 2 1 3 2 1 3 1 0 2 2 2 0 1 1 0 2 1 1 2 1 3 1 0 0 0 1 0 1 3 Control
 10 2 3 1 1 1 2 0 1 2 1 4 1 1 3 0 2 1 1 2 2 2 1 1 3 2 1 0 1 2 0 0 2 Steady
 11 2 2 2 0 0 4 0 0 3 0 4 0 0 4 0 1 0 0 1 2 1 0 0 0 4 0 1 2 0 1 0 1 Control
 12 4 4 4 2 2 3 2 2 4 3 2 1 3 0 1 4 1 2 4 3 1 1 3 4 0 3 2 4 2 3 2 4 Control
 13 3 1 2 4 1 2 1 4 3 4 2 4 3 3 1 2 3 4 3 3 3 3 4 3 3 3 2 3 4 1 1 1 Control
 14 1 0 2 2 1 4 1 3 0 2 2 2 2 2 3 2 4 3 1 1 2 2 2 1 3 2 2 1 4 3 4 0 Control
 15 4 4 2 1 1 0 4 1 4 1 1 1 1 1 2 4 3 0 4 4 0 0 1 4 1 2 4 4 1 4 3 3 Steady
 16 1 2 1 4 0 1 1 4 1 4 3 3 4 2 4 2 0 4 0 1 3 4 3 1 2 4 0 1 4 3 2 1 Binge
 17 4 4 4 3 2 3 1 3 4 1 2 2 3 3 1 4 2 1 4 4 3 2 1 4 0 2 4 4 0 0 3 4 Binge
 18 3 4 1 3 4 2 3 3 3 1 2 1 2 2 1 2 3 1 2 2 1 2 1 3 2 2 4 3 0 4 4 3 Binge
 19 2 1 2 2 0 1 0 3 2 4 2 2 2 1 3 1 0 0 1 1 1 1 3 2 1 2 0 3 2 0 0 3 Control
 20 1 1 3 0 2 1 2 0 2 1 0 0 1 0 0 2 2 0 2 2 0 0 0 2 0 1 3 3 0 4 4 1 Control
 21 1 3 2 1 2 1 0 1 2 3 2 1 1 4 1 0 1 3 3 3 3 1 2 2 2 4 1 2 3 0 1 2 Control
 22 0 2 3 4 4 0 4 3 1 2 3 2 4 0 3 2 4 1 0 2 3 2 2 2 2 3 4 2 2 4 3 0 Binge
 23 0 1 1 0 3 3 2 0 2 1 3 0 0 2 1 2 2 1 1 1 2 0 0 2 3 0 3 0 1 1 3 1 Control
 24 0 0 0 3 1 1 3 2 1 1 4 1 2 1 0 0 2 1 0 0 2 3 3 1 2 2 0 1 2 0 3 0 Control
 25 4 4 4 1 0 1 0 0 4 0 2 0 0 0 0 4 0 0 4 4 2 0 0 4 1 1 0 4 3 0 1 4 Steady
 26 0 3 4 3 2 4 2 3 1 4 3 4 3 3 4 3 4 4 2 1 4 3 4 2 3 4 4 2 3 3 3 2 Binge
 27 2 1 0 0 3 0 3 2 1 0 1 1 1 0 1 3 4 1 2 3 2 1 2 3 0 0 3 2 1 3 3 2 Control
 28 3 4 2 1 1 4 3 1 2 0 4 0 0 4 1 3 3 0 2 4 2 0 0 4 4 1 1 3 0 2 2 3 Steady
 29 4 3 4 1 1 0 0 1 4 0 0 1 0 0 1 4 0 1 4 4 0 2 2 3 2 0 0 4 0 1 1 4 Steady
 30 4 4 4 2 4 2 4 1 3 3 2 1 4 1 2 4 4 3 2 3 4 2 1 3 2 2 4 4 2 4 4 4 Steady
 31 2 2 2 0 1 2 1 1 3 0 2 0 0 3 1 3 1 0 2 4 0 0 1 3 1 0 2 2 0 1 3 3 Control
 32 4 2 4 4 3 0 3 3 3 4 2 4 2 1 4 4 4 3 3 3 4 4 2 4 1 4 4 4 4 2 3 3 Binge
 33 3 2 4 2 4 1 3 0 4 2 1 1 2 1 2 2 4 0 3 2 1 0 2 2 1 1 4 4 1 4 3 4 Steady
 34 1 3 4 1 4 4 4 1 1 1 3 1 0 4 0 2 2 0 3 3 1 0 0 2 4 1 4 4 0 3 2 4 Control
 35 1 1 0 3 3 0 3 4 1 4 0 4 2 0 3 1 2 4 1 1 3 2 3 2 1 3 2 1 3 3 3 0 Control
 36 3 3 2 0 4 0 2 1 3 3 1 2 1 0 1 2 4 0 3 2 1 1 2 1 1 0 3 3 0 2 4 0 Control
 37 3 3 4 3 1 2 2 4 4 2 3 3 3 4 2 4 1 4 4 4 3 3 4 3 3 4 0 4 4 2 1 3 Control
 38 3 3 1 2 3 4 2 0 4 1 3 1 0 4 0 2 4 1 4 1 0 1 1 2 4 0 4 1 0 2 4 4 Steady
 39 3 3 3 0 4 1 4 1 4 0 4 0 0 2 1 4 4 1 3 4 0 1 0 2 2 0 4 4 0 4 4 3 Steady
 40 3 4 3 3 0 1 0 2 3 2 1 4 2 0 3 4 2 2 4 4 2 3 3 3 1 3 2 4 3 2 1 4 Steady
 41 2 3 1 3 4 4 4 4 2 3 4 4 4 4 4 3 4 4 2 1 4 4 4 2 4 4 3 0 3 3 2 2 Control
 42 3 2 2 0 3 0 3 2 0 0 0 0 1 1 1 3 3 2 1 1 1 2 1 3 0 2 4 2 1 4 2 1 Control
 43 0 1 1 2 3 0 2 4 0 2 0 3 4 1 4 1 3 3 2 0 3 4 3 1 1 4 3 0 3 4 4 1 Control
 44 3 3 3 2 4 2 4 2 3 3 0 3 2 1 2 2 4 1 4 1 2 4 3 2 0 3 4 3 2 4 3 3 Steady
 45 0 1 0 2 3 4 2 3 0 3 4 2 1 4 3 0 1 2 0 0 3 2 0 0 3 2 3 0 4 2 3 0 Control
 46 1 1 0 0 0 2 2 0 1 1 3 0 1 3 0 0 1 1 0 0 0 0 0 0 3 0 1 1 1 2 2 1 Control
 47 4 4 4 0 0 3 0 0 4 0 0 1 1 3 1 4 0 0 4 3 0 2 0 4 0 1 0 4 2 0 0 4 Steady
 48 1 0 1 4 1 3 3 3 0 3 1 3 2 2 3 0 2 3 0 0 2 4 4 0 3 4 2 1 3 1 0 0 Steady
 49 0 1 0 0 0 3 0 1 0 4 4 2 2 4 2 0 2 2 1 0 1 1 1 0 4 0 1 0 1 0 0 0 Control
 50 3 4 3 3 4 3 4 2 3 3 3 1 3 3 2 4 2 1 4 4 1 2 3 2 1 1 3 3 3 3 1 3 Steady
 51 0 1 0 4 2 4 0 3 0 4 4 4 3 2 4 1 1 3 0 1 3 3 4 0 4 4 2 0 4 3 2 1 Binge
 52 0 1 1 0 3 0 3 0 0 1 0 0 0 0 0 0 3 0 1 1 0 0 0 0 0 0 3 1 0 3 1 0 Control
 53 0 2 1 0 1 0 0 0 1 0 0 0 1 0 0 1 0 2 0 0 0 0 0 1 0 0 0 0 1 1 0 1 Control
 54 1 0 1 1 4 0 4 2 2 2 1 3 0 0 1 0 4 2 0 2 3 1 2 0 0 1 4 1 3 4 2 1 Control
 55 0 0 2 1 2 1 1 2 1 2 1 4 3 0 1 0 1 4 3 1 2 1 3 0 1 2 3 0 3 2 1 1 Binge
 56 1 2 2 0 3 1 3 2 1 3 0 2 2 0 1 1 2 3 0 2 1 2 2 1 1 2 2 1 2 1 1 2 Control
 57 4 4 3 1 2 2 3 2 4 4 2 1 2 1 3 3 4 2 4 4 2 2 0 4 1 4 3 4 2 1 1 4 Steady
 58 4 3 4 1 2 0 1 0 4 0 0 0 0 0 0 3 2 0 2 1 0 0 2 4 0 0 1 4 0 2 2 3 Steady
 59 0 0 0 1 3 3 3 1 0 0 2 0 0 3 0 1 1 0 0 1 1 0 0 0 3 0 1 0 0 0 3 0 Control
 60 1 0 0 2 4 3 3 1 0 1 2 2 3 2 2 0 4 3 1 0 1 3 4 0 3 2 4 0 3 4 4 0 Control
 61 2 2 3 1 1 0 2 0 3 2 1 0 0 1 2 2 3 1 2 2 1 1 0 0 0 0 2 0 0 2 3 2 Control
 62 1 1 0 0 1 1 2 0 3 0 0 0 1 0 0 3 0 1 1 3 0 0 1 2 0 1 1 3 0 0 1 1 Binge
 63 2 4 2 2 0 3 0 0 2 2 4 2 0 3 4 2 0 3 3 2 3 3 2 3 3 2 0 3 2 1 0 3 Control
 64 2 2 1 0 4 3 4 1 1 0 4 1 1 0 1 1 4 0 3 2 0 1 1 2 4 0 1 3 1 3 4 2 Control
 65 2 4 3 3 2 2 1 2 3 2 2 3 2 3 3 3 2 2 0 4 3 2 1 2 3 1 2 3 3 1 4 3 Binge
 66 0 2 0 3 3 1 1 1 2 1 0 3 1 2 1 0 1 0 1 0 2 3 1 0 0 1 1 2 2 2 1 2 Binge
 67 0 0 1 4 4 4 4 4 1 4 4 4 4 4 4 1 4 4 0 0 4 4 1 0 4 3 4 0 3 4 4 0 Binge
 68 3 4 2 0 0 3 0 1 3 2 1 1 1 1 2 3 0 1 2 4 2 1 1 4 2 3 1 2 2 1 1 3 Steady
 69 3 3 4 3 3 3 3 3 3 3 3 4 3 4 2 4 1 3 4 4 4 2 4 3 4 3 2 4 4 2 3 3 Binge
 70 2 0 1 4 0 2 1 3 1 4 0 4 3 1 3 1 1 4 1 1 3 4 3 0 3 3 0 0 4 1 2 3 Binge
 71 4 3 3 3 4 1 4 4 2 4 1 4 4 0 4 4 1 4 3 4 4 3 3 3 0 4 3 3 3 3 4 3 Binge
 72 2 3 3 3 3 3 3 4 3 2 3 3 4 4 4 4 3 3 4 4 2 4 4 3 3 4 3 4 4 4 1 3 Control
 73 0 0 2 3 4 3 3 3 1 3 3 4 3 4 2 2 3 4 2 3 2 3 4 2 4 2 2 1 4 3 3 2 Binge
 74 4 4 3 2 2 1 3 2 3 2 2 2 0 2 3 3 2 3 4 3 3 1 1 4 2 4 2 4 2 2 0 4 Steady
 75 4 2 2 1 1 3 0 1 3 1 2 2 0 2 0 3 0 3 4 2 3 4 3 4 3 0 1 4 2 0 0 2 Steady
 76 3 2 2 4 3 3 4 4 2 4 0 4 4 2 4 2 2 4 3 1 4 4 4 4 4 4 3 1 4 4 3 2 Binge
 77 4 3 3 4 0 3 0 4 4 4 3 3 4 1 3 4 0 2 3 2 3 4 3 4 4 2 0 4 3 0 0 4 Binge
 78 3 3 4 4 3 0 2 2 2 3 0 2 4 1 2 3 2 2 3 3 3 4 3 2 2 2 1 2 2 3 3 3 Binge
 79 3 3 3 4 2 4 2 3 3 3 1 4 3 3 4 4 0 4 4 3 4 2 4 3 2 1 2 3 1 3 1 4 Binge
 80 2 4 0 1 2 3 3 1 2 1 4 0 0 3 0 1 2 2 2 1 0 0 1 0 3 2 3 0 1 3 3 0 Control
 81 1 0 0 3 4 2 4 3 0 4 4 4 4 1 4 0 3 4 1 0 3 4 4 1 2 3 4 2 3 4 4 0 Binge
 82 0 1 1 3 2 2 1 3 1 3 0 3 1 1 3 1 3 3 1 1 3 3 2 1 0 2 1 1 3 1 1 1 Binge
 83 2 1 2 1 0 2 0 2 2 0 3 0 0 2 0 0 0 0 3 3 0 0 0 3 1 1 1 0 1 0 2 2 Steady
 84 3 2 3 3 0 0 0 3 4 2 0 2 3 0 1 3 0 3 3 3 1 3 1 2 0 1 0 4 2 0 0 3 Binge
 85 0 1 1 4 4 4 4 2 1 4 2 3 3 3 3 0 3 4 0 0 4 4 3 0 4 3 4 0 3 3 4 0 Control
 86 3 3 3 3 4 4 4 4 3 3 4 3 2 4 2 2 4 4 2 4 3 3 2 2 4 4 4 3 4 4 4 3 Binge
 87 1 0 0 2 3 4 3 4 2 1 3 0 0 4 1 0 3 1 0 1 0 1 1 1 4 0 3 1 1 4 3 1 Control
 88 2 2 2 4 4 1 4 4 0 2 2 4 3 0 4 2 4 4 2 1 4 4 3 2 1 3 4 2 4 4 4 2 Binge
 89 4 4 4 2 2 0 1 3 4 1 2 3 4 1 2 4 3 2 3 3 1 2 4 4 2 3 1 2 2 1 2 4 Steady
 90 0 0 0 3 3 4 3 1 0 2 2 0 0 4 2 0 3 2 0 0 4 2 4 0 3 3 3 0 2 2 4 0 Binge
 91 2 2 3 3 0 4 0 4 3 4 4 1 3 4 4 1 0 2 3 3 2 2 2 4 3 1 0 3 1 0 0 2 Binge
 92 0 0 0 3 0 0 1 2 0 3 3 4 3 1 3 0 0 3 0 0 4 4 4 0 1 3 0 0 4 0 1 0 Binge
 93 4 4 4 1 1 1 1 0 4 0 1 0 1 1 2 4 2 2 3 3 0 2 0 4 0 0 1 4 0 1 1 4 Control
 94 0 0 0 3 0 0 1 0 0 0 1 0 0 2 0 0 1 0 1 0 0 0 1 2 1 0 1 0 0 0 2 0 Control
 95 2 1 4 4 0 2 1 4 3 4 1 4 3 2 4 2 0 4 2 2 4 4 4 2 1 4 0 2 4 0 0 0 Binge
 96 3 1 1 2 0 3 1 1 0 0 4 1 3 4 2 1 0 1 0 1 1 0 1 3 3 1 1 2 1 0 0 0 Control
 97 2 2 1 4 0 4 3 3 2 4 3 3 4 3 4 2 2 4 2 3 4 4 3 1 3 4 3 1 4 2 1 2 Binge
 98 1 1 0 3 0 2 2 4 1 4 3 4 4 3 3 1 0 4 1 2 4 4 4 1 2 4 0 1 4 0 0 1 Binge
 99 4 4 4 4 2 4 2 4 4 3 4 4 4 3 4 4 4 3 4 4 4 4 4 4 4 3 1 4 4 3 3 4 Binge
100 0 0 1 2 0 1 1 3 0 2 4 2 1 3 3 0 2 1 0 0 3 3 2 0 3 2 0 0 2 2 1 0 Control
 ;  
 proc means n data=gamblers; run;


 
/*PRINP ANALYSIS*/
 /*DSM:Diagnostics and statistics manual data*/ 
 /*GA: Gamblers anonomous*/ 
 ods trace on;
 ods graphics on;

 /*ORGINAL DATASET*/ 
/*renaming all questions based on the factor they are represented by in orginal four factor */ 
data gamblersaa(rename=(ga9=ga9_f1 ga17=ga17_f1 ga10=ga10_f1 ga6=ga6_f1 ga14=ga14_f1 ga3=ga3_f1 ga1=ga1_f1 ga11=ga11_f1 ga4=ga4_f2 ga12=ga12_f2 ga20=ga20_f2 ga8=ga8_f2 ga7=ga7_f2 ga16=ga16_f2 ga15=ga15_f3 ga18=ga18_f3 ga5=ga5_f3 ga19=ga19_f3 ga2=ga2_f4 ga13=ga13_f4));
set gamblers(keep=ga1-ga20 sub type);
run;

/*using 3 princp we can explain ~ 70% of variation*/ 
proc princomp data=gamblersaa plots(unpack)=pattern out=prinp_g outstat=gambler_out ;
run;

/*LOGISTIC USING PRINP*/
/*prin1 sig*/ 
proc logistic data=prinp_g;
model type(event='Control')= prin1 prin2 prin3 prin4 /clodds=pl  LINK=CLOGIT ;
run;
/********************/
/*END PRINP ANALYSIS*/
/*******************/

/*****************/
/*FACTOR ANALYSIS*/ 
/*****************/
/*1.look at eigenvalues: largest eigenvalue corrosponds to the eigenvector that explains the greatest proportion of total vairance*/ 
/*2.look at Factor Loading Matrix (factor pattern): 
		-Each row of the factor loadings tells you the linear combination of the factor or 
		component scores that would yield the expected value of the associated variable.
		-The factor loadings indicate how strongly the variables and the factors/components are related
*/

/*Factor Analyisis Including all 20 questions*/ 
/*last two factors donot provide much information about weather or not a gambler is binge or steady*/
proc factor data=gamblersaa nfactors=4 out=everything reorder outstat=factors score simple corr plots=all;
run;

/*LOGISTIC REGRESSION USING FACTORS*/
proc logistic data=everything;
model type(event='Binge') = Factor1 Factor2 Factor3 Factor4 / clodds=pl clparm=pl;
run;


/*DATASET WITHOUT QUESTIONS GROUPED in Factor 3 and Factor 4*/ 
/*removing ga5 ga15 ga18 ga19 ga13 and ga2*/
data gamblersaa_edit /*(rename=(ga9=ga9_f1 ga17=ga17_f1 ga10=ga10_f1 ga6=ga6_f1 ga14=ga14_f1 ga3=ga3_f1 ga1=ga1_f1 ga11=ga11_f1 ga4=ga4_f2 ga12=ga12_f2 ga20=ga20_f2 ga8=ga8_f2 ga7=ga7_f2 ga16=ga16_f2 ))*/;
set gamblers(keep=ga1 ga3 ga4 ga6 ga7 ga8 ga9 ga10 ga11 ga12 ga14 ga16 ga17 ga20 sub type);
run;proc print;run;

ods graphics on;
proc factor data=gamblersaa_edit nfactors=2 out=everything1 reorder outstat=factors score simple corr plots=all;
run;

/*PROC LOGISTIC WITH THE ONLY 2 SIG FACTORS AFTER REMOVING REDUNDENT QUESTIONS FROM DATA*/ 
/*factor1 is sig, Factor 2 is sig @ .06 level*/ 
proc logistic data=everything1;
model type(event='Binge') = factor1 factor2 /clodds=pl ;
run;
/*********************/
/*END FACTOR ANALYSIS*/ 
/********************/


/************************/
/*COMMON FACTOR ANALYSIS*/
/************************/

/*PURPOSE: ROTATES FACTOR AXIES TO ENCOMPASS MAXIMUM VARIABILITY ON EACH FACTOR AXIS*/ 
/*PRODUCES MUCH BETTER LOGISTIC REGRESSION*/

/*1. check Kaisers MSA to determine if common factor model can be used : for each variable a value above .8 is good, and below .5 is unexeptable*/
/*Original Data*/ 
proc factor data=gamblersaa
	priors=smc msa residual
	rotate=promax reorder
	nfactors=4 
	outstat=fact_all
	out= orginal_info 
	plots=(scree initloadings preloadings(vector) loadings);
	run;

/*Using COMMON FACTOR analyisis we get FACTOR 1 and FACTOR 2 SIG @ .01 Level*/ 
proc logistic data=orginal_info plots(unpack)= all;
model type(event='Binge')= Factor1 Factor2 Factor3 Factor4 /clodds=pl clparm=pl;
run;

/*DATASET WITHOUT questions grouped in Factor 3 and Factor 4*/ 
proc factor data=gamblersaa_edit
	priors=smc msa residual
	rotate=promax reorder
	nfactors=2
	out=edited_info
	outstat=fact_all
	plots=(scree initloadings preloadings(vector) loadings);
	run;

	

/*LOGISTIC MODEL USING EDITED DATA*/
/*Factor1 and Factor2 are sig*/ 
/*EXACT SAME AS MODEL WITH ALL FOUR 'COMMON' FACTORS*/ 
proc logistic data=edited_info;
model type(event='Binge') = Factor1 Factor2 / clparm=pl clodds=pl;
run;

/******************/
/*END ALL ANALYSIS*/ 
/******************/

/*looking at the principle componenets graphicaly*/ 
proc print data=fact_all;run;
proc transpose data=fact_all out=factors1(keep=_name_ _label_ factor1--factor2);
run;

proc sgscatter data=gambler_out_t;
compare x=prin1 y=prin2 / datalabel=_name_ group=_name_ ;
run;


/*Next: RUN VALIDATION DATA to see how well the factors do at classifying the data*/ 

data gamble_valid_test;
set gamble_valid;
run; 



