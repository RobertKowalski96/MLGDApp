function [grammar] = initRulesProb(grammar)

i=1;
while i<length(grammar.rules)
    same=1;
    while grammar.rules{i,1}==grammar.rules{i+same,1}
        if i+same+1<length(grammar.rules)+1
            same=same+1;
        else same=same+1; break
        end
    end
    
    if same==1
        grammar.rulesProb(i)=1;
    else
        grammar.rulesProb(i)=rand;
        for j=1:same-1
            
            prevRulesProbSum=0; %Suma prawdopodobieñstw poprzednich regu³ maj¹cych to samo po lewej stronie
            for jj=0:j-1

                prevRulesProbSum=prevRulesProbSum+grammar.rulesProb(i+j-jj-1);
            end
            grammar.rulesProb(i+j)=rand*(1-prevRulesProbSum);
        end
        
        %Dla ostatniej regu³y z t¹ sam¹ czêœci¹ po lewej - dope³nienie do 1
        prevRulesProbSum=0; 
            for jj=0:j-1
                prevRulesProbSum=prevRulesProbSum+grammar.rulesProb(i+j-jj-1);
            end
            grammar.rulesProb(i+j)=1-prevRulesProbSum;
    end
    
    i=i+same;
end

if length(grammar.rules)>length(grammar.rulesProb)
    grammar.rulesProb(length(grammar.rules))=1;
end

end