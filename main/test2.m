map = binary_map;
pose  = [0, 0, 0];
iter_max = computeInterations(map);
currentPoint = convertRealToPixel([pose(2), pose(1)], scale);
theta = pose(3);
[y_target, x_target] = RRT(currentPoint, map, iter_max);
disp(y_target)
% currentPoint = [200, 200];
% theta = 0;
% sampleTime = 0.05; dtkp = 0.4; deltaT = 2; scale = 20; delta = 10;
% [x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] =  createTrajectory(map, [0, 0, 0], sampleTime, dtkp, deltaT, scale, delta);
% figure(2)
% plot(x_ref, y_ref);
% figure(3)
% subplot(3, 1, 1);
% plot(t_ref, theta_ref, "r", LineWidth=2);
% subplot(3, 1, 2);
% plot(t_ref, v_ref, "g", LineWidth=2);
% subplot(3, 1, 3);
% plot(t_ref, omega_ref, "b", LineWidth=2);