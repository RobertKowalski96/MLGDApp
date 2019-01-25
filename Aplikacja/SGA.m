function [grammar, distanceParam, yParam, populationHistory, lethalMutations, time, bestSolutionHistory, accuracyParam, modelZero] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile, modelZero, stopTime)
%G³ówna funkcja aplikacji odpowiadaj¹ca za proces uczenia
%
%argumenty wyjœciowe:
% grammar - gramatyka (nieterminale, regu³y strukturalne i leksykalne oraz
% ich powi¹zania, czyli indeksy regu³ o tym samym poprzedniku)
%
% distanceParam - zawiera parametry (max, min, mean, med, std) odleg³oœci (euklidesowej)
% poszczególnych osobników wzglêdem siebie (miara ró¿norodnoœci populacji)
%
% yParam - zawiera parametry (max, min, mean, med, std) ze œredniego
% dopasowania wszystkich sekwencji z próbki ucz¹cej dla danej populacji
%
% populationHistory - zrzuty populacji robione co 100 przebiegów programu
% (dodatkowo pierwsza populacjia)
%
% lethalMutations - liczba mutacji krytycznie niekorzystnych, czyli powoduj¹cych, ¿e któryœ osobnik nie jest wyprowadziæ jednego ze z próbki ucz¹cej (p(x)=0)
%
% time - czas trwania poszczególnych cykli nauki
%
% bestSolutionHistory - najlepszy osobnik z ka¿dej populacji
%
% accuracyParam - parametry pokazuj¹ce jak dobrym klasyfikatorem jest dana
% gramatyka (pole pod krzyw¹ ROC)
%
% modelZero - parametry analogiczne do zawartych w accuracyParam, z
% wykorzystaniem modelu zerowego
%
%argumenty wejœciowe:
%
% hyperparameters - parametry wejœciowe (liczba osobników, liczba cykli,
% prawdopodobieñstwa mutacji i zajœcia procesu crossing over, maksymalna skala mutacji)
%
%teachingSentencesFile - plik zawieraj¹cy zdania tworz¹ce zbiór ucz¹cy
%
%grammarFile - plik zawieraj¹cy regu³y gramatyki
%
%positiveTestFile - plik z próbkami pozytywnymi (do walidacji)
%
%negativeTestFile - plik z próbkami negatywnymi (do walidacji)
%
%modelZero - struktura przechowuj¹ca czêstotliwoœæ wystêpowania
%poszczególnych nieterminali wzglêdem siebie
%
%stopTime - wektor przechowuj¹cy wartoœci czasu(w godzinach) po którym program
%dokonuje zapisów dotychczasowych wyników
tic
rng('shuffle')

delete(gcp('nocreate'))
parpool(20, 'IdleTimeout', 120)
%inicjalizacja
[teachingSentences] = loadSentences(teachingSentencesFile);
[grammar] = loadGrammar(grammarFile);
[population] = initPopulation (grammar, hyperparameters.n);
[yParam, distanceParam, populationHistory, bestSolutionHistory, time] = preallocate (grammar,hyperparameters); %subfunkcja
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
    
    %zapis po up³ywie czasu z wektora stopTime (argument wejœciowy)
    if find((sum(time)+(time(t+1)*20))>stopTime*3600)
        stopTime((sum(time)+(time(t+1)*20))>stopTime*3600)=inf;
        elapsedTime=sum(time)/3600;
        saveResultAfterStopTime(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, modelZero, elapsedTime, t);
    end
    
    t=t+1;
    
    
end
%zapis wyników po procesie nauki, przed walidacj¹
saveResultAfterStopTime(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, modelZero, elapsedTime, t-1);

[accuracyParam, modelZero] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, hyperparameters.tk, grammar, modelZero);

%zapis wyników po walidacji
saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, accuracyParam, modelZero);

end

%subfunkcja odpowiadaj¹ca za prealokacjê wektorów wykorzystywanych w tej funkcji
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
%subfunkcja odpowiadaj¹ca za zapis koñcowy
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
    filename=strcat('results/',grammarFile,'/Teaching1n',mat2str(hyperparameters.n),'mp',mat2str(hyperparameters.mutationProb),'ms',mat2str(hyperparameters.mutationScale),'COp',mat2str(hyperparameters.CrossingOverProb),'tk',mat2str(hyperparameters.tk),'testNr',mat2str(tn),'.mat');
    if exist(filename, 'file') == 2
        tn=tn+1;
    else
        save(filename,...
            'grammar', 'distanceParam', 'yParam', 'hyperparameters', 'populationHistory', 'lethalMutations', 'time', 'teachingSentencesFile', 'grammarFile', 'teachingSentences', 'bestSolutionHistory', 'accuracyParam', 'modelZero');
        saved=1;
    end
end


end
%subfunkcja odpowiadaj¹ca za zapis po up³ywie sprawdzanego czasu
function [] = saveResultAfterStopTime(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, modelZero, elapsedTime, t)


time=time(1:t+1);
yParam.min=yParam.min(1:t+1);
yParam.max=yParam.max(1:t+1);
yParam.mean=yParam.mean(1:t+1);
yParam.std=yParam.std(1:t+1);
yParam.med=yParam.med(1:t+1);
distanceParam.mean = distanceParam.mean(1:t+1);
distanceParam.med = distanceParam.med(1:t+1);
distanceParam.std = distanceParam.std(1:t+1);
distanceParam.max = distanceParam.max(1:t+1);
distanceParam.min = distanceParam.min(1:t+1);
bestSolutionHistory = bestSolutionHistory(:,1:t+1);

if exist('results', 'file') ~= 7 %sprawdzanie czy istniej¹ odpowiednie foldery, je¿eli nie to tworzenie ich
    mkdir('results');
end

if exist(strcat('results/', grammarFile), 'file') ~= 7
    mkdir(strcat('results/',grammarFile));
end

tn=1; %liczba porz¹dkowa oznaczaj¹ca numer testu o zadanych parametrach
saved=0;
while ~saved
    filename=strcat('results/',grammarFile,'/Teaching1n',mat2str(hyperparameters.n),'mp',mat2str(hyperparameters.mutationProb),'ms',mat2str(hyperparameters.mutationScale),'COp',mat2str(hyperparameters.CrossingOverProb),'time',mat2str(elapsedTime),'testNr',mat2str(tn),'.mat');
    if exist(filename, 'file') == 2
        tn=tn+1;
    else
        save(filename,...
            'grammar', 'distanceParam', 'yParam', 'hyperparameters', 'populationHistory', 'lethalMutations', 'time', 'teachingSentencesFile', 'grammarFile', 'teachingSentences', 'bestSolutionHistory', 'modelZero', 'elapsedTime');
        saved=1;
    end
end


end

