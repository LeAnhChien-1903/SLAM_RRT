function realCoor = convertPixelToReal(pixelCoordinate, delta, scale)
% Delta is the extra num
% Scale is to convert from m -> pixel example scale = 20 <=> 20 pixel = 1 m
realCoor = pixelCoordinate/scale - delta;
end