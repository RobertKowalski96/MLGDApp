%argumenty wyjœciowe:
% grammar - gramatyka (nieterminale, regu³y strukturalne i leksykalne wraz
% z wzajemnymi powi¹zaniami)
%
% distanceParam - zawiera parametry (max, min, mean, med, std) odleg³oœci (euklidesowej)
%  poszczególnych osobników wzglêdem siebie (pokazuje to ró¿norodnoœæ populacji)
%
% yParam - zawiera parametry (max, min, mean, med, std) ze œredniego
% dopasowania wszystkich sekwencji z próbki ucz¹cej dla ka¿dego osobnika z
% populacji
%
% hyperparameters - parametry wejœciowe (liczba osobników, liczba cykli,
% prawdopodobieñstwa mutacji i crossing over, maksymalna skala mutacji)
%
% populationHistory - zrzuty populacji robione co 100 przebiegów programu
% (dodatkowo pierwsza populacjia)
%
% lethalMutations - liczba mutacji powoduj¹cych, ¿e osobnik nie jest w stanie zakwalifikowaæ jednego ze sprawdzanych zdañ do testowanej gramatyki(p(x)=0)
%
% time - czas uczenia
function [grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, bestSolutionHistory, accuracyParam, modelZero] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile, modelZero)
tic

%initialization
load('teachingSentences.mat');
[grammar] = loadGrammar(grammarFile);
[population] = initPopulation (grammar, hyperparameters.n);
[yParam, distanceParam, populationHistory, bestSolutionHistory, time] = preallocate (grammar,hyperparameters); %subfunction preallocate
lethalMutations=0;


%ocena P0
[points] = firstQualityCheck (population, grammar, teachingSentences);
[distanceParam, yParam] = calculateAllParam (population,1, distanceParam, yParam, points);

%zapisanie pierwszej populacji do archiwum populacji
populationHistory(:,:,1)=population;
%zapisanie najlepszego osobnika pierwszej populacji do archiwum najlepszych
%osobników
bestIndex = find(points==max(points), 1); %Indeks najlepszego osobnika
bestSolutionHistory(:,1) = population(bestIndex,:);
time(1)=toc;
t=1; %cycles
while t<=hyperparameters.tk
    tic
    %pierwsza czêœæ nowej populacji (T1) jest tworzona na podstawie
    %operacji genetycznych (krzy¿owanie, mutacje)
    [populationT1] = reproduction(population, points, hyperparameters.CrossingOverProb);
    populationT1PreMutations = populationT1;
    [populationT1] = mutations(populationT1,hyperparameters.mutationProb,hyperparameters.mutationScale);
    [populationT1] = scaleRulesProb (grammar,populationT1);
    [pointsT1,populationT1, lethalMutations] = qualityCheck(populationT1,populationT1PreMutations, grammar, teachingSentences, lethalMutations);
    
    %druga czêœæ nowej populacji (T2) jest tworzona poprzez skopiowanie
    %lepiej przystosowanej po³owy z poprzedniej populacji
    [pointsT2, populationT2] = keepBetterOld (population, points, hyperparameters.n);
    
    %³¹czenie czêœci T1 i T2
    population=[populationT1; populationT2];
    points=[pointsT1, pointsT2];
    
    %wyznaczanie parametrów
    [distanceParam, yParam] = calculateAllParam (population,t+1, distanceParam, yParam, points);
    
    %zapisanie co 100 populacji
    if mod(t,100) == 0
        [~, populationToSave] = keepBetterOld (population, points, hyperparameters.n*2); %dziêki zastosowaniu funkcji keepBetterOld z parametrem n*2 otrzymujemy ca³¹ populacjê posortowan¹ wzglêdem punktów
        populationHistory(:,:,(t/100)+1)=populationToSave;
    end
  
    bestIndex = find(points==max(points), 1); %Indeks najlepszego osobnika
    bestSolutionHistory(:,t+1) = population(bestIndex,:);
    
    time(t+1) = toc;
    t=t+1
    
end


[accuracyParam, modelZero] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, hyperparameters.tk, grammar, modelZero);

%subfunction saveResult
saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, accuracyParam, modelZero);

end


function [yParam, distanceParam, populationHistory, bestSolutionHistory, time] = preallocate (grammar,hyperparameters)
tk=hyperparameters.tk;
n=hyperparameters.n;

time=zeros(tk+1,1);
yParam.min=zeros(tk+1,1);
yParam.max=zeros(tk+1,1);
yParam.mean=zeros(tk+1,1);
yParam.std=zeros(tk+1,1);
yParam.med=zeros(tk+1,1);
distanceParam.mean = zeros(tk+1,1);
distanceParam.med = zeros(tk+1,1);
distanceParam.std = zeros(tk+1,1);
distanceParam.max = zeros(tk+1,1);
distanceParam.min = zeros(tk+1,1);
populationHistory=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex),(tk/100)+1);
bestSolutionHistory = zeros(length(grammar.rules.Lex)+length(grammar.rules.NonLex),tk+1);

end

function [] = saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, accuracyParam, modelZero)

if exist('results', 'file') ~= 7 %sprawdzanie czy istniej¹ odpowiednie foldery, je¿eli nie to tworzenie ich
    mkdir('results');
end

if exist(strcat('results/', grammarFile), 'file') ~= 7
    mkdir(strcat('results/',grammarFile));
end

tn=1; %liczba porz¹dkowa oznaczaj¹ca numer testu o zadanych parametrach
saved=0;
while ~saved
    filename=strcat('results/',grammarFile,'/n',mat2str(hyperparameters.n),'mp',mat2str(hyperparameters.mutationProb),'ms',mat2str(hyperparameters.mutationScale),'COp',mat2str(hyperparameters.CrossingOverProb),'tk',mat2str(hyperparameters.tk),'testNr',mat2str(tn),'.mat');
    if exist(filename, 'file') == 2
        tn=tn+1;
    else
        save(filename,...
            'grammar', 'distanceParam', 'yParam', 'hyperparameters', 'populationHistory', 'lethalMutations', 'time', 'teachingSentencesFile', 'grammarFile', 'teachingSentences', 'bestSolutionHistory', 'accuracyParam', 'modelZero');
        saved=1;
        filename
    end
end


end
