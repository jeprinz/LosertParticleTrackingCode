function out = sphere(radius)

[X, Y, Z] = meshgrid(-radius:radius, -radius:radius, -radius:radius);
sph = (X .^ 2 + Y .^ 2 + Z .^ 2) <= radius^2; %sph is a filled in sphere
                   
out = onlyTheSurface(sph);