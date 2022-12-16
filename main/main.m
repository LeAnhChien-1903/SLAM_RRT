close all  % close all opening figure windows
clear % Clear all variables in workspace
clc
sim=remApi('remoteApi');
sim.simxFinish(-1);
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
    disp('Connected');
    [motorLeft, motorRight, center, original] = initRobot(sim, clientID);
    pose = initPose(sim, clientID, motorLeft, motorRight, center, -1);
    % Parameter
    dtkp = 0.4;
    sampleTime = 0.05;
    deltaT = 2;
    delta = 10;
    scale = 20;
    maxRange = 20;
    map = occupancyMap(maxRange, maxRange, scale);
    n = 0;
    ex_data = [];
    ey_data = [];
    etheta_data = [];
    v_data = [];
    omega_data = [];
    while 1
        for num = 1:20
            pose = getCurrentPose(sim, clientID, center, -1);
            [erro, data] = getLidarData(clientID, sim);
            len = length(data);
            if len ~= 0
                ranges = data(1, :);
                angles = data(2, :);
                maxrange = 5;
                scan = lidarScan(ranges,angles);
                insertRay(map,pose,scan,maxrange);
                binary_map = createBinaryMap(map);
                figure(1)
                [x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, v_ref, omega_ref, t_ref] =  createTrajectory(binary_map, pose, sampleTime, dtkp, deltaT, scale, delta);
                [x_real, y_real, theta_real, ex, ey, etheta, map] = controlRobot(sim, clientID, motorLeft, motorRight, center, -1, map, x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, omega_ref);
                sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
                sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
%                 figure(2)
%                 index = 1:length(x_real);
%                 index = index + n;
%                 n = n + length(x_real);
                ex_data = [ex_data, ex];
                ey_data = [ey_data, ey];
                etheta_data = [etheta_data, etheta];
                v_data = [v_data, v_ref];
                omega_data = [omega_data, omega_ref];
%                 subplot(3, 1, 1)
%                 hold on
%                 grid on
%                 plot(index, ex, 'r')
%                 title("Error X");
%                 subplot(3, 1, 2)
%                 hold on
%                 grid on
%                 plot(index, ey, 'g')
%                 title("Error Y");
%                 subplot(3, 1, 3)
%                 hold on
%                 grid on
%                 plot(index, etheta, 'b')
%                 title("Error Theta");
            end
        end
    end
else
    disp('Failed connecting to remote API server');
end
sim.delete();% call the destructor!
disp('Program ended');