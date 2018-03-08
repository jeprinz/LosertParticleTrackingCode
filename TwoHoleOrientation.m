%finds the orientation of the two holes in the bead. image is a 3d image
%array, center is [x y z] center of the sphere
%radius is the radius of the sphere
function out = TwoHoleOrientation(image, center, radius)

x = center(1);%store these for convenience
y = center(2);
z = center(3);

%create a mash which is a sphere with a smaller sphere cut out
[X, Y, Z] = meshgrid(-radius:radius, -radius:radius, -radius:radius);
mask = (X .^ 2 + Y .^ 2 + Z .^ 2) <= radius^2; %sph is a filled in sphere
mask = mask & (X.^2 + Y.^2 + Z.^2) >= (radius / 2)^2; %remove smaller sphere inside

sphereImage = image(x-radius:x+radius, y-radius:y+radius, z-radius:z+radius);

sections = ~sphereImage & mask;
jimage(sections);

CC = bwconncomp(sections); %label regions
S = regionprops(CC,'Centroid'); %find centroid of each region

if length(S) ~= 4 %If image processing went properly, we should have 4 regions
    out = false;
else
    
    direction = zeros(4,3);
    %We will flip vectors with negative X over origin, so they are all in half space in front of YZ plane. We can do this because two positions flipped
    %around origin correspond to same direction of hole.

    for i = [1 2 3 4]
        vector = S(i).Centroid - [radius+1 radius+1 radius+1];
        vector = vector ./ sqrt(sum(vector.^2)); %normalize
        direction(i,:) = vector;
        %if direction(i,1) <= radius
        %    direction(i,:) = 2*(radius + 1) - direction(i,:);
        %end
    end

    correspond = zeros(4,4);
    for i = [1 2 3 4]
        for j = [1 2 3 4]
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
