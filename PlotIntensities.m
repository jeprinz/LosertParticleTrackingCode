disp('*************************************');
disp('  Welcome to the image loader');
disp('*************************************');
disp(' ');

basefolder= 'L:\DataRun_072015\';
imageprefix='Image';
for i = 1:1841;
    
disp(['processing scan no' num2str(i)]);
imagefolder = [basefolder 'Scan' num2str(i,'%03.0f') '\'];

start_image=1; %these are the images corresponding to each z slice in a single frame
end_image=476; %last z slice (top)

x1=13; %these are limits of the region of interest
x2=485;

y1=26; %20;%!!both x2-x1+1 must be odd and same for y
y2=480;

IMS = load_images_simple(start_image,end_image,x1,x2,y1,y2,imagefolder,imageprefix);
intensities(:,i) = squeeze(sum(sum(IMS)));

end
figure;
hold on
xlabel('Slice number');
ylabel('Intensity');
title('Alignment of intensity profiles')
plot(intensities);
save('intensities.mat','intensities');