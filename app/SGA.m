clc; clear all;

%parameters:
t=0; %cycles
n=10; %osobniki
tk=100; %end cycle number
mutationProb=1;
mutationScale=1;
reproductionProb=1;

%initialization
[sentences] = loadSentences('sentences.txt');
[grammar] = loadGrammar('TEST_Grammar2Min.txt');
[population] = initRulesProb(grammar,n);

%ocena P0
[points] = qualityCheck (population, grammar, sentences);


while t<tk
    
    [population] = reproduction(population,points, reproductionProb);
    %[population] = mutations(population,mutationProb,mutationScale);
    [points] = qualityCheck(population,grammar, sentences)
    
    t=t+1;
end