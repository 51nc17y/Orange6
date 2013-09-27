ods html close; ods listing; ods listing gpath="%sysfunc(pathname(work))";

* (1) Input and standardize data *; 
DATA D_2; INPUT X1 X2 @@; 
x1=(x1-6)/sqrt(10.25); X2=(X2-7)/sqrt(6);
cards; 
2 3   12 10   6 7   9 9   7 10   3 5   3 6   7 8   5 5
 ; 
PROC PRINT data=D_2; VAR X1 X2; run; 
PROC MEANS MEAN STD USS VAR data=D_2; 
VAR X1 X2; run; 

* (2) Plot original data *; 
PROC SGPLOT data=D_2; 
SCATTER X=X1 Y=X2; 
run; 

* (3) Compute principal components *; 
PROC PRINCOMP data=D_2 out=PRINOUT; VAR X1 X2; 
PROC PRINT data=PRINOUT; run; 

* (4) Show that principal components come from SVD *; 
PROC IML; reset spaces = 6; 
USE PRINOUT;                                     * data set to use          ; 
READ ALL VAR{X1 X2} INTO X;                      * variables into matrices  ; 
READ ALL VAR{PRIN1 PRIN2} INTO P; 
  PRINT X P; 
CALL SVD(L,D,R,X);                               * Singular value decomposition;
D22 = Diag(D); LD=L*diag(D);                    
CHECK = L*D22*R`;                                * Check SVD                ; 
  PRINT CHECK X;  
  PRINT L D22 LD;                                 
LINEARCOMBO=X*R;                                 * Compute PCs from SVD     ; 
  PRINT LD LINEARCOMBO P; 

Data graph; Set D_2; output;                     * Compute axis endpoints   ; 
XX1=2*sqrt(1.87666798); XX2=XX1; output;         * +/- 2 std deviations =   ;
XX2=-1*XX1; XX1=XX2; output;                     * +/- 2 singular values    ; 
ZZ1=2*sqrt(0.12333202); ZZ2=-ZZ1; output;         
ZZ2=ZZ1; ZZ1=-ZZ2; output;  

proc sort data=graph; by X1; 
ODS graphics/ width = 5 in  height = 5 in; 
proc sgplot; 
scatter X=X1 Y=X2; 
series X=XX1 Y=XX2; 
series X=ZZ1 Y=ZZ2; 
run; 
