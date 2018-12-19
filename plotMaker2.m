x=linspace(1,hyperparameters.tk+1,hyperparameters.tk+1);

%y1=distanceParam.max;

figure
plot(x, y1); hold on
plot(x, y2);
plot(x, y3);
plot(x, y4); legend('n=40', 'n=80', 'n=160', 'n=320'); xlabel('t[learning cycles]'); ylabel('mean(distance) [-]')


