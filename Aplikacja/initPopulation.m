function [population] = initPopulation (grammar, n)
%Funkcja odpowiedzialna za wygenerowanie populacji pocz¹tkowej
%
%Parametry wyjœciowe:
%population - zestaw osobników sk³adaj¹cych siê z prawdopodobieñstw
%przypisanych do poszczególnych regu³
%
%n - liczba osobników w populacji
population=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex));

for i=1:n
    for j=1:length(grammar.rules.Lex)+length(grammar.rules.NonLex)
        population(i,j)=rand;
    end
end

[population] = scaleRulesProb (grammar,population);

end