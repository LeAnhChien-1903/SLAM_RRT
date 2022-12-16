function numOfInters = computeInterations(binary_map)
% binary = imbinarize(map);
numWhitePixels = sum(binary_map(:));
numOfInters = ceil(numWhitePixels * 2000 / 30000);
end