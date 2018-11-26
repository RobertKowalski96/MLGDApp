function [prob, P] = Copy_of_CYK_Probabilistic(grammar, input, rulesProb)

%Different Approach, not optimal, "CYK_Probabilistic" is better

input = strsplit(input, ' ');

%Initialize
P=zeros(length(input),length(input),length(grammar.nonTerminals));
%First
for i=1:length(input)
    for r=1:length(grammar.rules.Lex)
        if strcmp(input(i),grammar.rules.Lex{r,2})
            P(1,i,grammar.rules.Lex{r,1})=rulesProb(r+length(grammar.rules.NonLex));
        end
    end
end

n=length(input);
for i=2:n
    for j=1:n-i+1
        for k=1:i-1
            for t1=1:length(grammar.nonTerminals)
                for t2=1:length(grammar.nonTerminals)
                    if P(k,j,t1) && P(i-k,j+k,t2)
                        for r=1:length(grammar.rules.NonLex)
                            if t1==grammar.rules.NonLex{r,2} && t2==grammar.rules.NonLex{r,3}
                                prob_splitting = rulesProb(r)*P(k,j,t1)*P(i-k,j+k,t2);
                                if P(k,j,t1)>0 && P(i-k,j+k,t2)>0
                                    P(i,j,grammar.rules.NonLex{r,1}) = P(i,j,grammar.rules.NonLex{r,1}) + prob_splitting;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


prob = P(n,1,1);
end