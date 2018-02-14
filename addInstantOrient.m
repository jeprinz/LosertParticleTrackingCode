startIds = goodTracks(:,12) == 1;
tracksWithInstantOrient = zeros(length(goodTracks(:,1)),21);
tracksWithInstantOrient(:,1:13) = goodTracks;
tracksWithInstantOrient(:,14:16) = cross(goodTracks(:,9:11), [0 0 0 ; goodTracks(1:end-1,9:11)]);
tracksWithInstantOrient(startIds,14:16) = 0;
tracksWithInstantOrient(:,17) = sqrt(dot(tracksWithInstantOrient(:,14:16),tracksWithInstantOrient(:,14:16),2));
tracksWithInstantOrient(:,18:21) = cumsum(abs(tracksWithInstantOrient(:,14:17)));
basePositions = tracksWithInstantOrient(startIds,18:21);
tracksWithInstantOrient(:,18:21) = tracksWithInstantOrient(:,18:21) - basePositions(goodTracks(:,13),:);