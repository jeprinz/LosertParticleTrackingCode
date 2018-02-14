fig = figure(10);
axis equal;
axis([-1.5, 1.5, -1.5 ,1.5, -1.5 1.5]);
set(fig,'Position',[30,30,1000,800]);
hold on;
beadNumber = 1782;
particleTrackIds = goodTracks(:,13) == beadNumber;
beadOrientations = goodTracks(particleTrackIds,9:12);
Positions = goodTracks(particleTrackIds,1:3);
xPos = floor(Positions(1,1));
yPos = floor(Positions(1,2));
zPos = floor(Positions(1,3));
titleText = sprintf(['Movie of Orientaions of Bead ' num2str(beadNumber) '\n at x=' num2str(xPos) ' y=' num2str(yPos) ' z=' num2str(zPos)]);
title(titleText);
xlabel('x');
ylabel('y');
zlabel('z');
AZ = 9;
EL = 38;
view([AZ EL]);
videoObj = VideoWriter(['OrienationBead' num2str(beadNumber) 'withTrail2.avi']);
videoObj.FrameRate = 40;
open(videoObj);
relaxedStates = floor(frameNo2Cycles(beadOrientations(:,4))) == frameNo2Cycles(beadOrientations(:,4));
for frame = 1:1841
    cla;
    point = beadOrientations(frame,:);
    plot3([point(1) -point(1)], [point(2) -point(2)], [point(3) -point(3)]);
    time = frameNo2Cycles(beadOrientations(1:frame,4));
    scatter3(beadOrientations(1:frame,1),beadOrientations(1:frame,2),beadOrientations(1:frame,3),6, time,'o','filled');
    scatter3(-beadOrientations(1:frame,1),-beadOrientations(1:frame,2),-beadOrientations(1:frame,3),6,time,'o','filled');
    legend(['Cycle ' num2str(frameNo2Cycles(frame),'%05.3f')],'Location','northeast');
    frameIm = getframe(fig);
    writeVideo(videoObj,frameIm);
end

close(videoObj);