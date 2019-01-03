function [points,population, lethalMutations] = qualityCheck (population,populationPreMutations, grammar, sentences, lethalMutations)

[n,~] =size(population);

points=zeros(1,n);
parfor i = 1 : n
    for j = 1 : length(sentences)
        [prob] = CYK_Probabilistic(grammar, sentences{j}, population(i,:))
        if prob == 0
            points(i)=0;
            lethalMutations = lethalMutations + 1;
            population(i,:) = populationPreMutations(i,:);
            for k = 1 : length(sentences)
                [prob] = CYK_Probabilistic(grammar, sentences{k}, population(i,:));
                points(i)=points(i)+log(prob);
            end
            break;
        else
            points(i)=points(i)+log(prob);
        end
    end
end
points=points/length(sentences);

end