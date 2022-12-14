function [count] = checkIntersect(x_cur, map)

s = size(map);
height = s(1);
width = s(2);



window_height = [max(1, x_cur(1) - 8), min(height, x_cur(1) + 8)];
window_width = [max(1, x_cur(2) - 8), min(width, x_cur(2) + 8)];
count = 0;
for i = window_height(1) : window_height(2)
    for j = window_width(1): window_width(2)
        if map(i ,j) == 0
            count = count + 1;
               
        end 
    end
    
end
end