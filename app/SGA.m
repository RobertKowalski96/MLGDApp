clc; clear all;
tic
%parameters:
t=1; %cycles
n=40; %osobniki
tk=10000; %end cycle number
mutationProb=0.1;
mutationScale=0.1;
reproductionProb=0.5;

%initialization
[sentences] = loadSentences('sentences.txt');
[grammar] = loadGrammar('TEST_Grammar2Plus2.txt');
%[population] = initRulesProb(grammar,n);
[population] = initPopulation (grammar, n);

%ocena P0
[points,points2] = qualityCheck (population, grammar, sentences);

yMin=zeros(tk-1,1);
yMean=zeros(tk-1,1);
while t<tk
    
    [population] = reproduction(population,points, reproductionProb);
    [population] = mutations(population,mutationProb,mutationScale);
    
    for i=1:n
        population(i,:)=scaleRulesProb(grammar,population(i,:));
    end
    
    [points,points2] = qualityCheck(population,grammar, sentences);
    yMin(t)=min(points2);
    yMean(t)=mean(points2);
    t=t+1;
end
toc
x=linspace(1,tk-1,tk-1);
figure
plot(x,yMin); title('min');d
figure
plot(x, yMean); title('mean');