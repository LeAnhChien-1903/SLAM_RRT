function [height, width] = RRT(pose, map, iter_max)

s= size(map);
height_map = s(1);
width_map = s(2);

% chuyển đổi gốc tọa độ của ảnh sang gốc tọa độ của toàn cục
pose(1) = height_map - pose(1) ;
theta = pose(3);
% lưu giá trị của lần lượt của các node
height_value = [pose(1)];
width_value = [pose(2)];

%
imshow(map);
hold on;

%% RRT ALGORITHM
% initialize graph tree
node_index = 1;
source_node = [node_index];
target_node = [];
nodes_height(node_index) = pose(1);
nodes_width(node_index) = pose(2);
rrt_graph = graph(source_node,target_node);
rrt_plot = plot(rrt_graph, 'w','XData', nodes_width, 'YData', nodes_height,'NodeLabel',{});

iterations = 1;
% check stopping condition
while 1
    iterations = iterations + 1;
    if iterations == iter_max
        break
    end
    % select direction state
    x_rand = [randi([1, height_map]), randi([1,width_map])];

    % select nearest neighbor to this current random state ('seuclidean', 'minkowski', or 'mahalanobis')
    for node = 1:node_index
        neighbors(node) = pdist([nodes_height(node),nodes_width(node);x_rand(1),x_rand(2)],'euclidean');
    end

    [dist, nearest_node] = min(neighbors);
    % state of the nearest neighbor
    x_near = [nodes_height(nearest_node), nodes_width(nearest_node)];

    % move towards x_rand position
    delta = move(x_near,x_rand); % khoảng tiến của mỗi node
    pose = x_near + delta;
    if delta < 0
        pose = [max(1, pose(1)), max(1, pose(2))];
    elseif delta > 0
        pose = [min(height_map, pose(1)), min(width_map, pose(2))];
    end
    % kiểm tra xem có vật cản ở đấy không
    if checkIntersect(pose,map) < 10
        % check if the node already exists
        exists_node = false;
        for i=1:node_index
            if pose(1) == nodes_height(node) && pose(2) == nodes_width(node)
                exists_node = true;
                break
            end
        end
        if exists_node == false
            % vẽ node
            %             hold on;
            %             scatter(x_cur(2), x_cur(1), 10, "red","filled");

            % add current state as a node to the graph tree
            node_index = node_index + 1;
            rrt_graph = addnode(rrt_graph,1);
            rrt_graph = addedge(rrt_graph,nearest_node,node_index);
            nodes_height(node_index) = pose(1);
            nodes_width(node_index) = pose(2);
            height_value = [height_value, pose(1)];
            width_value = [width_value, pose(2)];

        end
    end
    delete(rrt_plot)
    rrt_plot = plot(rrt_graph, 'r','XData', nodes_width, 'YData', nodes_height,'NodeLabel',{}, 'LineWidth', 2, 'MarkerSize', 1);
    grid on
    pbaspect([1 1 1])
    xlim([1 height_map])
    ylim([1 width_map])
end
hold off

%% dùng A* để tìm đường đi ngắn nhất giữa 2 node
spath = shortestpath(rrt_graph,1,randi([3, node_index]));
highlight(rrt_plot,spath,'NodeColor','g','EdgeColor','g');

%% tọa độ lần lượt chiều cao và chiều dài của ảnh mà robot cần di chuyển lượt tiếp theo
h = [];
w = [];
for i = spath
    h = [h, height_value(i)];
    w = [w, width_value(i)];
end
% chuyển về theo gốc tọa độ toàn cục
h = height_map - h;
height = h;
width = w;
angle = computeAngle([w(1), h(1)], [w(2), h(2)]);
min_diff = computeDifference(angle, theta);
for k = 1:5
    spath = shortestpath(rrt_graph,1,randi([3, node_index]));
    highlight(rrt_plot,spath,'NodeColor','g','EdgeColor','g');

    %% tọa độ lần lượt chiều cao và chiều dài của ảnh mà robot cần di chuyển lượt tiếp theo
    h = [];
    w = [];
    for i = spath
        h = [h, height_value(i)];
        w = [w, width_value(i)];
    end
    % chuyển về theo gốc tọa độ toàn cục
    h = height_map - h;
    angle = computeAngle([w(1), h(1)], [w(2), h(2)]);
    diff = computeDifference(angle, theta);
    if diff < min_diff
        min_diff = diff;
        height = h;
        width = w;
    end
end
end