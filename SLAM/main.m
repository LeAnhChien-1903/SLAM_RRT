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
    map = binaryOccupancyMap(10,10,20);
    for i = 1:2
        sim.simxSetJointTargetVelocity(clientID, motorLeft, 0.1, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity(clientID, motorRight, 0.1, sim.simx_opmode_blocking);
        pose = getCurrentPose(sim, clientID, center, -1);
        pause(0.01);
    end
    sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
    sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
    while 1
        pose = getCurrentPose(sim, clientID, center, -1);
        disp(pose)
        [erro, data] = getLidarData(clientID, sim);
        len = length(data);
        if len ~= 0
            ranges = data(1, :);
            angles = data(2, :);
            maxrange = 5;
            scan = lidarScan(ranges,angles);
            insertRay(map,pose,scan,maxrange);
            show(map)
            break;
        end
    end
else
    disp('Failed connecting to remote API server');
end
sim.delete();% call the destructor!
disp('Program ended');