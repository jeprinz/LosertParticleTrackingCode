savefolder = 'F:\users\dylan_eric\Data Analysis 07-17-15 Run\Particle Locations and Tracks\';
largeparts = zeros(1,12);
for scanNumber = 1:1841
    fileName = [savefolder 'scan' num2str(scanNumber, '%03.0f') '.mat'];
    load(fileName);
    largeparts = [largeparts ; tempresultlarge];
end
largeparts = largeparts(2:end,:);
save([savefolder 'Particle Locations and Orientations' '.mat'],'largeparts');
dlmwrite([savefolder 'Particle Locations and Orientations' '.txt'],largeparts,'delimiter','\t');
