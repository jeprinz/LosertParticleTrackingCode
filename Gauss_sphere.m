%Create an array (3D) with a Gaussian sphere
%Use at you own risk
%Joost Weijs, 2008

function out = Gauss_sphere(radius,sigma0,AR_z);

kx=round(2.5*radius);%these are the matrix dimesions of the box that contains the kernel
ky=round(2.5*radius);
kz=round(2.5*radius/AR_z);%AR_z=1 currently

Gauss_sph=zeros(kx,ky,kz);

for i=1:kx
    for j=1:ky
        for k=1:kz

            r = sqrt( (kx/2 - i)^2 + (ky/2 - j)^2 + (AR_z*(kz/2 - k))^2 );
            Gauss_sph(i,j,k)= -2*(r-radius)/(2*sigma0^2) * exp(-(r-radius)^2/(2*sigma0^2));
        
        end %for k
    end %for j
end %for i

out=Gauss_sph;