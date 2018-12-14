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
    
    %pierwsza czêœæ nowej populacji (T1) jest tworzona na podstawie
    %operacji genetycznych (krzy¿owanie, mutacje)
    [populationT1] = reproduction(population, points, hyperparameters.CrossingOverProb);
    populationT1PreMutations = populationT1;
    [populationT1] = mutations(populationT1,hyperparameters.mutationProb,hyperparameters.mutationScale);
    [populationT1] = scaleRulesProb (grammar,populationT1);
    [pointsT1,populationT1, lethalMutations] = qualityCheck(populationT1,populationT1PreMutations, grammar, sentences, lethalMutations);
   
    %druga czêœæ nowej populacji (T2) jest tworzona poprzez skopiowanie
    %lepiej przystosowanej po³owy z poprzedniej populacji
    [pointsT2, populationT2] = keepBetterOld (population, points, hyperparameters.n);
    
    %³¹czenie czêœci T1 i T2
    population=[populationT1; populationT2];
    points=[pointsT1, pointsT2];
    
    %wyznaczanie parametrów
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

tn=1; %liczba porz¹dkowa oznaczaj¹ca numer testu o zadanych parametrach
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
