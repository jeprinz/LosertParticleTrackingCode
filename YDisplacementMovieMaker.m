fig = figure;
hold on;
xlabel('Distance from compression wall (pixels)');
ylabel('Displacement away from compression wall');
axis([0 500 -3 7]);
videoObj = VideoWriter('YDisplacementMovieDeepCycle400.avi');
videoObj.FrameRate = 1;
open(videoObj);
for index = 1825:1841
    cla;
    title(['Y-Displacement of 8-10 layer deap beads in Cycle 400 after ' num2str((index-1825)/16,'%04.3f') ' cycles (July 20 run, 4 steps per cycle)']);
    set(fig,'Position',[30,30,1000,800]);
    poiBegin = goodTracks(:,12) == 1825;
    poiEnd = goodTracks(:,12) == index;
    deepParticles = goodTracks(poiBegin,3) < 160;
    poiBegin(poiBegin) = deepParticles;
    poiEnd(poiEnd) = deepParticles;
    scatter(goodTracks(poiBegin,2),goodTracks(poiEnd,2)-goodTracks(poiBegin,2),4,goodTracks(poiBegin,3),'filled');
    line([0 1000], [0 0]);
    c = colorbar('eastoutside');
    c.Label.String = 'z = height in pixels';
    c.Label.FontSize = 12;
    frameIm = getframe(fig);
    writeVideo(videoObj,frameIm);
end
close(videoObj);