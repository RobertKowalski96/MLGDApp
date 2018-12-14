%clc, clear all
%close all
%load('resultData3.mat');
x=linspace(1,hyperparameters.tk,hyperparameters.tk);
% figure
% plot(x,yMin); title('min');
% figure
% plot(x, yMean); title('mean');
figure
plot(x, yParam.max); title('max');

figure
plot(x,yParam.min); title('result'); hold on
plot(x, yParam.mean);
plot(x, yParam.max);
legend('min','mean','max');

figure
plot(x, distanceParam.mean); title('mean');

% 
% figure
% plot(x, distanceParam.med); title('med');
% 
% figure
% plot(x, distanceParam.std); title('std');
