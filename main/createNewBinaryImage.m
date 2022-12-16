function binary_img = createNewBinaryImage(binary_img, currentPoints, scale)
pose = [currentPoints(1), currentPoints(2), currentPoints(3)];
k = tan(currentPoints(3) - pi/2);
s = size(binary_img);
height = s(1);
width = s(2);
pose_pixel = convertRealToPixel([pose(1), pose(2)], scale);
if pose(3) >= -pi/2 && pose(3) <= pi/2
    pose_pixel = pose_pixel - 2;
else
    pose_pixel = pose_pixel + 2;
end
if pose(3) >= 0 && pose(3)  <= pi/2
    pose_pixel_new = [round(pose_pixel(1) + 3*cos(pose(3))), round(pose_pixel(2) + 3*sin(pose(3)))];
elseif pose(3) >= -pi/2 && pose(3) < 0
    pose_pixel_new = [round(pose_pixel(1) + 3*cos(pose(3))), round(pose_pixel(2) - 3*sin(pose(3)))];
elseif pose(3) < -pi/2 && pose(3) > -pi
    pose_pixel_new = [round(pose_pixel(1) - 3*cos(pose(3))), round(pose_pixel(2) + 3*sin(pose(3)))];
else
    pose_pixel_new = [round(pose_pixel(1) - 3*cos(pose(3))), round(pose_pixel(2) - 3*sin(pose(3)))];
end
if pose_pixel_new(2) - k*(pose_pixel_new(1) - pose_pixel(1)) - pose_pixel(2) > 0
    condition = 1;
else
    condition = 0;
end
if condition == 1
    for x = 1:width
        for y= 1:height
            if y - k*(x - pose_pixel(1)) - pose_pixel(2) < 0
                binary_img(y, x) = 0;
            end
        end
    end
else
    for x = 1:width
        for y= 1:height
            if y - k*(x - pose_pixel(1)) - pose_pixel(2) > 0
                binary_img(y, x) = 0;
            end
        end
    end
end
end