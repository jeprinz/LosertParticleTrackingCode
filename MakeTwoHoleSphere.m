function out = MakeTwoHoleSphere(radius)

[X, Y, Z] = meshgrid(-radius:radius, -radius:radius, -radius:radius);
sph = (X .^ 2 + Y .^ 2 + Z .^ 2) <= radius^2; %sph is a filled in sphere
cyl1 = Cylinder(radius, radius * .2, [1 1 1]);
cyl2 = Cylinder(radius, radius * .2, [1 0 0]);

result = sph & ~cyl1 & ~cyl2;

out = result;