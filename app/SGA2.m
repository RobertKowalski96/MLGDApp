clc; clear all, close all;
tic
%parameters:
t=1; %cycles
n=100; %osobniki
tk=2000; %end cycle number
mutationProb=0.0001;
mutationScale=0.5;
reproductionProb=0.4;

badMutations=0;

%initialization
[sentences] = loadSentences('sentences.txt');
[grammar] = loadGrammar('TEST_Grammar2Covering2.txt');
[population] = initPopulation (grammar, n);



%ocena P0
[points,points2] = firstQualityCheck (population, grammar, sentences);

yMin=zeros(tk,1);
yMax=zeros(tk,1);
yMean=zeros(tk,1);

distanceParam.sum = zeros(tk,1);
distanceParam.mean = zeros(tk,1);
distanceParam.med = zeros(tk,1);
distanceParam.std = zeros(tk,1);
distanceParam.max = zeros(tk,1);
distanceParam.min = zeros(tk,1);

while t<=tk
    
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
    
    [distanceParam] = calculateDistanceParam (population,t, distanceParam);
    
    t=t+1
end
time = toc;
save('resultData5');
