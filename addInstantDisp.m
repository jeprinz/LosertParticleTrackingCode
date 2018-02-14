startIds = goodTracks(:,12) == 1;
tracksWithInstantDisp = zeros(length(goodTracks(:,1)),21);
tracksWithInstantDisp(:,1:13) = goodTracks;
tracksWithInstantDisp(:,14:16) = goodTracks(:,1:3) - [0 0 0 ; goodTracks(1:end-1,1:3)];
tracksWithInstantDisp(startIds,14:16) = 0;
tracksWithInstantDisp(:,17) = sqrt(dot(tracksWithInstantDisp(:,14:16),tracksWithInstantDisp(:,14:16),2));
tracksWithInstantDisp(:,18:21) = cumsum(abs(tracksWithInstantDisp(:,14:17)));
basePositions = tracksWithInstantDisp(startIds,18:21);
tracksWithInstantDisp(:,18:21) = tracksWithInstantDisp(:,18:21) - basePositions(goodTracks(:,13),:);