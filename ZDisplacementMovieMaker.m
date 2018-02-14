fig = figure;
hold on;
xlabel('Distance from compression wall (pixels)');
ylabel('Displacement away from compression wall');
axis([0 500 -20 10]);
colormap jet;
videoObj = VideoWriter('ZDisplacementMovieCycle100-390.avi');
videoObj.FrameRate = 16;
open(videoObj);
for index = 521:1681
    cla;
    title(['Z-Displacement all beads from cycle 100 after ' num2str((index-521)/4,'%04.3f') ' more cycles (July 20 run, 4 steps per cycle)']);
    set(fig,'Position',[30,30,1000,800]);
    poiBegin = goodTracks(:,12) == 521;
    poiEnd = goodTracks(:,12) == index;
    deepParticles = goodTracks(poiBegin,3) < 160;
    %poiBegin(poiBegin) = deepParticles;
    %poiEnd(poiEnd) = deepParticles;
    scatter(goodTracks(poiBegin,2),goodTracks(poiEnd,3)-goodTracks(poiBegin,3),4,goodTracks(poiBegin,3),'filled');
    line([0 1000], [0 0]);
    c = colorbar('eastoutside');
    c.Label.String = 'z = height in pixels';
    c.Label.FontSize = 12;
    frameIm = getframe(fig);
    writeVideo(videoObj,frameIm);
end
close(videoObj);