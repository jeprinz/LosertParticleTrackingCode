n = 1841;
MSDDisIns = zeros(n,1);
MSDDisInsSum = zeros(n,1);
for i = 1:n
     idx = tracksWithInstantDisp(:,12) == i;% & tracksWithDisplacements(:,2) > 400;
     MSDDisIns(i) = mean(tracksWithInstantDisp(idx,17));
     MSDDisInsSum(i) = mean(tracksWithInstantDisp(idx,21));
end
TimeVector = [0:1/16:10 , 10.25:1/4:390, 390.0625:1/16:400 ]';
TimeVector = TimeVector(1:n);
figure;
hold on
xlabel('Number of Cycles');
ylabel('Mean Square Displacement (pixels^2)');
title('400 Cycles MSD, Beads more than 20 bead diameters (400px) from wall (July 17 Run)');
plot(TimeVector(1:n),MSDDisIns,MSDDisInsSum)