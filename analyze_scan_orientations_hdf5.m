function out_as=analyze_scan_orientations_hdf5(imagefolder,scan_number,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z)
start_time = tic;
%KERNEL Radius is larger than physical radius
no_images=end_image-start_image+1;
crop_amount = 2*radius; %The amount that will get cropped off of each side of the image

disp('***********************************************');
disp('This is the analyze_scan function');
%%
%First create the Gauss_sphere
disp('a_s: Creating Gaussian sphere');
tic
Gauss_sph=single(Gauss_sphere(radius,sigma0,AR_z));
toc
%%
%Load all images%creates 3d image array and makes a cropped version to
%line up with final moments
disp('a_s: Loading and pre-processing images');
tic
IMS=load_images_hdf5(start_image,end_image,x1,x2,y1,y2,imagefolder,scan_number);
toc
%%
%Threshold and invert

disp('a_s: Thresholding and inverting images');
tic
IMS_inverted = thresh_invert(IMS);
time_threshold = toc;
%%

disp('a_s: Band-filtering all images');
tic
IMSbp=bandpass(crop_amount,IMS_inverted); %remember bandpass cuts off radius*2 from EACH side in x so the x and y dimensions are reduced by !!4*radius!!
time_bandpass = toc;

%% create IMSCr (thresholded bandpassed image)
thresh_val=1e-5;
tic
IMSCr = IMSbp <= thresh_val;
toc

%Convolve
disp('a_s: Convolving... This may take a while');
tic

[X, Y, Z] = meshgrid(-radius:radius, -radius:radius, -radius:radius);
sph = ((X .^ 2 + Y .^ 2 + Z .^ 2) <= radius^2); %sph is a filled in sphere

IMS_convolved = convolve(IMSbp, Gauss_sph); %JACOB note: this is how it was
%IMS_convolved = convolve(~IMSCr, sph);
time_convolve = toc;

%% create pkswb (thresholded convolution image)
disp('a_s: Thresholding');
%TWEAK THRESHOLD
disp('using new threshold method');
tic
IMS_thresholded = IMS_convolved > 0;% JACOB NOTE: this is how it was
%IMS_thresholded = IMS_convolved > 5000;
toc
%%
disp('a_s: Tagging regions');
tic
region_list = label_regions(IMS_thresholded);

%%
disp('a_s: Computing result matrix');
Result = compute_result(region_list, crop_amount, IMSCr, radius);% JACOB note: this is how it was
%Result = compute_result(region_list, crop_amount, IMS_thresholded, x1, x2, y1, y2, no_images, radius, IMSCr);
time_label_regions = toc;

%JACOB NOTE: for some reason X and Y are being transposed in the label regions function, so I'm putting in this stupid fix here:
Result(:,11) = Result(:,1);
Result(:,1) = Result(:,2);
Result(:,2) = Result(:,11);
%TODO: really fix the above
%TODO TODO: really really pls fix it

disp("Total processing time:")
total_time = toc(start_time);

%JACOB NOTE: commenting and replace the following line for testing.
with_spheres = draw_beads(IMS, radius, Result);

%replace with this:
%positions = test_calc_positions(region_list);
%with_spheres = draw_spheres(IMS_thresholded, radius, positions);

figure(1);
title("calculated spheres");
jimage(with_spheres, 1);

figure(2);
other_time = total_time - time_threshold - time_bandpass - time_convolve - time_label_regions;
pie([time_threshold, time_bandpass, time_convolve, time_label_regions, other_time], ....
    ["Threshold " + time_threshold, "Bandpass " + time_bandpass, "Convovle " + time_convolve, "Region finding " + time_label_regions, "Other " + other_time]);

%%
disp('a_s: DONE, the analyze_scan function has ended.');
disp('***********************************************');
out_as=Result(2:length(Result),:);

%% The folowing functions are helpers to the above, which do the individual processing steps

function out=bandpass(crop_amount,IMS)
%Note that the bandpass will crop off 2*radius from sides of image

s = size(IMS);
no_images = s(3);
sbp=size(bpass_jhw(IMS(:,:,1),0,crop_amount));%form: bpass_jhw(image_array,lnoise,lobject,threshold) Radius*2 is slightly smaller than physical radius*2
IMSbp=single(zeros(sbp(1),sbp(2),no_images));%IMSbp is a 0matrix with size equal to the size of the bandpassed orignal image

for b=1:no_images
    IMSbp(:,:,b)=single(bpass_jhw(IMS(:,:,b),0,crop_amount));
end

out=IMSbp;
%%

function out=convolve(IMSbp, Gauss_sph)
splits = 5; %has to do with RAM constraints on jcorr3d function

Convol=single(jcorr3d(IMSbp,Gauss_sph,splits));

sizekernel=size(Gauss_sph);
sC=size(Convol);%convolve does change size by adding a Kernel radius on either side of all dimmensions
Convol=Convol( round(sizekernel(1)/2) : round(sC(1) - sizekernel(1)/2) ...
            ,  round(sizekernel(2)/2) : round(sC(2) - sizekernel(2)/2) ...
            ,  round(sizekernel(3)/2) : round(sC(3) - sizekernel(3)/2)  );%crops (radius of the kernel*2) in order to bring Covol back to the same dimensions as the bandpassed image

sIMSCr=size(IMSbp); 
sC=size(Convol);
if sIMSCr~=sC
    disp('error: size of bandpassed image ~= to convolved+cropped image')
    return
end
out = Convol;
%%
%NOTE: this function returns the X and Y swapped from what the should be.
function out = label_regions(IMSthresholded)
L=bwlabeln(IMSthresholded);%output is an array with size of IMSthresholded where all touching pixels in the 3d array have the same id number, an integer)
disp('a_s: Imposing Volume minimum of 4');
Resultunf=regionprops(L,'Area');%[NOTE L is array of TAGGED regions]; creates structure Resultunf with one 1x1 matricies(in a col) that are the areas of the tagged regions (sequentially by tag #) 
idx=find([Resultunf.Area]>=4);%index of all regions with nonzero area
L2=ismember(L,idx);%output is array with size L of 1's where elements of L are in the set idx~which is just 1:number of regions. Therefore it converts all tagged regions to all 1's
L3=bwlabeln(L2);% L3 now retaggs (L3=old L2)

%disp('a_s: Determining weighted centroid locations and orientations');
region_list=regionprops(L3,'PixelIdxList', 'PixelList');%s is a struct that holds structs for each tagged
out = region_list;
%%

%Takes regions of image and computes final result with positions and orientations of beads.
function out = compute_result(region_list, crop_amount, IMSCr, radius)
    
Result=zeros(numel(region_list),11);
for k = 1:numel(region_list)%#elements in regions_list (#regions or particles)
    idx = region_list(k).PixelIdxList;%lin index of all points in region k
    pixel_values = double(IMSCr(idx)+.0001);%list of values of the pixels in convol which has size of idx
    sum_pixel_values = sum(pixel_values);   
    x = region_list(k).PixelList(:, 1);%the list of x-coords of all points in the region k WITH RESPECT TO the bandpassed image
    y = region_list(k).PixelList(:, 2);
    z = region_list(k).PixelList(:, 3);
    xbar = sum(x .* pixel_values)/sum_pixel_values + crop_amount;%PLUS Cr BECAUSE
    ybar = sum(y .* pixel_values)/sum_pixel_values + crop_amount;%I CUT OFF Cr OF THE IMAGE DURING BANDPASS!(in x and y only) AND cropped kernelradius/2 off each side (in x,y,z)(but it was put back)                                                         %cropped radius/2 of each side
    zbar = sum(z .* pixel_values)/sum_pixel_values;%adding Cr above brings back to IMS
    Result(k,1:3) = [xbar ybar zbar];%centroids; x1 and y1 are the coords of the top left corner of region of interest(in the original image)
    
    cylResult = HoleOrientation(IMSCr, [xbar-crop_amount ybar-crop_amount zbar-crop_amount], radius, 1);
    if cylResult ~= false
        Result(k, 4) = 1; %Says that there was a cylinder found
        avgDirection = (cylResult(1,:) + cylResult(2,:)) / 2;
        Result(k, 5:7) = avgDirection;
    else
        Result(k, 4) = 0; %Says no cylinder found
    end
end
out = Result;
%%