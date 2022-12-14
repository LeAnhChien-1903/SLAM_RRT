function [t_trajectory, trajectory] = findLinearAndParabolicTrajectory(x, t, deltaT, dtkp)
dx = zeros(length(x));
for i = 2:length(x)
    dx(i) = ( x(i) - x(i-1) ) / ( t(i) - t(i-1) );
end
%% Trajectory data
trajectory = [];
t_trajectory = [];
%% Compute trajectory
for i = 1:length(x)-1
    b0 = x(i) + (dx(i+1)-dx(i))*dtkp/8;
    b1 = (dx(i+1)+dx(i))/2;
    b2 = (dx(i+1)-dx(i))/(2*dtkp);
    if i == 1
        tx = t(1):deltaT:t(1)+dtkp/2;
    else
        tx = t(i) - dtkp/2:deltaT: t(i) + dtkp/2;
    end
    coeff_para_0 = b2*t(i)^2 - b1*t(i) + b0;
    coeff_para_1 = -2 * b2 * t(i) + b1;
    coeff_para_2 = b2;
    parabol = coeff_para_2*tx.^2 + coeff_para_1*tx + coeff_para_0;
    t_trajectory = [t_trajectory, tx];
    trajectory = [trajectory, parabol];
    a0 = x(i);
    a1 = dx(i+1);
    tx = t(i)+dtkp/2 + deltaT:deltaT:t(i+1) - dtkp/2;
    coeff_linear_0 = -a1*t(i)+a0;
    coeff_linear_1 = a1;
    linear_x = coeff_linear_1*tx + coeff_linear_0;
    t_trajectory = [t_trajectory, tx];
    trajectory = [trajectory, linear_x];
end
% Parabol tai tf
length_x = length(x);
bf_0 = x(length_x) + (dx(length_x+1) - dx(length_x))*dtkp/8;
bf_1 = (dx(length_x+1) + dx(length_x))/2;
bf_2 = (dx(length_x+1) - dx(length_x))/(2*dtkp);
tx = t(length_x) - dtkp/2 + deltaT:deltaT: t(length_x);
parabol_fx = bf_2*(tx-t(length_x)).^2 + bf_1*(tx-t(length_x)) + bf_0;
t_trajectory = [t_trajectory, tx];
trajectory = [trajectory, parabol_fx];
end
