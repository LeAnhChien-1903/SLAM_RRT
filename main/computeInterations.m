function numOfInters = computeInterations(binary_map)
% binary = imbinarize(map);
numWhitePixels = sum(binary_map(:));
numOfInters = ceil(numWhitePixels * 1000 / 30000);
end