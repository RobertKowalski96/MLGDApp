function [grammar, distanceParam, yParam, populationHistory, lethalMutations, time, bestSolutionHistory, accuracyParam, modelZero] = SGA (hyperparameters, teachingSentencesFile, grammarFile, positiveTestFile, negativeTestFile, modelZero, stopTime)
%G��wna funkcja aplikacji odpowiadaj�ca za proces uczenia
%
%argumenty wyj�ciowe:
% grammar - gramatyka (nieterminale, regu�y strukturalne i leksykalne oraz
% ich powi�zania, czyli indeksy regu� o tym samym poprzedniku)
%
% distanceParam - zawiera parametry (max, min, mean, med, std) odleg�o�ci (euklidesowej)
% poszczeg�lnych osobnik�w wzgl�dem siebie (miara r�norodno�ci populacji)
%
% yParam - zawiera parametry (max, min, mean, med, std) ze �redniego
% dopasowania wszystkich sekwencji z pr�bki ucz�cej dla danej populacji
%
% populationHistory - zrzuty populacji robione co 100 przebieg�w programu
% (dodatkowo pierwsza populacjia)
%
% lethalMutations - liczba mutacji krytycznie niekorzystnych, czyli powoduj�cych, �e kt�ry� osobnik nie jest wyprowadzi� jednego ze z pr�bki ucz�cej (p(x)=0)
%
% time - czas trwania poszczeg�lnych cykli nauki
%
% bestSolutionHistory - najlepszy osobnik z ka�dej populacji
%
% accuracyParam - parametry pokazuj�ce jak dobrym klasyfikatorem jest dana
% gramatyka (pole pod krzyw� ROC)
%
% modelZero - parametry analogiczne do zawartych w accuracyParam, z
% wykorzystaniem modelu zerowego
%
%argumenty wej�ciowe:
%
% hyperparameters - parametry wej�ciowe (liczba osobnik�w, liczba cykli,
% prawdopodobie�stwa mutacji i zaj�cia procesu crossing over, maksymalna skala mutacji)
%
%teachingSentencesFile - plik zawieraj�cy zdania tworz�ce zbi�r ucz�cy
%
%grammarFile - plik zawieraj�cy regu�y gramatyki
%
%positiveTestFile - plik z pr�bkami pozytywnymi (do walidacji)
%
%negativeTestFile - plik z pr�bkami negatywnymi (do walidacji)
%
%modelZero - struktura przechowuj�ca cz�stotliwo�� wyst�powania
%poszczeg�lnych nieterminali wzgl�dem siebie
%
%stopTime - wektor przechowuj�cy warto�ci czasu(w godzinach) po kt�rym program
%dokonuje zapis�w dotychczasowych wynik�w
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
%osobnik�w
bestIndex = find(points==max(points), 1); %Indeks najlepszego osobnika
bestSolutionHistory(:,1) = population(bestIndex,:);
time(1)=toc;
t=1; %cycles
while t<=hyperparameters.tk
    tic
    %pierwsza cz�� nowej populacji (T1) jest tworzona na podstawie
    %operacji genetycznych (krzy�owanie, mutacje)
    [populationT1] = reproduction(population, points, hyperparameters.CrossingOverProb);
    populationT1PreMutations = populationT1;
    [populationT1] = mutations(populationT1,hyperparameters.mutationProb,hyperparameters.mutationScale);
    [populationT1] = scaleRulesProb (grammar,populationT1);
    [pointsT1,populationT1, lethalMutations] = qualityCheck(populationT1,populationT1PreMutations, grammar, teachingSentences, lethalMutations);
    
    %druga cz�� nowej populacji (T2) jest tworzona poprzez skopiowanie
    %lepiej przystosowanej po�owy z poprzedniej populacji
    [pointsT2, populationT2] = keepBetterOld (population, points, hyperparameters.n);
    
    %��czenie cz�ci T1 i T2
    population=[populationT1; populationT2];
    points=[pointsT1, pointsT2];
    
    %wyznaczanie parametr�w
    [distanceParam, yParam] = calculateAllParam (population,t+1, distanceParam, yParam, points);
    
    %zapisanie co 100 populacji
    if mod(t,100) == 0
        [~, populationToSave] = keepBetterOld (population, points, hyperparameters.n*2); %dzi�ki zastosowaniu funkcji keepBetterOld z parametrem n*2 otrzymujemy ca�� populacj� posortowan� wzgl�dem punkt�w
        populationHistory(:,:,(t/100)+1)=populationToSave;
    end
    
    bestIndex = find(points==max(points), 1); %Indeks najlepszego osobnika
    bestSolutionHistory(:,t+1) = population(bestIndex,:);
    
    time(t+1) = toc;
    
    %zapis po up�ywie czasu z wektora stopTime (argument wej�ciowy)
    if find((sum(time)+(time(t+1)*20))>stopTime*3600)
        stopTime((sum(time)+(time(t+1)*20))>stopTime*3600)=inf;
        elapsedTime=sum(time)/3600;
        saveResultAfterStopTime(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, modelZero, elapsedTime, t);
    end
    
    t=t+1;
    
    
end
%zapis wynik�w po procesie nauki, przed walidacj�
saveResultAfterStopTime(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, modelZero, elapsedTime, t-1);

[accuracyParam, modelZero] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, hyperparameters.tk, grammar, modelZero);

%zapis wynik�w po walidacji
saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, accuracyParam, modelZero);

end

%subfunkcja odpowiadaj�ca za prealokacj� wektor�w wykorzystywanych w tej funkcji
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
%subfunkcja odpowiadaj�ca za zapis ko�cowy
function [] = saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, teachingSentencesFile, grammarFile, teachingSentences, bestSolutionHistory, accuracyParam, modelZero)

if exist('results', 'file') ~= 7 %sprawdzanie czy istniej� odpowiednie foldery, je�eli nie to tworzenie ich
    mkdir('results');
end

if exist(strcat('results/', grammarFile), 'file') ~= 7
    mkdir(strcat('results/',grammarFile));
end

tn=1; %liczba porz�dkowa oznaczaj�ca numer testu o zadanych parametrach
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
%subfunkcja odpowiadaj�ca za zapis po up�ywie sprawdzanego czasu
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

if exist('results', 'file') ~= 7 %sprawdzanie czy istniej� odpowiednie foldery, je�eli nie to tworzenie ich
    mkdir('results');
end

if exist(strcat('results/', grammarFile), 'file') ~= 7
    mkdir(strcat('results/',grammarFile));
end

tn=1; %liczba porz�dkowa oznaczaj�ca numer testu o zadanych parametrach
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

