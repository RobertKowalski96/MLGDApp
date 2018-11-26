function [population] = initRulesProb(grammar,numberOfSolutions)

%NOT ACTUALL, replaced with ScaleRulesProb

population = zeros(numberOfSolutions,length(grammar.rules));

for n=1:numberOfSolutions
    
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
            population(n,i)=1;
        else
            population(n,i)=rand;
            for j=1:same-1
                
                prevRulesProbSum=0; %Suma prawdopodobieñstw poprzednich regu³ maj¹cych to samo po lewej stronie
                for jj=0:j-1
                    
                    prevRulesProbSum=prevRulesProbSum+population(n,i+j-jj-1);
                end
                population(n,i+j)=rand*(1-prevRulesProbSum);
            end
            
            %Dla ostatniej regu³y z t¹ sam¹ czêœci¹ po lewej - dope³nienie do 1
            prevRulesProbSum=0;
            for jj=0:j-1
                prevRulesProbSum=prevRulesProbSum+population(n,i+j-jj-1);
            end
            population(n,i+j)=1-prevRulesProbSum;
        end
        
        i=i+same;
    end
    
    if length(grammar.rules)>length(population(n))
        population(n,length(grammar.rules))=1;
    end
    
end
end