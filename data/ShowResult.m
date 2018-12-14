%clc, clear all
%close all
%load('resultData3.mat');
x=linspace(1,tk,tk);
% figure
% plot(x,yMin); title('min');
% figure
% plot(x, yMean); title('mean');
figure
plot(x, yMax); title('max');

figure
plot(x,yMin); title('result'); hold on
plot(x, yMean);
plot(x, yMax);
legend('min','mean','max');

figure
plot(x, distanceParam.sum); title('sum');

% figure
% plot(x, distanceParam.mean); title('mean');
% 
% figure
% plot(x, distanceParam.med); title('med');
% 
% figure
% plot(x, distanceParam.std); title('std');
