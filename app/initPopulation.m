function [population] = initPopulation (grammar, n)

population=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex));

for i=1:n
    for j=1:length(grammar.rules.Lex)+length(grammar.rules.NonLex)
        population(i,j)=rand;
    end
end

[population] = scaleRulesProb (grammar,population);

end