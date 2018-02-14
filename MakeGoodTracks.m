load('F:\users\dylan_eric\Data Analysis DataRun_071015\fullTracks7.mat');
goodTrackStartIds = find(tracks7(:,5) > 20 & tracks7(:,12) == 1);
[ids, no18] = meshgrid(goodTrackStartIds, 1:8);
goodTrackIds = ids + no18 - 1;
goodTrackIds = goodTrackIds(:);
goodTracks = tracks7(goodTrackIds,:);
clearvars -except goodTracks;
