tk=3000;




auc = zeros(1, (tk/10)+1);
for i = 1:(tk/10)+1
    i
    [tpr,fpr,~] = roc(accuracyParam.condiction,accuracyParam.testSentencesPoints(i,:));
    auc(i)=trapz(fpr,tpr)
    if max(fpr) ==0
        auc(i)=1;
    else
        auc(i)=auc(i)+(1-max(fpr));
    end
end

 accuracyParam.aucHistory = auc;
 figure;
 plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),accuracyParam.aucHistory)
