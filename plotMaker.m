y2=yParam.max;
x2=cumsum(time);



x=linspace(1,hyperparameters.tk+1,hyperparameters.tk+1);

figure
plot(x1, y1); hold on
plot(x2, y2);
plot(x3, y3);
plot(x4, y4); legend('n=40', 'n=80', 'n=160', 'n=320'); xlabel('t[s]'); ylabel('log(Pœr)')


