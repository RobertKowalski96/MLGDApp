

yMaxCykle=find(yParam.max>=(max(yParam.max))/0.95,1)
yMaxWartosc=yParam.max(yMaxCykle)
yMaxCzas=sum(time(1:yMaxCykle))

estymatorCykle=find(modelZero.aucHistory>=0.95,1)
EstymatorCzas=sum(time(1:(estymatorCykle-1)*10))

paramsy=[yMaxWartosc;yMaxCykle;yMaxCzas;estymatorCykle*10;EstymatorCzas]