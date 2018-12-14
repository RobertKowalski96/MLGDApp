function [distanceParam, yParam] = calculateAllParam (population,t, distanceParam, yParam, points2)

[m,n] = size(population);
distance = zeros(1, (m*(m-1))/2);

idx=1;
for i = 1 : m-1
    for j = i+1 : m
        singleDistance = 0;
        for r = 1 : n
            singleDistance = singleDistance + (population(i,r) - population(j,r)).^2;
        end
        distance(idx) = singleDistance.^(1/2);
        idx=idx+1;
    end
end

distanceParam.mean(t) = mean(distance);
distanceParam.med(t) = median(distance);
distanceParam.std(t) = std(distance);
distanceParam.max(t) = max(distance);
distanceParam.min(t) = min(distance);


yParam.min(t)=min(points2);
yParam.max(t)=max(points2);
yParam.mean(t)=mean(points2);
yParam.med(t)=median(points2);
yParam.std(t) = std(points2);

end