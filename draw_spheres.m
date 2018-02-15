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
   patch = max(IMG(x-radius:x+radius, y-radius:y+radius, z-radius:z+radius), sph*redval);
   res(x-radius:x+radius, y-radius:y+radius, z-radius:z+radius,1) = patch;
end

out = res;