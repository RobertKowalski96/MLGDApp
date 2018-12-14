clc,clear all


points = [0.75; 0.20; 0.05];

suma=sum(points);

points2=points/suma;

points3=cumsum(points2);


pop=[0; 0; 0];
for i=1:10000
    x=rand;
    
   found = find(points3>x, 1);
   pop(found)=pop(found)+1;
    
end
    

