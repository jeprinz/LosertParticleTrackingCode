
function jimage(img)

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

end
