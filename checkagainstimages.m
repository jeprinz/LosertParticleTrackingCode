clc
close all

%Do a run
disp('*************************************');
disp('  Welcome to the image checker');
disp('*************************************');
disp(' ');

basefolder= 'C:\students\dylan_eric\1% compression 2 cycles 8 frames\';
imageprefix='Image';
savefolder = 'F:\users\dylan_eric\Data Analysis 2 cycle test 7-8-15\';
i = 1;
imagefolder = [basefolder 'Scan' num2str(i,'%03.0f') '\'];

start_image=45; %these are the images corresponding to each z slice in a single frame
end_image=400; %last z slice (top)

x1=93; %these are limits of the region of interest
x2=1001;

y1=170; %20;%!!both x2-x1+1 must be odd and same for y
y2=1100;

radius = 19; %measured diameter of 40 pixels

IMS=load_images_simple(start_image,end_image,x1,x2,y1,y2,imagefolder,imageprefix);
IMS = thresh_invert(IMS);
z = 350;
im=IMS(:,:,z);
figure;
imagesc(im);
axis equal;
colormap('gray');
hold on;

xlabel('Distance from broken laser (pixels)');
ylabel('Distance from compression wall (pixels)');
title(['Locations and orientations of bright fully tracked beads near layer ' num2str(z) ' of Scan ' num2str(i)]);

idx=find((large_t(:,3) >= z-radius) & (large_t(:,3) <= z+radius) & (large_t(:,12) == i) & (large_t(:,5) > 20));

% Plot circles showing particle centers
for i=1:length(idx)
    diffz=abs(z-large_t(idx(i),3));
    [cx,cy]=jcircle(sqrt(radius^2-diffz^2));
    plot(large_t(idx(i),1)+cx-1,large_t(idx(i),2)+cy-1,'r');
end

% Plot arrows showing orientation
dir = radius*large_t(:,9:11);
for j = 1:length(idx)
    endpts = [large_t(idx(j),1)-dir(idx(j),1) large_t(idx(j),2)-dir(idx(j),2) large_t(idx(j),3)-dir(idx(j),3); large_t(idx(j),1)+dir(idx(j),1) large_t(idx(j),2)+dir(idx(j),2) large_t(idx(j),3)+dir(idx(j),3)];
    xpts = linspace(endpts(1,1),endpts(2,1),50);
    ypts = linspace(endpts(1,2),endpts(2,2),50);
    plot(xpts,ypts,'g-');
end
