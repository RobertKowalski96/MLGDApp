clc; clear all, close all;
tic
%parameters:
t=1; %cycles
n=240; %osobniki
tk=2000; %end cycle number
mutationProb=0.001;
mutationScale=0.4;
reproductionProb=0.4;

badMutations=0;

%initialization
[sentences] = loadSentences('sentences.txt');
[grammar] = loadGrammar('TEST_Grammar2Covering2.txt');
[population] = initPopulation (grammar, n);



%ocena P0
[points,points2] = firstQualityCheck (population, grammar, sentences);

populationHistory=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex),tk);

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
    
    [populationT1] = reproduction(population,points, reproductionProb);
    populationT1PreMutations = populationT1;
    [populationT1] = mutations(populationT1,mutationProb,mutationScale);
    
    
    for i=1:n/2
        populationT1(i,:)=scaleRulesProb(grammar,populationT1(i,:));
    end
    
    [pointsT1,pointsT1_2,populationT1, badMutations] = qualityCheck(populationT1,populationT1PreMutations, grammar, sentences, badMutations);
    
    [pointsT2, pointsT2_2, populationT2] = keepBetterOld (population, points, points2, n); %kopiujemy lepsz¹ po³owê z poprzedniej populacji
    
    population=[populationT1; populationT2];
    points2=[pointsT1_2, pointsT2_2];
    
    bestResult=max(points2);
    for i=1:length(points)
        points(i)=bestResult/points2(i);
    end
    



    
    yMin(t)=min(points2);
    yMax(t)=max(points2);
    yMean(t)=mean(points2);
    
    [distanceParam] = calculateDistanceParam (population,t, distanceParam);
    
    populationHistory(:,:,t)=population;
    
    t=t+1
end
time = toc;
save('resultData4');
