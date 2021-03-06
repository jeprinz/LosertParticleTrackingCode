
imagefolder ='C://Users/Jacob/development/GransOfSand/'; % folder within which images are saved;

start_image=300;%these are the images corresponding to each z slice in a single frame (NOTE: z-slices start with index 0)
end_image=400;%last z slice (top)
x1=1; %these are limits of the region of interest
x2=825;
y1=1;
y2=835;
radius = 12;
sigma0 = 1;
AR_z = 1;
scan_number = 16;

result=analyze_scan_orientations_hdf5(imagefolder,scan_number,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z);
