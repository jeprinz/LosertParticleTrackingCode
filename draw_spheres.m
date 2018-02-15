function out = draw_spheres(IMG, radius, locations)

sph = sphere(radius);

dim = size(IMG);
res = zeros(dim(1), dim(2), dim(3), 3);
res(:,:,:,1) = IMG;
res(:,:,:,2) = IMG;
res(:,:,:,3) = IMG;
redval = 1;

for i=1:size(locations,1)
   loc = locations(i,:);
   x = loc(1);
   y = loc(2);
   z = loc(3);
   lowx = min(radius, x);
   highx = min(radius, dim(1) - x);
   lowy = min(radius, y);
   highy = min(radius, dim(2) - y);
   lowz = min(radius, z);
   highz = min(radius, dim(3) - z);

   patch = max(IMG(x-lowx:x+highx, y-lowy:y+highy, z-lowz:z+highz), ...
       sph(radius+1-lowx:radius+1+highx, radius+1-lowy:radius+1+highy, radius+1-lowz:radius+1+highz)*redval);
   res(x-lowx:x+highx, y-lowy:y+highy, z-lowz:z+highz,1) = patch;
end

out = res;