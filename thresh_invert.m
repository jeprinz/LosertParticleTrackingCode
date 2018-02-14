function im_stack_new = thresh_invert(im_stack)

%sets all pixels that are brighter that the 95th percentile to the same
%value and then inverts the image

thresholdLevel = .90;

edges = 0:2e-4:max(im_stack(:));
n = histc(im_stack(:),edges);
total_counts = sum(n);
accum = 0;
for i = 1:length(n)
    accum = accum + n(i);
    if (accum / total_counts) > thresholdLevel;
        thresh = edges(i);
        break;
    end
end

high_pixels = im_stack(:) > thresh;
im_stack(high_pixels) = thresh;

im_stack_new = max(max(max(im_stack)))-im_stack; %inverts