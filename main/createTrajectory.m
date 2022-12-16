function [x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] =  createTrajectory(binary_map, pose, sampleTime, dtkp, deltaT, scale, delta)
iter_max = computeInterations(binary_map);
currentPoint = convertRealToPixel([pose(2), pose(1)], scale);
theta = pose(3);

[y_target, x_target] = RRT(currentPoint, binary_map, iter_max);
y_target = convertPixelToReal(y_target, delta, scale);
x_target = convertPixelToReal(x_target, delta, scale);
x_target = x_target + delta;
y_target = y_target + delta;
numOfPoints = length(x_target);
t = zeros(1, numOfPoints);
for i = 2:numOfPoints
    t(i) = t(i-1) + deltaT;
end
[x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] = findTrajectoryDiscrete(x_target, y_target, dtkp, t, theta, sampleTime);
end