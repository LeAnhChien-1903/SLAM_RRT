function binary_map = createBinaryMap(map)
new_map = 1 - occupancyMatrix(map);
binary_map = imbinarize(new_map);
end