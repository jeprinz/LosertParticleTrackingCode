clc
clear all
close all
%Do a run
disp('*************************************');
disp('  Welcome to the particle extractor');
disp('*************************************');
disp(' ');

imagefolder= 'X:\ExperimentsRawData\CyclicCompression\Experiment_01_30_18\';
savefolder = 'X:\ExperimentsAnalysis\CyclicCompression\Analysis_01_30_18\';

sigma0=1; %sharpness of gaussian spherical filter
AR_z=1; % aspect ratio z to x,y

start_image=100; %these are the images corresponding to each z slice in a single frame
end_image=479; %last z slice (top)

x1=1; %these are limits of the region of interest
x2=819;

y1=1; %20;%!!both x2-x1+1 must be odd and same for y
y2=828;

c1=clock;

radius = 16; %measured diameter of one bead of 32 pixels

largeparts = zeros(1,12);

for i=1368:2241 % number of frames
    disp('====================');
    disp('MAIN LOOP');
    cml1=clock;
    disp(['Currently Extracting from Image i=' num2str(i) '.']);
    disp('Starting extraction of particles:'); 
    result = analyze_scan_orientations_hdf5(imagefolder,i,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z);
    disp(['>>Found ' num2str(length(result)) ' particles.']);
    clear tempresultlarge
    tempresultlarge=[result i*ones(length(result),1)];
    largeparts=[largeparts; tempresultlarge];
    disp('Saving hdf5 files');
    save([savefolder 'scan' num2str(i,'%03.0f') '.mat'],'tempresultlarge');
    dlmwrite([savefolder 'scan' num2str(i,'%03.0f') '.txt'],tempresultlarge,'delimiter','\t');
    disp('>>Please don`t turn me off!');
    cml2=clock;
    disp(['>>Main loop cycle took ' num2str(etime(cml2,cml1)) ' seconds.']);
end %for i

largeparts(1,:)=[];
c2=clock;
save([savefolder 'Particle Locations and Orientations' '.mat'],'largeparts');
dlmwrite([savefolder 'Particle Locations and Orientations' '.txt'],largeparts,'delimiter','\t');
disp('=========================================');
disp(['Program has finished in: ' num2str(etime(c2,c1)) ' seconds.']);
largeparts=zeros(1,11);