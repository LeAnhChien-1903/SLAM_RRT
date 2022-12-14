clc;
clear;
close all;
map = imread("map.png", "png");
map = imbinarize(map);
disp(size(map))
imshow(map)