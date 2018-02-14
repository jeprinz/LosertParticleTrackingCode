clc
clear all
close all
%Do a run
disp('*************************************');
disp('  Welcome to the particle extractor');
disp('*************************************');
disp(' ');

basefolder= 'X:\ExperimentsRawData\CyclicCompression\Experiment_01_24_18\';
imageprefix='Image';
savefolder = 'X:\ExperimentsAnalysis\CyclicCompression\Analysis_01_24_18\';

sigma0=1; %sharpness of gaussian spherical filter
AR_z=1; % aspect ratio z to x,y

start_image=50; %these are the images corresponding to each z slice in a single frame
end_image=455; %last z slice (top)

x1=12; %these are limits of the region of interest
x2=838;

y1=16; %20;%!!both x2-x1+1 must be odd and same for y
y2=858;

c1=clock;

radius = 16; %measured diameter of one bead of 32 pixels

largeparts = zeros(1,12);

for i=1500:2241 %10<--!!!frames
    imagefolder = [basefolder 'Scan' num2str(i,'%03.0f') '\'];
    disp('====================');
    disp('MAIN LOOP');
    cml1=clock;
    disp(['Currently Extracting from Image i=' num2str(i) '.']);
    disp('Starting extraction of particles:'); 
    result = analyze_scan_orientations(imagefolder,imageprefix,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z);
    disp(['>>Found ' num2str(length(result)) ' particles.']);
    clear tempresultlarge
    tempresultlarge=[result i*ones(length(result),1)];
    largeparts=[largeparts; tempresultlarge];
    disp('Saving lifeguard txt and matrix files');
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