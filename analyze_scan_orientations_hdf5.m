function out_as=analyze_scan_orientations_hdf5(imagefolder,scan_number,start_image,end_image,x1,x2,y1,y2,radius,sigma0,AR_z)
tic
%KERNEL Radius is larger than physical radius
no_images=end_image-start_image+1;
crop_amount = 2*radius; %The amount that will get cropped off of each side of the image

disp('***********************************************');
disp('This is the analyze_scan function');
%%
%First create the Gauss_sphere
disp('a_s: Creating Gaussian sphere');
Gauss_sph=single(Gauss_sphere(radius,sigma0,AR_z));
%%
%Load all images%creates 3d image array and makes a cropped version to
%line up with final moments
disp('a_s: Loading and pre-processing images');
IMS=load_images_hdf5(start_image,end_image,x1,x2,y1,y2,imagefolder,scan_number);
%%
%Threshold and invert
disp('a_s: Thresholding and inverting images');
IMS = thresh_invert(IMS);
%%

disp('a_s: Band-filtering all images');
IMSbp=bandpass(crop_amount,IMS); %remember bandpass cuts off radius*2 from EACH side in x so the x and y dimensions are reduced by !!4*radius!!

%% create IMSCr (thresholded bandpassed image)
%TWEAK THRESHOLD
%IMSCr is an inverted copy of the bandpassed img since IMSbp gets convolved
thresh_val=1e-5;

IMSCr = IMSbp <= thresh_val;

%Convolve
disp('a_s: Convolving... This may take a while');
IMS_convolved = convolve(IMSbp, Gauss_sph);

%% create pkswb (thresholded convolution image)
disp('a_s: Thresholding');
%TWEAK THRESHOLD
disp('using new threshold method');
IMS_thresholded = IMS_convolved > 0;
%%
disp('a_s: Tagging regions');
region_list = label_regions(IMS_thresholded);
%% 

Result = compute_result(region_list, crop_amount, IMS_convolved, x1, x2, y1, y2, no_images, radius, IMSCr);
  
%%
disp('a_s: DONE, the analyze_scan function has ended.');
disp('***********************************************');
toc
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

function out = label_regions(IMSthresholded)
L=bwlabeln(IMSthresholded);%output is an array with size of IMSthresholded where all touching pixels in the 3d array have the same id number, an integer)
disp('a_s: Imposing Volume minimum of 4');
Resultunf=regionprops(L,'Area');%[NOTE L is array of TAGGED regions]; creates structure Resultunf with one 1x1 matricies(in a col) that are the areas of the tagged regions (sequentially by tag #) 
idx=find([Resultunf.Area]>=4);%index of all regions with nonzero area
L2=ismember(L,idx);%output is array with size L of 1's where elements of L are in the set idx~which is just 1:number of regions. Therefore it converts all tagged regions to all 1's
L3=bwlabeln(L2);% L3 now retaggs (L3=old L2)
%%
disp('a_s: Determining weighted centroid locations and orientations');
region_list=regionprops(L3,'PixelIdxList', 'PixelList');%s is a struct that holds structs for each tagged 
out = region_list;


function out = compute_result(region_list, crop_amount, IMS_convolved, x1, x2, y1, y2, no_images, radius, IMSCr)
    
Result=zeros(numel(region_list),11);
for k = 1:numel(region_list)%#elements in regions_list (#regions or particles)
    idx = region_list(k).PixelIdxList;%lin index of all points in region k
    pixel_values = double(IMS_convolved(idx)+.0001);%list of values of the pixels in convol which has size of idx
    sum_pixel_values = sum(pixel_values);   
    x = region_list(k).PixelList(:, 1);%the list of x-coords of all points in the region k WITH RESPECT TO the bandpassed image
    y = region_list(k).PixelList(:, 2);
    z = region_list(k).PixelList(:, 3);
    xbar = sum(x .* pixel_values)/sum_pixel_values + crop_amount;%PLUS Cr BECAUSE
    ybar = sum(y .* pixel_values)/sum_pixel_values + crop_amount;%I CUT OFF Cr OF THE IMAGE DURING BANDPASS!(in x and y only) AND cropped kernelradius/2 off each side (in x,y,z)(but it was put back)                                                         %cropped radius/2 of each side
    zbar = sum(z .* pixel_values)/sum_pixel_values;%adding Cr above brings back to IMS
    x2moment = sum((x - xbar + crop_amount).^2 .* pixel_values) / sum_pixel_values;%+2*radius is added to translate the x coord(ie xbar has already been translated)
    y2moment = sum((y - ybar + crop_amount).^2 .* pixel_values) / sum_pixel_values;%these are with respto the translated image(ie the original IMS)
    z2moment = sum((z - zbar).^2 .* pixel_values) / sum_pixel_values;%the pixelvalues and sum of pixvalues are taken from the corresponding points in the bandpassed image. only the location has been translated
    x3moment = sum((x - xbar + crop_amount).^3 .* pixel_values) / sum_pixel_values;
    y3moment = sum((y - ybar + crop_amount).^3 .* pixel_values) / sum_pixel_values;
    z3moment = sum((z - zbar).^3 .* pixel_values) / sum_pixel_values;
    xskew = x3moment/(x2moment)^(1.5);
    yskew = y3moment/(y2moment)^(1.5);
    zskew = z3moment/(z2moment)^(1.5);
    Result(k,1:3) = [xbar ybar zbar];%centroids; x1 and y1 are the coords of the top left corner of region of interest(in the original image)
    Result(k,4)   = max(pixel_values);
    Result(k,5)   = sum_pixel_values;
    Result(k,6:8) = [xskew yskew zskew];
    Result(k,9:11)=zeros(1,3);


    %NOW using the centroids(xyzbar), which are with respect to the
    %IMS (not original image), find the x,y,z lists(coords) of the points in the bandpassed img IMSCr within 1
    %physical radius of the centroid. and find priciple axes.
    
    if ((xbar<(1.5*crop_amount+3))||xbar>((x2-x1+1)-1.5*crop_amount-3)||(ybar<(1.5*crop_amount+3))||ybar>((y2-y1+1)-1.5*crop_amount-3)||(zbar<(crop_amount/2+1))||zbar>(no_images-crop_amount/2-1))||(Result(k,5)<= 0)%last condition takes only viable(large) pixel clusters
        %disp(num2str(k))%xbar/ybar is in IMS
        continue;%if particle on border, it cannot be relavant data since we have incomplete spacial information
    end
    % Translate back to cropped image (now realigned with IMSCr, pksbw, convol,
    % and IMSbp)
    xbar = xbar - crop_amount;
    ybar = ybar - crop_amount;
    [X,Y,Z] = meshgrid(ceil(xbar-radius):1:floor(xbar+radius),ceil(ybar-radius):1:floor(ybar+radius),ceil(zbar-radius):1:floor(zbar+radius));
    
    X = X(1,:,1);
    Y = transpose(Y(:,1,1));
    Z = Z(1,1,:);
    Z = transpose(Z(:));
    
    local_list = transpose(combvec(Y,X,Z));
    local_ind=sub2ind(size(IMSCr),local_list(:,1),local_list(:,2),local_list(:,3));

    local_list(:,4) = IMSCr(local_ind);%the value 1 or 0 at each point

    [~,~,R]= cart2sph(local_list(:,2)-xbar,local_list(:,1)-ybar,local_list(:,3)-zbar);
    local_list=local_list((R(:,1)<4/5*radius),:);%local list is now a sphere centered at current centroid
    clear R;
    
    Sum_IMSCr_pxls=sum(local_list(:,4));
    CoXX=sum(((local_list(:,2)-xbar).^2).*local_list(:,4))/Sum_IMSCr_pxls; %XX component of covariance matrix
    CoYY=sum(((local_list(:,1)-ybar).^2).*local_list(:,4))/Sum_IMSCr_pxls;
    CoZZ=sum(((local_list(:,3)-zbar).^2).*local_list(:,4))/Sum_IMSCr_pxls;
    CoXY=sum((local_list(:,2)-xbar).*(local_list(:,1)-ybar).*local_list(:,4))/Sum_IMSCr_pxls;
    CoXZ=sum((local_list(:,2)-xbar).*(local_list(:,3)-zbar).*local_list(:,4))/Sum_IMSCr_pxls;
    CoYZ=sum((local_list(:,1)-ybar).*(local_list(:,3)-zbar).*local_list(:,4))/Sum_IMSCr_pxls;
    Covmat=[CoXX,CoXY,CoXZ;CoXY,CoYY,CoYZ;CoXZ,CoYZ,CoZZ];
    if max(max(isnan(Covmat)))==1;%checks if any element of covmat is NAN==1
      
         Result(k,9:11)=NaN(1,3);sum
        continue
    else
        [V,D] = eig(Covmat);
            [eigval, col]=max(max(D));%picks out the greatest eigenval and its corresponding vector. col is the column that the 
            Result(k,9:11)=[V(1,col)*eigval,V(2,col)*eigval,V(3,col)*eigval];  
    end
    
    M3=norm(Result(k,9:11));
    Result(k,9:11)=Result(k,9:11)./M3;
end
out = Result;
