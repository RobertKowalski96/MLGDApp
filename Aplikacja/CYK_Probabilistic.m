function [prob] = CYK_Probabilistic(grammar, input, rulesProb)
%Fucnkja odpowidaj�ca za analiz� sk�adniow� zdania
%
%Dane wej�ciowe:
%gramamr - struktura zawieraj�ca sprawdzan� gramatyk� (regu�y, symbole
%terminalne)
%
%input - sprawdzane zdanie
%
%rulesProb - zestaw prawdopodobie�stw przypisany do regu� sprawdzanej gramatyki

%Inicjalizacja
P=zeros(length(input),length(input),length(grammar.nonTerminals));
%Pierwszy obieg (dla regu� leksykalnych)
for i=1:length(input)
    for r=1:length(grammar.rules.lex)
        if strcmp(input(i),grammar.rules.lex{r,2})
            P(1,i,grammar.rules.lex{r,1})=rulesProb(r+length(grammar.rules.nonLex));
        end
    end
end

n=length(input);
%Testowanie regu� strukturalnych
for i=2:n
    for j=1:n-i+1
        for k=1:i-1
            for r=1:length(grammar.rules.nonLex)
                 %left hand side (poprzednik w sprawdzanej regule)
                lhs = grammar.rules.nonLex{r,1};
                 %right hand side (pierwsza cz�� nast�pnika w sprawdzanej regule)
                rhs1 = grammar.rules.nonLex{r,2};
                 %right hand side2 (druga cz�� nast�pnika w sprawdzanej regule)
                rhs2 = grammar.rules.nonLex{r,3};
                if P(k,j,rhs1) && P(i-k,j+k,rhs2)
                    prob_splitting = rulesProb(r)*P(k,j,rhs1)*P(i-k,j+k,rhs2);
                        P(i,j,lhs) = P(i,j,lhs) + prob_splitting;
                end
            end
        end
    end
end
    prob = P(n,1,1);
end