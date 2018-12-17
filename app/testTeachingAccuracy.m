function [accuracyParam, modelZero] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, tk, grammar, modelZero)

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
    [~,~,~,auc(i)] = perfcurve(accuracyParam.condiction,accuracyParam.testSentencesPoints(i,:),1);
end

accuracyParam.aucHistory = auc;
[modelZero] = zeroModel (modelZero, accuracyParam);
[modelZero] = zeroModel2 (modelZero, accuracyParam);


end