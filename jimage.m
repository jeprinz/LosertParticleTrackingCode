
function jimage(img, isColor)
img = squeeze(img);
if nargin < 2
    isColor = false;
end

if ~isColor

    s = size(img);

    if length(s) == 3
        layer = floor(s(3)/2);
        slice = img(:,:,layer);
    else
        slice = img;
    end

    high = max(max(slice));
    low = min(min(slice));

    fixed = (slice - low) ./ ((high - low)/255);
    image(fixed);
else
       s = size(img);

    if length(s) == 4
        layer = floor(s(3)/2);
        slice = img(:,:,layer,:);
    else
        slice = img;
    end

    high = max(max(max(slice)));
    low = min(min(min(slice)));
    
    slice = squeeze(slice);
    
    
    fixed = (slice - low) ./ ((high - low));
    image(fixed);
 
end

end
