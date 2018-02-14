beadNumber = 1982;
poi = tracksDispOrients(:,13) == beadNumber;
Positions = tracksDispOrients(poi,1:3);
xPos = floor(Positions(1,1));
yPos = floor(Positions(1,2));
zPos = floor(Positions(1,3));
timeVector = frameNo2Cycles(1:1841);
figure;
hold on;
xlabel('Cycle Number')
ylabel('Angular Displacement (radians)');
titleText = sprintf(['Angular Displacement of Bead ' num2str(beadNumber) '\n at x=' num2str(xPos) ' y=' num2str(yPos) ' z=' num2str(zPos)]);
title(titleText);
plot(timeVector,tracksDispOrients(poi,22));
figure;
hold on;
xlabel('Cycle Number')
ylabel('Linear Displacement (pixels)');
titleText = sprintf(['Linear Displacement of Bead ' num2str(beadNumber) '\n at x=' num2str(xPos) ' y=' num2str(yPos) ' z=' num2str(zPos)]);
title(titleText);
plot(timeVector,sqrt(tracksDispOrients(poi,17)));
