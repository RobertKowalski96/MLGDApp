function [prob, P] = CYK_Probabilistic(grammar, input, rulesProb)


input = strsplit(input, ' ');

%Initialize
P=zeros(length(input),length(input),length(grammar.nonTerminals));
%First
for i=1:length(input)
    for r=1:length(grammar.rules.Lex)
        if strcmp(input(i),grammar.rules.Lex{r,2})
            %for jj=1:length(grammar.nonTerminals)
            %if strcmp(grammar.rules(r,1),grammar.nonTerminals(jj))
           % idx = ismember(grammar.nonTerminals, grammar.rules{r,1});
            P(1,i,grammar.rules.Lex{r,1})=rulesProb(r+length(grammar.rules.NonLex));
            % end
            % end
        end
    end
end

n=length(input);
for i=2:n
    for j=1:n-i+1
        for k=1:i-1
            %for t1=1:length(grammar.nonTerminals)
            %for t2=1:length(grammar.nonTerminals)
            
            for r=1:length(grammar.rules.NonLex)
                %t=strsplit(grammar.rules{r,2}, ' ');
                 %if length(t)==2
%                     t1 = ismember(grammar.nonTerminals, t{1});
%                     t2 = ismember(grammar.nonTerminals, t{2});
                    
                    if P(k,j,grammar.rules.NonLex{r,2}) && P(i-k,j+k,grammar.rules.NonLex{r,3})
                        %projection =strjoin([grammar.nonTerminals(t1),grammar.nonTerminals(t2)]);
                        %a for r=1:length(grammar.rules)
                        % if strcmp(projection,grammar.rules(r,2))
                        %for jj=1:length(grammar.nonTerminals)
                        %   if strcmp(grammar.rules(r,1),grammar.nonTerminals(jj))
                        %idx = ismember(grammar.nonTerminals, grammar.rules(r,1));
                        prob_splitting = rulesProb(r)*P(k,j,grammar.rules.NonLex{r,2})*P(i-k,j+k,grammar.rules.NonLex{r,3});
                        if P(k,j,grammar.rules.NonLex{r,2})>0 && P(i-k,j+k,grammar.rules.NonLex{r,3})>0
                            P(i,j,grammar.rules.NonLex{r,1}) = P(i,j,grammar.rules.NonLex{r,1}) + prob_splitting;
                        end
                        %end
                        %end
                        %  end
                        %   end
                    end
               % end
                %end
                %end
            end
        end
    end
    
    
    prob = P(n,1,1);
end