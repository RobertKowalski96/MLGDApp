function [population] = reproduction(population,points, reproductionProb)

[n,m] = size(population);
populationT = zeros(n,m);

%Creating populationT
popTnumber=0;
while popTnumber>m;
        for i=0:m
        x=rand;
        if x<points(i)
           populationT(m,:) = population(i,:);
            popTnumber=popTnumber+1;
            if popTnumber==m
               break 
            end
        end
        end 
end

%Reproduction
for i=1:m/2
   
    x=rand;
    if x<=reproductionProb
        
        x = randi([1 n]);
        population(i,1:x) = populationT(i,1:x);
        population(i,x:n) = populationT(i,x:n);
        population(i+1,1:x) = populationT(i+1,1:x);
        population(i+1,x:x) = populationT(i+1,x:n);
    else
        population(i,:) = populationT(i,:);
        population(i+1,:) = populationT(i+1,:);
    end
end
end