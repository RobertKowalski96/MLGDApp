function [distanceParam] = calculateDistanceParam (population,t, distanceParam)

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

distanceParam.sum(t) = sum(distance);
distanceParam.mean(t) = mean(distance);
distanceParam.med(t) = median(distance);
distanceParam.std(t) = std(distance);
distanceParam.max(t) = max(distance);
distanceParam.min(t) = min(distance);

end