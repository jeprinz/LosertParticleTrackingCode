function out=load_images_simple(start_image,end_image,x1,x2,y1,y2,imagefolder,imageprefix)%creates a 3d image in the region of interest

%pre-allocate matrix space
dx=x2-x1+1;%800-1+1 these are dimensions of the region of interest
dy=y2-y1+1;%800-1+1
no_images=end_image-start_image+1;
IMS=(zeros(dy,dx,no_images));


j=0;
for i=start_image:end_image %bottom z slice to top
    j=j+1;
    IMSr=im2double(imread([imagefolder imageprefix num2str(i,'%03.0f') '.tif']));%the image that is a single z slice
    im=IMSr(y1:y2,x1:x2);%selects the 2d region of interest as the region to put in the 3d image at slice i
    IMS(:,:,j)=im;
end
out=IMS;