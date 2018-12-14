clc, clear all
A=[3,4,5,4,5,2,3,4,6,5]

B=zeros(1,10);

for i=1:10
   B(i)=0.5.^A(i);
end

C=log(B)

D=sum(C)/10
