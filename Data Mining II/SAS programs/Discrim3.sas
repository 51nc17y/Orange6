
PROC IML; 
S = {7.5 7.5 6.25, 7.5 25 12.5, 6.25 12.5 31.25};  
IN = inv(S); 
m1 = {2,-1,1}; m2 = {-2,0,1}; m3 = {1,-1,1}; 
print S in m1 m2 m3; 
D1 =-0.5*m1`*in*m1||(m1`*IN);
D2 =-0.5*m2`*in*m2||( m2`*IN);
D3 =-0.5*m3`*in*m3||( m3`*IN);
D = D1//D2//D3; 

X = {1,2,3};
discriminant = D*({1}//X); 
print D X discriminant;
