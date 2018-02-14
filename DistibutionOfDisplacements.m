 poi = tracksWithDisplacements(:,12) == 873;
 figure;
 hold on;
 xlabel('Squared Displacement (pixels^2)');
 ylabel('frequency')
 title('Distribution of Squared Displacements after 188 cycles');
 hist(tracksWithDisplacements(poi,17),100);
 line([mean(tracksWithDisplacements(poi,17)), mean(tracksWithDisplacements(poi,17))],[0 , max(hist(tracksWithDisplacements(poi,17),100));]);
 text(mean(tracksWithDisplacements(poi,17)) * 1.1, max(hist(tracksWithDisplacements(poi,17),100) * 0.9 ), 'Mean');
 