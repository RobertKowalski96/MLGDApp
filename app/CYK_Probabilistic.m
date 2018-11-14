function [prob] = CYK_Probabilistic(grammar, input)


input = strsplit(input, ' ');

%Initialize
P=zeros(length(input),length(input),length(grammar.symbols));
%First
for i=1:length(input)  
    for j=1:length(grammar.rules)
        if strcmp(input(i),grammar.rules(j,2))
            for jj=1:length(grammar.symbols)
                if strcmp(grammar.rules(j,1),grammar.symbols(jj))
                    P(1,i,jj)=grammar.rulesProb(j);
                end
            end
        end
    end
end

n=length(input);
for i=2:n   
    for j=1:n-i+1
        for k=1:i-1
            for t1=1:length(grammar.symbols)
                for t2=1:length(grammar.symbols)
                    if P(k,j,t1) && P(i-k,j+k,t2)
                        projection =strjoin([grammar.symbols(t1),grammar.symbols(t2)]);
                        for r=1:length(grammar.rules)
                            if strcmp(projection,grammar.rules(r,2))
                                for jj=1:length(grammar.symbols)
                                    if strcmp(grammar.rules(r,1),grammar.symbols(jj))
                                        prob_splitting = grammar.rulesProb(r)*P(k,j,t1)*P(i-k,j+k,t2);
                                        if P(k,j,t1)>0 && P(i-k,j+k,t2)>0
                                            P(i,j,jj) = P(i,j,jj) + prob_splitting;
                                        end
                                    end
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