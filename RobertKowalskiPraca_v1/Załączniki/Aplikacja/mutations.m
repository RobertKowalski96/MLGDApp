function [population] = mutations(population,mutationProb,mutationScale)
 
[n,m] = size(population);

for i=1:n
   
    for j=1:m
        x=rand;
        if x<mutationProb
            y = randi([1 2]);
            z=0.01+rand*(mutationScale-0.01);
            if y==1
               population(i,j)=population(i,j)+z;

            else
                if population(i,j)>z
                population(i,j)=population(i,j)-z;
                else
                    population(i,j)=0;
                end
            end
        end
        
    end
    
end



end