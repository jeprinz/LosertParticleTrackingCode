%Makes a cylider at a random angle in center of box of size 2*radius
%boundingRadius is half the size of cube cylinder is embedded in (to correspond with the way the sphere.m works)
%direction is a 3-vector telling which way the cylinder should point from center of sphere

function out = Cylinder(boundingRadius, cylRadius, direction)

dirMagSqr = sqrt(sum(direction.^2));

unitDir = direction ./ dirMagSqr;



[X, Y, Z] = meshgrid(-boundingRadius:boundingRadius, -boundingRadius:boundingRadius, -boundingRadius:boundingRadius);
projection = X * unitDir(1) + Y * unitDir(2) + Z * unitDir(3);

distVec_x = X - projection * unitDir(1);
distVec_y = Y - projection * unitDir(2);
distVec_z = Z - projection * unitDir(3);

distSquared = distVec_x.^2 + distVec_y.^2 + distVec_z.^2;
cylinder = distSquared <= cylRadius^2;
                   
out = cylinder;