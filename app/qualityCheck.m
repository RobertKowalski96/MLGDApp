function [points,points2] = qualityCheck (population, grammar, sentences)

[n,m] =size(population);

score = zeros(length(sentences),n);

for i = 1 : n
    
    for j = 1 : length(sentences)
    [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:));
    score(j,i)=log(prob);
    
    end
   
end

points2=sum(score);
points=sum(score);
bestResult=min(points);
points=points/bestResult;

end