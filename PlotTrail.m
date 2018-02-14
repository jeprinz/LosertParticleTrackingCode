figure;
axis equal
hold on
xlabel('from inactive laser');
ylabel('from compression wall');
zlabel('height');
title('6 Cycle Particle Trail 1807 compressed');
poi = goodTracks(:,13) == 1807;
plot3(goodTracks(poi,1),goodTracks(poi,2),goodTracks(poi,3));
scatter3(goodTracks(poi,1),goodTracks(poi,2),goodTracks(poi,3),40,goodTracks(poi,12),'filled');