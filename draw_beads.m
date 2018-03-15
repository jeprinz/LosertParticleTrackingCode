%locations is 7 column matrix, where first 3 are bead locations, the fourth column is a binary
%value "should I draw a cylider for this bead" and last three are cylider direction vector
function out = draw_beads(IMG, radius, locations)

sph = sphere(radius);

dim = size(IMG);
res = zeros(dim(1), dim(2), dim(3), 3);
res(:,:,:,1) = IMG;
res(:,:,:,2) = IMG;
res(:,:,:,3) = IMG;
redval = max(mean(mean(mean(IMG)))*2,1);

for i=1:size(locations,1)
   loc = locations(i,:);
   x = floor(loc(1));
   y = floor(loc(2));
   z = floor(loc(3));
   lowx = min(radius, x - 1);
   highx = min(radius, dim(1) - x - 1);
   lowy = min(radius, y - 1);
   highy = min(radius, dim(2) - y - 1);
   lowz = min(radius, z - 1);
   highz = min(radius, dim(3) - z - 1);
   patch = max(res(x-lowx+1:x+highx+1, y-lowy+1:y+highy+1, z-lowz+1:z+highz+1,1), ...
       sph(radius+1-lowx:radius+1+highx, radius+1-lowy:radius+1+highy, radius+1-lowz:radius+1+highz)*redval);
   res(x-lowx+1:x+highx+1, y-lowy+1:y+highy+1, z-lowz+1:z+highz+1,1) = patch;
end

out = res;