function [population] = initPopulation (grammar, n)
%Funkcja odpowiedzialna za wygenerowanie populacji pocz�tkowej
%
%Parametry wyj�ciowe:
%population - zestaw osobnik�w sk�adaj�cych si� z prawdopodobie�stw
%przypisanych do poszczeg�lnych regu�
%
%n - liczba osobnik�w w populacji
population=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex));

for i=1:n
    for j=1:length(grammar.rules.Lex)+length(grammar.rules.NonLex)
        population(i,j)=rand;
    end
end

[population] = scaleRulesProb (grammar,population);

end