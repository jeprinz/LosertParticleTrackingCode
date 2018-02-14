clc
clear
close all
%Do a run
disp('*************************************');
disp('  Welcome to the particle extractor');
disp('*************************************');
disp(' ');

basefolder= 'H:\ExperimentsResults\SingleHoleCompression\Run_121517\';
imageprefix='Image';
savefolder = 'H:\ExperimentsResults\SingleHoleCompression\Analysis_121517\';

sigma0=1; %sharpness of gaussian spherical filter
AR_z=1; % aspect ratio z to x,y

start_image=1; %these are the images corresponding to each z slice in a single frame
end_image=355; %last z slice (top)

x1=20; %these are limits of the region of interest
x2=500;

y1=16; %20;%!!both x2-x1+1 must be odd and same for y
y2=490;

c1=clock;

radius = 9; %measured diameter of 40 pixels

largeparts = zeros(1,12);

for i=1:1841 %10<--!!!frames
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