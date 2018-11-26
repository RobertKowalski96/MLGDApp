function [population] = reproduction(population,points, reproductionProb)

[n,m] = size(population);
populationT = zeros(n,m);

%Creating populationT
popTnumber=1;
while popTnumber<n+1
        for i=1:n
        x=rand;
        if x<points(i)
            %i
           populationT(popTnumber,:) = population(i,:);
            popTnumber=popTnumber+1;
            if popTnumber==n
               break 
            end
        end
        end 
end
%populationT
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