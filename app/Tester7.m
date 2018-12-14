%clc, clear all


Test=[points2.', points.', population]

Test2=sortrows(Test, 2);
Test2=flipud(Test2);

points2=Test2(:,1).';
points2=points2

populationT2 = OldPopPoints(1:n/2,3:end);