function [points] = firstQualityCheck (population, grammar, sentences)

[n,~] =size(population);

points=zeros(1,n);
parfor i = 1 : n
    for j = 1 : length(sentences)
    [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:))
    points(i)=points(i)+log(prob)
    end
end
points=points/length(sentences);
end