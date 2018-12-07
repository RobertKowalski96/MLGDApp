clc, clear all

load('Result4.mat');

figure
plot(x,yMin); title('result'); hold on
plot(x, yMean);
plot(x, yMax);
legend('min','mean','max');
