function [prob] = CYK_Probabilistic(grammar, input, rulesProb)

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
            for r=1:length(grammar.rules.NonLex)
                if P(k,j,grammar.rules.NonLex{r,2}) && P(i-k,j+k,grammar.rules.NonLex{r,3})
                    prob_splitting = rulesProb(r)*P(k,j,grammar.rules.NonLex{r,2})*P(i-k,j+k,grammar.rules.NonLex{r,3});
                        P(i,j,grammar.rules.NonLex{r,1}) = P(i,j,grammar.rules.NonLex{r,1}) + prob_splitting;
                end
            end
        end
    end
end
    
    prob = P(n,1,1);
end