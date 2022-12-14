function [x_trajectory, y_trajectory, theta, v_x, v_y, v, omega, t_trajectory] = findTrajectoryDiscrete(x, y, dtkp, t, theta_init, sampleTime)
[t_trajectory, x_trajectory] = findLinearAndParabolicTrajectory(x, t, sampleTime, dtkp);
[~, y_trajectory] = findLinearAndParabolicTrajectory(y, t, sampleTime, dtkp);
len = length(t_trajectory);
v = zeros(1, len);
theta = zeros(1, len);
theta(1) = theta_init;
omega = zeros(1, len);
v_x = zeros(1, len);
v_y = zeros(1, len);
a_x = zeros(1, len);
a_y= zeros(1, len);
for i = 2:len
    v_x(i) = (x_trajectory(i) - x_trajectory(i-1)) / (t_trajectory(i) - t_trajectory(i-1));
    v_y(i) = (y_trajectory(i) - y_trajectory(i-1)) / (t_trajectory(i) - t_trajectory(i-1));
    a_x(i) = (v_x(i) - v_x(i-1) ) / (t_trajectory(i) - t_trajectory(i-1));
    a_y(i) = (v_y(i) - v_y(i-1) ) / (t_trajectory(i) - t_trajectory(i-1));
    v(i) = sqrt(v_x(i)^2 + v_y(i)^2);
    theta(i) = atan2(v_y(i),v_x(i));
    omega(i) = (v_x(i)*a_y(i) - v_y(i)*a_x(i)) / (sqrt(v_x(i)^2 + v_y(i)^2) );
end
end