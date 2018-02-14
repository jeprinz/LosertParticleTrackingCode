figure(10);
axis equal;
axis([0, 500, 0 , 500, 0,500]);
hold on;
title('Fully Tracked Particles through scan 873 (7-17-15 Run)');
xlabel('from inactive laser (pixels)');
ylabel('from compressor');
zlabel('from bottom of container');
c = colorbar('eastoutside');
c.Label.String = 'z = height in pixels';
c.Label.FontSize = 12;
AZ = -40;
EL = 30;
view([AZ EL]);
for frame = 1:1841
    pause(1);
    locationid = goodTracks(:,12) == frame;
    location = goodTracks(locationid,:);
    highlights = mod(1:size(location,1),100) == 0;
    cla;
    scatter3(location(:,1),location(:,2),location(:,3) + 40 ,10,location(:,3),'o','filled');
    legend(['frame' num2str(frame,'%03.0f')]);
end
