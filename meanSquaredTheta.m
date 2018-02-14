n = 1841;
MST = zeros(n,1);
for i = 1:n
     idx = tracksDispOrients(:,12) == i & tracksDispOrients(:,2) > 400;
     MST(i) = mean(tracksDispOrients(idx,22).^2);
end
TimeVector = [0:1/16:10 , 10.25:1/4:390, 390.0625:1/16:400 ]';
TimeVector = TimeVector(1:n);
figure;
hold on
xlabel('Number of Cycles');
ylabel('Mean Squared Angular Displacement (radians^2)');
title('400 Cycles Mean Squared Theta, Beads more than 400px from container (July 17 Run)');
plot(TimeVector(1:n),MST);