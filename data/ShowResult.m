clc, clear all

load('resultData2.mat');
x=linspace(1,tk-1,tk-1);
figure
plot(x,yMin); title('min');
figure
plot(x, yMean); title('mean');
figure
plot(x, yMax); title('max');

figure
plot(x,yMin); title('result'); hold on
plot(x, yMean);
plot(x, yMax);
legend('min','mean','max');