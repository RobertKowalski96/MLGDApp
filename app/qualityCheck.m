function [points,points2,population, badMutations] = qualityCheck (population,populationPreMutations, grammar, sentences, badMutations)

[n,m] =size(population);

score = zeros(length(sentences),n);

i=1;
while i <= n
    
    for j = 1 : length(sentences)
        [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:));
        if prob == 0
            population(i,:) = populationPreMutations(i,:);
            badMutations = badMutations + 1;
            i=i-1;
            break
        else
            score(j,i)=log(prob);
        end
    end
    
    i=i+1;
end

points2=sum(score);
points=sum(score);
bestResult=max(points);
%points=points/bestResult;

for i=1:length(points)
    points(i)=bestResult/points(i);
end