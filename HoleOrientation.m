%finds the orientation of the two holes in the bead. image is a 3d image
%array, center is [x y z] center of the sphere
%radius is the radius of the sphere
function out = HoleOrientation(image, center, radius, numHoles)

numPieces = numHoles * 2;

x = round(center(1));%store these for convenience
y = round(center(2));
z = round(center(3));% TODO: think about subpixel, so dont have to round
radius = round(radius);

imgSize = size(image);

padding = radius + 1;
width = 2*radius+1;

%create a mash which is a sphere with a smaller sphere cut out
[X, Y, Z] = meshgrid(-radius:radius, -radius:radius, -radius:radius);
mask = (X .^ 2 + Y .^ 2 + Z .^ 2) <= (radius * .8)^2; %sph is a filled in sphere
mask = mask & (X.^2 + Y.^2 + Z.^2) >= (radius / 2)^2; %remove smaller sphere inside

%sphereImage = image(x-radius:x+radius, y-radius:y+radius, z-radius:z+radius);

sphereImage = zeros(width, width, width);
lowx = min(radius, x - 1);
highx = min(radius, imgSize(1) - x - 1);
lowy = min(radius, y - 1);
highy = min(radius, imgSize(2) - y - 1);
lowz = min(radius, z - 1);
highz = min(radius, imgSize(3) - z - 1);
patch = image(x-lowx:x+highx, y-lowy:y+highy, z-lowz:z+highz);
sphereImage(radius+1-lowx:width-radius+highx, radius+1-lowy:width-radius+highy, radius+1-lowz:width-radius+highz) = patch;


sections = sphereImage & mask;

CC = bwconncomp(sections); %label regions
S = regionprops(CC,'Centroid','Area'); %find centroid of each region
bigRegions = [S.Area] > 5; % keep only relatively big areas
GoodRegions = S(bigRegions);


if x < 50 && z > 30 && numPieces ~= length(GoodRegions)
    disp('here it is');
end

if length(S) ~= numPieces %If image processing went properly, we should have 4 regions
    out = false;
else
    
    direction = zeros(numPieces,3);
    %We will flip vectors with negative X over origin, so they are all in half space in front of YZ plane. We can do this because two positions flipped
    %around origin correspond to same direction of hole.

    for i = 1:numPieces
        vector = S(i).Centroid - [radius+1 radius+1 radius+1];
        vector = vector ./ sqrt(sum(vector.^2)); %normalize
        direction(i,:) = vector;
        %if direction(i,1) <= radius
        %    direction(i,:) = 2*(radius + 1) - direction(i,:);
        %end
    end

    correspond = zeros(numPieces, numPieces);
    for i = 1:numPieces
        for j = numPieces
            correspond(i,j) = sum(direction(i,:) .* direction(j,:)); %dot product of ith and jth vector
        end
    end
    
    THRESHOLD = 0.1; %out of 1, how closely should things be measured
    
    findOpposites = correspond < (-1 + THRESHOLD);

    out = direction;

end

%takes in a matrix. The (i,j) element of the matrix represents the 
%correspondence of object i with object j. If that correspondence is
%1,then will merge the two columns and objects.
function out = combine(objects, matrix)


out = 0
