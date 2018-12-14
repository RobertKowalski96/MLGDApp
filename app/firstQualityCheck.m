function [points] = firstQualityCheck (population, grammar, sentences)

[n,~] =size(population);

score = zeros(length(sentences),n);

for i = 1 : n
   
    for j = 1 : length(sentences)
    [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:));
    score(j,i)=log(prob);
    end
   
end

points=sum(score)/length(sentences);
end