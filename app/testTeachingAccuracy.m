function [accuracyParam] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, tk, grammar)

load('testSentences.mat');

%accuracyParam.condiction = [ones(1,length(positiveSentences)),zeros(1,length(negativeSentences))];

accuracyParam.testSentencesPoints = ones((tk/10)+1, length(accuracyParam.testSentences));

for j = 1 : length(accuracyParam.testSentences)%Pierwszy osobnik (póŸniej jest co dziesi¹ty)
accuracyParam.testSentencesPoints(1, j) = CYK_Probabilistic(grammar, accuracyParam.testSentences{j}, bestSolutionHistory(:,1));
end

for i = 1 : tk/10   
   solution =  bestSolutionHistory(:,i*10);
    for j = 1 : length(accuracyParam.testSentences)  
        accuracyParam.testSentencesPoints(i+1, j) = CYK_Probabilistic(grammar, accuracyParam.testSentences{j}, solution);     
    end
end

auc = zeros(1, (tk/10)+1);
for i = 1:(tk/10)+1
    [tpr,fpr,~] = roc(accuracyParam.condiction,accuracyParam.testSentencesPoints(i,:));
    auc(i)=trapz(fpr,tpr);
    if max(fpr) ==0
        auc(i)=1;
    else
        auc(i)=auc(i)/max(fpr);
    end
end

 accuracyParam.aucHistory = auc;
end