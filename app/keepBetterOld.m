function [pointsT2, pointsT2_2, populationT2] = keepBetterOld (population, points, points2, n)

OldPopPoints=[points2.', points.', population]; %Old population with points
OldPopPoints2=sortrows(OldPopPoints, 2);
OldPopPoints2=flipud(OldPopPoints2);

pointsT2 = OldPopPoints2(1:n/2,2).';
pointsT2_2 = OldPopPoints2(1:n/2,1).';
populationT2 = OldPopPoints2(1:n/2,3:end);

end