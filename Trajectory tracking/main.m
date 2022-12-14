close all  % close all opening figure windows
clear % Clear all variables in workspace
clc
sim=remApi('remoteApi');
sim.simxFinish(-1);
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
dataFinal = [];
if (clientID>-1)
    disp('Connected');
    [~,Robot] = sim.simxGetObjectHandle(clientID,'Robot',sim.simx_opmode_blocking );
    [~, motorLeft] = sim.simxGetObjectHandle(clientID,'/leftMotor',sim.simx_opmode_blocking );
    [~, motorRight] = sim.simxGetObjectHandle(clientID,'/rightMotor',sim.simx_opmode_blocking);
    [~, center] = sim.simxGetObjectHandle(clientID,'/center',sim.simx_opmode_blocking);
    [~, original] = sim.simxGetObjectHandle(clientID,'/original',sim.simx_opmode_blocking);
    for i = 1:2
        sim.simxSetJointTargetVelocity(clientID, motorLeft, 0.1, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity(clientID, motorRight, 0.1, sim.simx_opmode_blocking);
        [x, y, theta] = getCurrentPose(sim, clientID, center, -1);
        pause(0.01);
    end
    sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
    sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
    x_target = [3.7305, 4.0105, 4.1052, 4.2475, 3.625, 1.7775,-5.8024e-01, -2.0105, -4.3299, -4.2855,-4.2802, -4.3975,-4.1500, -1.6275, 6.5524e-01, 2.2855, 3.7305];
    y_target = [-3.475, -2.2025, -2.4476e-01, 1.9855, 4.0799, 4.3355, 4.3052, 4.2975, 4.1500,1.9775, -3.5524e-01, -2.4355, -4.0049, -4.0855, -4.0552, -4.1225, -3.475];
    t = zeros(1,length(x_target));
    dtkp = 0.4;
    deltaT = 0.05;
    for i = 2:length(x_target)
        t(i) = t(i-1) + 10;
    end
    % Reference trajectory
    [x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] = findTrajectoryDiscrete(x_target, y_target, dtkp, t, theta, deltaT);
    figure(1)
    hold on
    grid on
    plot(x_ref, y_ref, 'g', LineWidth=2);
    index = 1;
    b = 0.1655;
    r = 0.1955/2;
    e = 0.2;
    Kp = 1;
    disp([x, y, theta])
    x_real = [];
    y_real = [];
    theta_real = [];
    ex = [];
    ey = [];
    etheta = [];
    n = [];
    while 1
        figure(1)
        hold on
        grid on
        plot(x, y, 'r.');
        x_real = [x_real, x];
        y_real = [y_real, y];
        theta_real = [theta_real, theta];
        ex = [ex,  x_ref(index) - x];
        ey = [ey,  y_ref(index) - y];
        etheta = [etheta,  theta_ref(index) - theta];
        n = [n, index];
        [wL, wR] = PV_OffcenterControl(x_ref(index), y_ref(index), theta_ref(index), x_ref_dot(index), y_ref_dot(index), omega_ref(index), x, y, theta, r, b, e, Kp);
        if isnan(wL)
            wL = 0;
        end
        if isnan(wR)
            wR = 0;
        end
        if wL > 1
            wL = 1;
        elseif wL < -1
            wL = -1;
        end
        if wR > 1
            wR = 1;
        elseif wR < -1
            wR = -1;
        end
        sim.simxSetJointTargetVelocity(clientID, motorLeft, wL, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity(clientID, motorRight, wR, sim.simx_opmode_blocking);
        disp([wL, wR]);
        [x, y, theta] = getCurrentPose(sim, clientID, center, -1);
        index = index + 1;
        pause(0.05)
        if index > length(x_ref)
            break;
        end
    end
    figure(2)
    subplot(3, 1, 1)
    hold on
    grid on
    plot(n, ex, 'r.')
    subplot(3, 1, 2)
    hold on
    grid on
    plot(n, ey, 'b.')
    subplot(3, 1, 3)
    hold on
    grid on
    plot(n, etheta, 'g.')
else
    disp('Failed connecting to remote API server');
end
sim.delete();% call the destructor!
disp('Program ended');