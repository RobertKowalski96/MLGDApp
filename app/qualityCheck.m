function [points,population, lethalMutations] = qualityCheck (population,populationPreMutations, grammar, sentences, lethalMutations)

[n,~] =size(population);

score = zeros(length(sentences),n);

i=1;
while i <= n
    
    for j = 1 : length(sentences)
        [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:));
        if prob == 0
            population(i,:) = populationPreMutations(i,:);
            lethalMutations = lethalMutations + 1;
            i=i-1;
            break
        else
            score(j,i)=log(prob);
        end
    end
    
    i=i+1;
end

points=sum(score)/length(sentences);
end