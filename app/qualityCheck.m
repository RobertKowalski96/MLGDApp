function [points,points2] = qualityCheck (population, grammar, sentences)

[n,m] =size(population);

score = zeros(length(sentences),n);

for i = 1 : n
    
    for j = 1 : length(sentences)
    [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:));
    score(j,i)=log(prob);
    %score(j,i)=prob;
    end
   
end

points2=sum(score);
points=sum(score);
bestResult=max(points);
%points=points/bestResult;

for i=1:length(points)
    points(i)=bestResult/points(i);
end