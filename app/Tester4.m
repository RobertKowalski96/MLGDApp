clc, clear all

[grammar]=generateGrammarMax('terminals.txt','nonTerminals.txt');

[grammar] = initRulesProb(grammar);

input = 'a b b c';

prob = CYK_Probabilistic(grammar, input);
