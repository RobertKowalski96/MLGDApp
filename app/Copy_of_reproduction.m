function [population] = reproduction(population,points, reproductionProb)

[n,m] = size(population);
populationT = zeros(n,m);

%Creating populationT

pointsSum = sum(points);
points2 = points/pointsSum;
points3 = cumsum(points2);

best=find(points==1,1);
populationT(1,:) = population(best,:);
for i = 2:n
    x=rand;
    found = find(points3>x, 1);
    populationT(i,:) = population(found,:);
end


%Reproduction
for i=1:n/2
   
    x=rand;
    if x<=reproductionProb
        
        x = randi([1 m]);
        population(((i-1)*2)+1,1:x) = populationT(((i-1)*2)+2,1:x);
        population(((i-1)*2)+1,x:m) = populationT(((i-1)*2)+1,x:m);
        population(((i-1)*2)+2,1:x) = populationT(((i-1)*2)+2,1:x);
        population(((i-1)*2)+2,x:m) = populationT(((i-1)*2)+1,x:m);
    else
        population(((i-1)*2)+1,:) = populationT(((i-1)*2)+1,:);
        population(((i-1)*2)+2,:) = populationT(((i-1)*2)+2,:);
    end
end
end