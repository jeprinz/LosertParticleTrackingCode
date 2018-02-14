data = load('Data Analysis 50 cycle test 7-2-15\Particle Locations and Orientations.mat');
load('Data Analysis 50 cycle test 7-2-15\imageIntensities.mat','intensities');
posdata = data.particles;
[~, firstPeaksIdx] = max(intensities(1:50,:));
for i = 1:19
lastPeakIdx(i) = mean(find(intensities(:,i)>2000));
end
shiftZpos = posdata;
shiftZpos(:,3) = posdata(:,3) - firstPeaksIdx(posdata(:,12))';
positions = shiftZpos;
indexesToCorrect = positions(:,12) == 6;
positions(indexesToCorrect,3) = positions(indexesToCorrect,3) / (lastPeakIdx(6) - firstPeaksIdx(6)) * mean(lastPeakIdx(1:5) - firstPeaksIdx(1:5));
indexesToCorrect =  positions(:,12) == 7;
positions(indexesToCorrect,3) = positions(indexesToCorrect,3) / (lastPeakIdx(7) - firstPeaksIdx(7)) * mean(lastPeakIdx(1:5) - firstPeaksIdx(1:5));
