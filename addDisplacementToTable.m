startIds = goodTracks(:,12) == 1;
basePositions = goodTracks(startIds,:);
tracksWithDisplacements = zeros(length(goodTracks(:,1)),17);
tracksWithDisplacements(:,1:13) = goodTracks;
tracksWithDisplacements(:,14) = goodTracks(:,1) - basePositions(goodTracks(:,13),1);
tracksWithDisplacements(:,15) = goodTracks(:,2) - basePositions(goodTracks(:,13),2);
tracksWithDisplacements(:,16) = goodTracks(:,3) - basePositions(goodTracks(:,13),3);
tracksWithDisplacements(:,17) = tracksWithDisplacements(:,14) .^ 2 + tracksWithDisplacements(:,15) .^ 2 +tracksWithDisplacements(:,16) .^ 2;