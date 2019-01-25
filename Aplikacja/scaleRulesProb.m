function [population] = scaleRulesProb (grammar,population)
%Funkcja odpowiadaj�ca za skalowanie prawdopodobie�stw regu� o tym samym
%poprzedniku w taki spos�b, aby ich suma wynosi�a 1
[n,~] =size(population);

for i=1:n
    rulesProb = population(i,:);
    for j=1:length(grammar.rules.connections)
        idx=cell2mat(grammar.rules.connections(j));
        sameSum=sum(rulesProb(idx));
        rulesProb(idx)=rulesProb(idx)/sameSum;
    end
    population(i,:) = rulesProb;
end

end

