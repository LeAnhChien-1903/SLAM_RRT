
function map = init_map()
    % free unnocuppied map
    map_x = 50;
    map_y = 50;
    for i = 1:map_x
        for j = 1:map_y
            map(i,j) = 0;
       end
    end
    
    % add obstacles
    for i = 10:25
        for j = 10:10
            map(i,j) = 1;
        end
    end

    for i = 25:25
        for j = 5:10
            map(i,j) = 1;
        end
    end
    
    for i = 10:10
        for j = 5:10
            map(i,j) = 1;
        end
    end
    
    for i = 30:45
        for j = 35:35
            map(i,j) = 1;
        end
    end
    
    for i = 30:45
        for j = 15:15
            map(i,j) = 1;
        end
    end
    
    % Walls bounding the map
    for i = 1:50
        for j = [1,50]
            map(i,j) = 1;
        end
    end
 
    % Walls bounding the map
    for i = [1,50]
        for j = 1:50
            map(i,j) = 1;
        end
    end
end
