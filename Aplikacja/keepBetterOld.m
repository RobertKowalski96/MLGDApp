function [pointsT2, populationT2] = keepBetterOld (population, points, n)
%Fucnkja odpowiedzialna za zachowanie lepiej przystosowanej po³owy
%populacji

OldPopPoints=[points.', population]; %Old population with points
OldPopPoints2=sortrows(OldPopPoints, 1);
OldPopPoints2=flipud(OldPopPoints2);

pointsT2 = OldPopPoints2(1:n/2,1).';
populationT2 = OldPopPoints2(1:n/2,2:end);

end