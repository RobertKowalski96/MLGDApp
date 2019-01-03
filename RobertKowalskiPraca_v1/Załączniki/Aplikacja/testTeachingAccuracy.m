function [accuracyParam, modelZero] = testTeachingAccuracy (positiveTestFile, negativeTestFile, bestSolutionHistory, tk, grammar, modelZero)

load('proteinTestSentences.mat');

%accuracyParam.condiction = [ones(1,length(positiveSentences)),zeros(1,length(negativeSentences))];

accuracyParam.testSentencesPoints = ones((tk/10)+1, length(accuracyParam.testSentences));
testSentences=accuracyParam.testSentences;

solution =  bestSolutionHistory(:,1);
currentPoints=zeros(1,length(accuracyParam.testSentences));
parfor j = 1 : length(accuracyParam.testSentences)%Pierwszy osobnik (póŸniej jest co dziesi¹ty)
    currentPoints(j) = CYK_Probabilistic(grammar, testSentences{j}, solution);
end
accuracyParam.testSentencesPoints(1, :) = currentPoints;

currentPoints=zeros(1,length(accuracyParam.testSentences));
for i = 1 : tk/10
    solution =  bestSolutionHistory(:,i*10);
    parfor j = 1 : length(accuracyParam.testSentences)
        currentPoints(j) = CYK_Probabilistic(grammar, testSentences{j}, solution);
    end
    accuracyParam.testSentencesPoints(i+1, :) = currentPoints;
    i
end


auc = zeros(1, (tk/10)+1);
for i = 1:(tk/10)+1
    [~,~,~,auc(i)] = perfcurve(accuracyParam.condiction,accuracyParam.testSentencesPoints(i,:),1);
end

accuracyParam.aucHistory = auc;
[modelZero] = zeroModel (modelZero, accuracyParam);
[modelZero] = zeroModel2 (modelZero, accuracyParam);


end