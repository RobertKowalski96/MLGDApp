n=320;
mp=0.001;
ms=0.5;
pCO=0.5;
tk=3000;

tn=1;
filename=strcat('/n',mat2str(n),'mp',mat2str(mp),'ms',mat2str(ms),'COp',mat2str(pCO),'tk',mat2str(tk),'testNr',mat2str(tn),'.mat');
test1=load(filename);

tn=2;
filename=strcat('/n',mat2str(n),'mp',mat2str(mp),'ms',mat2str(ms),'COp',mat2str(pCO),'tk',mat2str(tk),'testNr',mat2str(tn),'.mat');
test2=load(filename);

tn=3;
filename=strcat('/n',mat2str(n),'mp',mat2str(mp),'ms',mat2str(ms),'COp',mat2str(pCO),'tk',mat2str(tk),'testNr',mat2str(tn),'.mat');
test3=load(filename);

x=linspace(1,test1.hyperparameters.tk+1,test1.hyperparameters.tk+1);

y1=test1.yParam.max;
y2=test2.yParam.max;
y3=test3.yParam.max;

figure
plot(x, y1); hold on
plot(x, y2);
plot(x, y3); legend('test1', 'test2', 'test3'); xlabel('t[learning cycles]'); ylabel('log(Pœr)')


