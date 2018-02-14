fig = figure(10);
axis equal;
axis([0, 500, 0 , 500, 0,500]);
set(fig,'Position',[30,30,1000,800]);
hold on;
title('Movie of 3D locations');
xlabel('from inactive laser (pixels)');
ylabel('from compressor');
zlabel('height');
%colormap copper;
AZ = -40;
EL = 30;
view([AZ EL]);
videoObj = VideoWriter('RawExtractionMovie.avi');
videoObj.FrameRate = 40;
open(videoObj);
for loop = 1
    for frame = 1:1841
        locationid = goodTracks(:,12) == frame;
        location = goodTracks(locationid,:);
        %highlights = mod(1:size(location,1),100) == 0;
        cla;
        scatter3(location(:,1),location(:,2),location(:,3),10,location(:,3),'o','filled');
        %scatter3(location(highlights,1),location(highlights,2),location(highlights,3),30,[1,0,0], 'o','filled');
        legend(['frame' num2str(frame)],'representively selected tracer particles','Location','northeast');
        frameIm = getframe(fig);
        writeVideo(videoObj,frameIm);
    end
end
AZ = -90;
EL = 0;
view([AZ EL]);
for loop = 1:2
    for frame = 1:16
        pause(.1)
        locationid = goodTracks(:,12) == frame;
        location = goodTracks(locationid,:);
        highlights = mod(1:size(location,1),100) == 0;
        cla;
        scatter3(location(:,1),location(:,2),location(:,3),10,[0.5,0.5,0.5],'o','filled');
        scatter3(location(highlights,1),location(highlights,2),location(highlights,3),30,[1,0,0], 'o','filled');
        legend(['frame' num2str(frame)],'representively selected tracer particles','Location','northeast');
        frameIm = getframe(fig);
        writeVideo(videoObj,frameIm);
    end
end
close(videoObj);