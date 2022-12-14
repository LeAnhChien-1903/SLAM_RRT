close all  % close all opening figure windows
clear % Clear all variables in workspace
clc
sim=remApi('remoteApi');
sim.simxFinish(-1);
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
    disp('Connected');
    [motorLeft, motorRight, center, original] = initRobot(sim, clientID);
    pose = initPose(sim, clientID, motorLeft, motorRight, center, original);
    % Parameter
    dtkp = 0.4;
    sampleTime = 0.05;
    deltaT = 3;
    delta = 10;
    scale = 20;
    maxRange = 20;
    map = occupancyMap(maxRange, maxRange, scale);
    while 1
        pose = getCurrentPose(sim, clientID, center, original);
        [erro, data] = getLidarData(clientID, sim);
        len = length(data);
        if len ~= 0
            ranges = data(1, :);
            angles = data(2, :);
            maxrange = 5;
            scan = lidarScan(ranges,angles);
            insertRay(map,pose,scan,maxrange);
            binary_map = createBinaryMap(map);
            [x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] =  createTrajectory(binary_map, pose, sampleTime, dtkp, deltaT, scale, delta);
            [x_real, y_real, theta_real, ex, ey, etheta, map] = controlRobot(sim, clientID, motorLeft, motorRight, center, original, map, x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, omega_ref);
            sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
            sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
            pause(0.05);
        end
    end
else
    disp('Failed connecting to remote API server');
end
sim.delete();% call the destructor!
disp('Program ended');