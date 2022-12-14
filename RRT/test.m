clc;clear;close all;

% map = init_map();
% imagesc(map);
% set(gca,'YDir','normal');
% 
% x_cur = [5,5];
% [h,w] = RRT(x_cur, map);

img = imread("map_full.png");
binary_img = imbinarize(img);

imshow(binary_img);
figure(1)
x_cur = [134,274];
x_real = convertPixelToReal(x_cur, 10, 20);
disp(x_real)
[h,w] = RRT(x_cur, binary_img, 500);
h_real = convertPixelToReal(h, 10, 20);
w_real = convertPixelToReal(w, 10, 20);
figure(2)
plot(w_real, h_real);