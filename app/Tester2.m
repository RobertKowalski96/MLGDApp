clc, clear all;

[grammar]=loadGrammar('TEST_Grammar2Max.txt');

[grammar] = initRulesProb(grammar);

input = 'a a b b c';

prob = CYK_Probabilistic(grammar, input)
