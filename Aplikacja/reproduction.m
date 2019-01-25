function [populationT1] = reproduction(population,points, reproductionProb)
%Funkcja odpowiedzialna za przeprowadzanie procesu reprodukcji i
%krzy¿owania

pointsScaled = zeros(1,length(points));
bestResult=max(points);
for i=1:length(points)
    pointsScaled(i)=bestResult/points(i);
end

[n,m] = size(population);
populationT = zeros(n,m);

%Tworzenie populacji Tymczasowej T

pointsSum = sum(pointsScaled);
points2 = pointsScaled/pointsSum;
points3 = cumsum(points2);

for i = 1:n/2
    x=rand;
    found = find(points3>x, 1);
    populationT(i,:) = population(found,:);
end

%Crossing Over
[n,m] = size(population);
populationT1 = zeros(n/2, m);
for i=1:n/4
    
    x=rand;
    if x<=reproductionProb
        
        x = randi([1 m]);
        populationT1(((i-1)*2)+1,1:x) = populationT(((i-1)*2)+2,1:x);
        populationT1(((i-1)*2)+1,x:m) = populationT(((i-1)*2)+1,x:m);
        populationT1(((i-1)*2)+2,1:x) = populationT(((i-1)*2)+2,1:x);
        populationT1(((i-1)*2)+2,x:m) = populationT(((i-1)*2)+1,x:m);
    else
        populationT1(((i-1)*2)+1,:) = populationT(((i-1)*2)+1,:);
        populationT1(((i-1)*2)+2,:) = populationT(((i-1)*2)+2,:);
    end
end
end