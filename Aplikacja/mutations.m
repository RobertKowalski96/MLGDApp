function [population] = mutations(population,mutationProb,mutationScale)
%Funkcja odpowiadaj�ca za przeprowadzanie mutacji na danej populacji
%
%parametry wej�ciowe:
%
%population - populacja na kt�rej przeprowadza mutacje
%
%mutationProb � prawdopodobie�stwo zaj�cia mutacji
%
%mutationScale � maksymalna skal� mutacji
%
%parametry wyj�ciowe: 
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