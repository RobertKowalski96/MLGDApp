r0 = length(find(bestSolutionHistory(:,end)==0));
r1 = length(find(bestSolutionHistory(:,end)<0.01));
r2 = length(find(bestSolutionHistory(:,end)<0.1));
r3 = length(find(bestSolutionHistory(:,end)>0.1));
r4 = length(find(bestSolutionHistory(:,end)>0.3));
r5 = length(find(bestSolutionHistory(:,end)==1));

paramsy=[r0;r1;r2;r3;r4;r5]