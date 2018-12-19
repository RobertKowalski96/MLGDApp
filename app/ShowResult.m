%clc, clear all
%close all
%load('resultData3.mat');
x=linspace(1,hyperparameters.tk+1,hyperparameters.tk+1);
% figure
% plot(x,yMin); title('min');
% figure
% plot(x, yMean); title('mean');
figure
plot(x, yParam.max); title('max');


% figure
% plot(x,yParam.min); title('result'); hold on
% plot(x, yParam.mean);
% plot(x, yParam.max);
% legend('min','mean','max');

%figure
%plot(x, distanceParam.mean); title('mean');

%figure
%plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),accuracyParam.aucHistory)

figure
plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),modelZero.aucHistory)

%figure
%plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),modelZero.aucHistory2)

sum(time(1:2));
% figure
% plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),accuracyParam.aucHistory)
% hold on
% plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),modelZero.aucHistory)
% plot(linspace(1,length(accuracyParam.aucHistory),length(accuracyParam.aucHistory)),modelZero.aucHistory2)
% legend('normal','zero1', 'zero2')

% 
% figure
% plot(x, distanceParam.med); title('med');
% 
 %figure
 %plot(x, distanceParam.std); title('std');
