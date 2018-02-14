figure(10);
axis equal;
axis([0, 500, 0 ,500, 0,500]);
hold on;
title('Movie of 3D locations');
xlabel('from inactive laser (pixels)');
ylabel('from compressor');
zlabel('height');
colormap copper;
AZ = -90;
EL = 0;
view([AZ EL]);
for loop = 1
    for frame = 1681:1841
        pause(1)
        locationid = goodTracks(:,12) == frame;
        location = goodTracks(locationid,:);
        highlights = mod(1:size(location,1),100) == 0;
        cla;
        scatter3(location(:,1),location(:,2),location(:,3),10,[0,1,0],'o','filled');
        %scatter3(location(highlights,1),location(highlights,2),location(highlights,3),30,[1,0,0], 'o','filled');
        legend(['frame' num2str(frame,'%03.0f')]);        
    end
end