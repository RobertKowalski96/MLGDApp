function [rulesProb] = scaleRulesProb (grammar,rulesProb)

for i=1:length(grammar.rules.connections)

index=grammar.rules.connections(i);

idx=cell2mat(index);

sameSum=sum(rulesProb(idx));
rulesProb(idx)=rulesProb(idx)/sameSum;

end
end