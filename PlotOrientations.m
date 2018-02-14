figure;
scatter3(0,0,0);
hold on
axis equal
axis([-1.5,1.5,-1.5,1.5,-1.5,1.5]);
title('Orientation of Bead over 2 cycles');
c = colorbar('eastoutside');
c.Label.String = 'scan number'; 
c.Label.FontSize = 12;
poi = goodTracks(:,13) == 1248;
scatter3(goodTracks(poi,9),goodTracks(poi,10),goodTracks(poi,11),4 * goodTracks(poi,12), goodTracks(poi, 12), 'filled');
scatter3(-goodTracks(poi,9),-goodTracks(poi,10),-goodTracks(poi,11),4 * goodTracks(poi,12), goodTracks(poi, 12), 'filled');
plot3(goodTracks(poi,9),goodTracks(poi,10),goodTracks(poi,11));
plot3(-goodTracks(poi,9),-goodTracks(poi,10),-goodTracks(poi,11));
