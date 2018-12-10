clc; clear all, close all;
tic
%parameters:
t=1; %cycles
n=40; %osobniki
tk=500; %end cycle number
mutationProb=0.005;
mutationScale=0.5;
reproductionProb=0.4;

badMutations=0;

%initialization
[sentences] = loadSentences('sentences.txt');
[grammar] = loadGrammar('TEST_Grammar2MinDob.txt');
%[population] = initRulesProb(grammar,n);
[population] = initPopulation (grammar, n);

%ocena P0
[points,points2] = firstQualityCheck (population, grammar, sentences);

yMin=zeros(tk-1,1);
yMax=zeros(tk-1,1);
yMean=zeros(tk-1,1);
while t<tk
    
    [population] = reproduction(population,points, reproductionProb);
    populationPreMutations = population;
    [population] = mutations(population,mutationProb,mutationScale);
    
    for i=1:n
        population(i,:)=scaleRulesProb(grammar,population(i,:));
    end
    
    [points,points2,population, badMutations] = qualityCheck(population,populationPreMutations, grammar, sentences, badMutations);
    yMin(t)=min(points2);
    yMax(t)=max(points2);
    yMean(t)=mean(points2);
    t=t+1;
end
time = toc;
save('resultData2');
