
for ScanNo = 98:180
    basefolder= 'C:\students\dylan_eric\DataRun_071015\';
    imageprefix='Image';
    savefolder = 'C:\students\dylan_eric\Compressed_DataRun_071015\';
    imagefolder = [basefolder 'Scan' num2str(ScanNo,'%03.0f') '\'];
    imagesavefolder = [savefolder 'Scan' num2str(ScanNo,'%03.0f') '\'];
    
    %pre-allocate matrix space
    dx= 1120;
    dy= 1108;
    no_images= 450;
    IMS=(zeros(dy,dx,no_images));
    
    disp(['Converting image ' num2str(ScanNo)]);
    mkdir(imagesavefolder);
    for index = 1:no_images/2 %bottom z slice to top
        im1=double(imread([imagefolder imageprefix num2str(index*2-1,'%03.0f') '.tif'])); %the image that is a single z slice
        im2=double(imread([imagefolder imageprefix num2str(index*2-1,'%03.0f') '.tif']));
        im = (im1 + im2) / 2;
        im = im(1:dy,1:dx);
        imq1 = im(1:2:end,1:2:end);
        imq2 = im(1:2:end,2:2:end);
        imq3 = im(2:2:end,1:2:end);
        imq4 = im(2:2:end,2:2:end);
        im = imq1 + imq2 + imq3 +imq4;
        im = uint16(im);
        imwrite(im, [imagesavefolder imageprefix num2str(index,'%03.0f') '.tif']);
    end
    
end