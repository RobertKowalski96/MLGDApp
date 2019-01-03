function [modelZero] = zeroModel (modelZero, accuracyParam)

terminals=modelZero.terminals;
terminalsFreq = modelZero.terminalsFreq; %cz�stotliwo�� wyst�powania kolejnych terminali z tablicy terminals

sentences = accuracyParam.testSentences;

modelProb = ones(1,length(sentences));
for i=1:length(sentences)
    
    singleSentence = sentences{i};
    n=length(singleSentence);
    
    ps = fzero(@(x) n*x.^(n-1) - (n+1)*x.^n ,[0.1,1]); %prawdopodobie�stwo znaku (sign)
    pe = 1 - ps; %prawdopodobie�stwo wyj�cia (end)
    
    terminalsFreq = (terminalsFreq/sum(terminalsFreq))*ps;
    
    prob=pe;
    for j=1: length(terminals)
        numberOfCharOccurences = length(strfind(singleSentence,terminals(j)));
        prob=prob*terminalsFreq(j).^numberOfCharOccurences;
    end
    
    modelProb(i) = prob;
    
end

modelZero.sentencesProb = modelProb;

 modelAUC = zeros(1,length(accuracyParam.aucHistory));
for i=1:length(accuracyParam.aucHistory);

   [~,~,~,modelAUC(i)] = perfcurve(accuracyParam.condiction,accuracyParam.testSentencesPoints(i,:)./modelProb,1);

end

modelZero.aucHistory=modelAUC;

end