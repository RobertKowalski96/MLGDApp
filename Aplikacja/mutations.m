function [population] = mutations(population,mutationProb,mutationScale)
%Funkcja odpowiadaj¹ca za przeprowadzanie mutacji na danej populacji
%
%parametry wejœciowe:
%
%population - populacja na której przeprowadza mutacje
%
%mutationProb – prawdopodobieñstwo zajœcia mutacji
%
%mutationScale – maksymalna skalê mutacji
%
%parametry wyjœciowe: 
%population - populacja po przeprowadzeniu mutacji
[n,m] = size(population);
for i=1:n
    for j=1:m
        x=rand;
        if x<mutationProb
            z=0.01+rand*(mutationScale-0.01);
            y = randi([1 2]);
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