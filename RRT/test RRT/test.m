clc;clear;close all;

% map = init_map();
% imagesc(map);
% set(gca,'YDir','normal');
% 
% x_cur = [5,5];
% [h,w] = RRT(x_cur, map);

img = imread("img_test.png");
binary_img = imbinarize(img);

imshow(binary_img);

x_cur = [11,11];
[h,w] = new_RRT(x_cur, binary_img); 
figure;
plot(w,h);