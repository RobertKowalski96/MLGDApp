%argumenty wyj�ciowe:
% grammar - gramatyka (nieterminale, regu�y strukturalne i leksykalne wraz
% z wzajemnymi powi�zaniami)
%
% distanceParam - zawiera parametry (max, min, mean, med, std) odleg�o�ci (euklidesowej)
%  poszczeg�lnych osobnik�w wzgl�dem siebie (pokazuje to r�norodno�� populacji)
%
% yParam - zawiera parametry (max, min, mean, med, std) ze �redniego
% dopasowania wszystkich sekwencji z pr�bki ucz�cej dla ka�dego osobnika z
% populacji
%
% hyperparameters - parametry wej�ciowe (liczba osobnik�w, liczba cykli,
% prawdopodobie�stwa mutacji i crossing over, maksymalna skala mutacji)
%
% populationHistory - zrzuty populacji robione co 100 przebieg�w programu
% (dodatkowo pierwsza populacjia)
%
% lethalMutations - liczba mutacji powoduj�cych, �e osobnik nie jest w stanie zakwalifikowa� jednego ze sprawdzanych zda� do testowanej gramatyki(p(x)=0)
%
% time - czas uczenia
function [grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time] = SGA (hyperparameters, sentencesFile, grammarFile)
tic

%initialization
[sentences] = loadSentences(sentencesFile);
[grammar] = loadGrammar(grammarFile);
[population] = initPopulation (grammar, hyperparameters.n);
[yParam, distanceParam, populationHistory] = preallocate (grammar,hyperparameters); %subfunction preallocate
lethalMutations=0;
%zapisanie pierwszej populacji do archiwum populacji
populationHistory(:,:,1)=population; 

%ocena P0
[points] = firstQualityCheck (population, grammar, sentences);

t=1; %cycles
while t<=hyperparameters.tk
    
    %pierwsza cz�� nowej populacji (T1) jest tworzona na podstawie
    %operacji genetycznych (krzy�owanie, mutacje)
    [populationT1] = reproduction(population, points, hyperparameters.CrossingOverProb);
    populationT1PreMutations = populationT1;
    [populationT1] = mutations(populationT1,hyperparameters.mutationProb,hyperparameters.mutationScale);
    [populationT1] = scaleRulesProb (grammar,populationT1);
    [pointsT1,populationT1, lethalMutations] = qualityCheck(populationT1,populationT1PreMutations, grammar, sentences, lethalMutations);
   
    %druga cz�� nowej populacji (T2) jest tworzona poprzez skopiowanie
    %lepiej przystosowanej po�owy z poprzedniej populacji
    [pointsT2, populationT2] = keepBetterOld (population, points, hyperparameters.n);
    
    %��czenie cz�ci T1 i T2
    population=[populationT1; populationT2];
    points=[pointsT1, pointsT2];
    
    %wyznaczanie parametr�w
    [distanceParam, yParam] = calculateAllParam (population,t, distanceParam, yParam, points);
    
    %zapisanie co 100 populacji
    if mod(t,100) == 0
        populationHistory(:,:,(t/100)+1)=population;
    end
    
    t=t+1;
end
time = toc;

%subfunction saveResult
saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, sentencesFile, grammarFile, sentences); 

end


function [yParam, distanceParam, populationHistory] = preallocate (grammar,hyperparameters)
tk=hyperparameters.tk;
n=hyperparameters.n;

yParam.min=zeros(tk,1);
yParam.max=zeros(tk,1);
yParam.mean=zeros(tk,1);
yParam.std=zeros(tk,1);
yParam.med=zeros(tk,1);
distanceParam.mean = zeros(tk,1);
distanceParam.med = zeros(tk,1);
distanceParam.std = zeros(tk,1);
distanceParam.max = zeros(tk,1);
distanceParam.min = zeros(tk,1);
populationHistory=zeros(n,length(grammar.rules.Lex)+length(grammar.rules.NonLex),(tk/100)+1);

end

function [] = saveResult(grammar, distanceParam, yParam, hyperparameters, populationHistory, lethalMutations, time, sentencesFile, grammarFile, sentences)

tn=1; %liczba porz�dkowa oznaczaj�ca numer testu o zadanych parametrach
saved=0;
while ~saved
filename=strcat('n',mat2str(hyperparameters.n),'mp',mat2str(hyperparameters.mutationProb),'ms',mat2str(hyperparameters.mutationScale),'COp',mat2str(hyperparameters.CrossingOverProb),'tk',mat2str(hyperparameters.tk),'testNr',mat2str(tn),'.mat');
if exist(filename, 'file') == 2
    tn=tn+1;
else
     save(filename,...
    'grammar', 'distanceParam', 'yParam', 'hyperparameters', 'populationHistory', 'lethalMutations', 'time', 'sentencesFile', 'grammarFile', 'sentences');
     saved=1;
end
end


end
