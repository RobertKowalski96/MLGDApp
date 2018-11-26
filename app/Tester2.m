clc, clear all;

[grammar]=loadGrammar('TEST_Grammar2Min.txt');

%[grammar] = initRulesProb(grammar);

for i=1:length(grammar.rules.Lex)+length(grammar.rules.NonLex)
   rulesProb(i)=rand; 
end
tic
[rulesProb] = scaleRulesProb (grammar,rulesProb);
toc

input = 'a a a b b b c c c';
tic
[prob, P] = CYK_Probabilistic(grammar, input, rulesProb);
toc

test=rulesProb(6)*rulesProb(6)*rulesProb(7)*rulesProb(7)*rulesProb(9)*rulesProb(3)*rulesProb(4)*rulesProb(2)*rulesProb(1)