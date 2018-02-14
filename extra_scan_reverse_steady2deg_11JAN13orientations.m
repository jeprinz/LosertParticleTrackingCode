clc
clear
close all
%Do a run
disp('*************************************');
disp('  Welcome to the particle extracter');
disp('*************************************');
disp(' ');

basefolder='H:\steady2deg_rotations09JAN13\';
outfolder = basefolder; 
disp('Gathering information...');
AR_z=1;
start_image=28;%these are the images corresponding to each z slice in a single frame
end_image=239;%last z slice (top)
x1=16; %these are limits of the region of interest
x2=773;
y1=56;%20;%!!both x2-x1+1 must be odd and same for y
y2=800; 
sizx=round((x2-x1+1)/2);
sizy=round((y2-y1+1)/2);
sizz=round((end_image-start_image+1)/2);
disp('done forming list of image pixels.')
c1=clock;
largeparts=zeros(1,14);
savefolder = 'H:\Rotations Data\steady2deg_rotations09JAN13\56on\';
for j = 14:14 %radius
    for k=1:1%2cycle
        for i=56:360 %10<--!!!frames
            imagefolder=[basefolder 'frame' num2str(i,'%04.0f') '\'];
            imageprefix=['shear' num2str(i,'%04.0f')];
            saveprefix=num2str(i,'%03.0f');
            disp('====================');
            disp('MAIN LOOP');
            cml1=clock;
            %disp(['Currently k=' num2str(k) ', i=' num2str(i) '.']);
            disp('Starting extraction for all particles:');
            radius=j;
            sigma0=1;
            result=analyze_scan_orientations_steady2deg11JAN13(imagefolder,imageprefix,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z);
            disp(['>>Found ' num2str(length(result)) ' large particles.']);
            clear tempresultlarge
            tempresultlarge=[result j*ones(length(result),1) k*ones(length(result),1) i*ones(length(result),1)];
            largeparts=[largeparts;tempresultlarge];
            disp('Saving lifeguard txt-files');
            dlmwrite([savefolder 'diameter' num2str(fix(2*j),'%03.0f') 'k' num2str(k,'%03.0f') 'i' num2str(i,'%03.0f') '_large.txt'],tempresultlarge,'delimiter','\t');        
            disp('>>Please don`t turn me off!');
            cml2=clock;
            disp(['>>Main loop cycle took ' num2str(etime(cml2,cml1)) ' seconds.']);            
        end %for i
    end %for k
    largeparts(1,:)=[];
    c2=clock;
    save([savefolder 'results_diameter' num2str(fix(2*j),'%03.0f') '.mat'],'largeparts');
    dlmwrite([savefolder 'results_large_diameter' num2str(fix(2*j),'%03.0f') '.txt'],largeparts,'delimiter','\t');        
    disp('=========================================');
    disp(['Program has finished in: ' num2str(etime(c2,c1)) ' seconds.']);
    largeparts=zeros(1,11);
end %for j