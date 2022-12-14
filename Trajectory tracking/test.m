clc;
clear;
close all;
%% Data
x_new = -2.3445;
y_new = -1.025;
x = [3.7305, 4.0105, 4.1052, 4.2475, 3.625, 1.7775,-5.8024e-01, -2.0105, -4.3299, -4.2855,-4.2802, -4.3975,-4.1500, -1.6275, 6.5524e-01, 2.2855,3.7305];
y = [-3.475, -2.2025, -2.4476e-01, 1.9855, 4.0799, 4.3355, 4.3052, 4.2975, 4.1500,1.9775, -3.5524e-01, -2.4355, -4.0049, -4.0855, -4.0552, -4.1225, -3.475];
t = zeros(1,length(x));
dtkp = 0.4;
deltaT = 0.01;
for i = 2:length(x)
    t(i) = t(i-1) + 10;
end
%% Plot data
[x_trajectory, y_trajectory, theta, x_ref_dot, y_ref_dot, velocity, omega, t_trajectory] = findTrajectoryDiscrete(x, y, dtkp, t, pi/2, deltaT);
theta_dot = zeros(1, length(theta));
for i = 2:length(theta)
    theta_dot(i) = (theta(i) - theta(i-1)) / (t_trajectory(i) - t_trajectory(i-1));
end

figure(1)
hold on
grid on
plot(x, y, 'gs', LineWidth=2)
plot(x_trajectory, y_trajectory, "r", LineWidth=2)
title("Tracjectory")
ylabel("Y(m)")
xlabel("X(m)")
figure(2)
subplot(3, 1, 1);
hold on
grid on
plot(t_trajectory, velocity, "r", LineWidth=2)
title("Velocity");
ylabel("m/s")
xlabel("Time(s)");
subplot(3, 1, 2);
hold on
grid on
plot(t_trajectory, theta, "k", LineWidth=2)
title("Theta");
xlabel("Time(s)");
ylabel("rad");
subplot(3, 1, 3);
hold on
grid on
plot(t_trajectory, omega, "m", LineWidth=2)
title("Omega");
xlabel("Time(s)");
ylabel("rad/s");
figure(3)
subplot(2, 1, 1);
hold on
grid on
plot(t_trajectory, x_trajectory, "r", LineWidth=2)
title("Trajectory in axis X");
ylabel("m")
xlabel("Time(s)");
subplot(2, 1, 2);
hold on
grid on
plot(t_trajectory, y_trajectory, "b", LineWidth=2)
title("Trajectory in axis Y");
ylabel("m")
xlabel("Time(s)");