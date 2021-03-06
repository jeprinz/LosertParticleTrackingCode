fig = figure;
axis equal;
axis([0, 500, 0 , 500, 0,500]);
set(fig,'Position',[30,30,1000,800]);
hold on;
title('Displacements of Particles After 188 Cycles (7-17-15 Run)');
xlabel('from inactive laser (pixels)');
ylabel('from compressor');
zlabel('from bottom of container');
c = colorbar('eastoutside');
c.Label.String = 'Displacement (pixels)';
c.Label.FontSize = 12;
AZ = -40;
EL = 30;
view([AZ EL]);
frame = 873;
locationid = tracksWithDisplacements(:,12) == frame;
location = tracksWithDisplacements(locationid,:);
highlights = mod(1:size(location,1),100) == 0;
cla;
scatter3(location(:,1),location(:,2),location(:,3) + 40 ,10,location(:,17).^0.5,'o','filled');