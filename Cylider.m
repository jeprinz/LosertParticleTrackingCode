%Makes a cylider at a random angle in center of box of size 2*radius
function out = Cylider(boundingRadius, cylRadius)

direction = [1 1 .5];
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