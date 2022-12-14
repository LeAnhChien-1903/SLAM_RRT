function [x_real, y_real, theta_real, ex, ey, etheta, map] = controlRobot(sim, clientID, motorLeft, motorRight, center, original, map, x_ref, y_ref, theta_ref, x_ref_dot, y_ref_dot, omega_ref)
b = 0.1655;
r = 0.1955/2;
d = 0.2;
Kp = 1;
x_real = [];
y_real = [];
theta_real = [];
ex = [];
ey = [];
etheta = [];
n = [];
index = 1;
numOfSample = length(x_ref);
while 1
    pose = getCurrentPose(sim, clientID, center, original);
    [~, data] = getLidarData(clientID, sim);
    len = length(data);
    if len ~= 0
        ranges = data(1, :);
        angles = data(2, :);
        maxrange = 5;
        scan = lidarScan(ranges,angles);
        insertRay(map,pose,scan,maxrange);
        x = pose(1);
        y = pose(2);
        theta = pose(3);
        x_real = [x_real, x];
        y_real = [y_real, y];
        theta_real = [theta_real, theta];
        ex = [ex,  x_ref(index) - x];
        ey = [ey,  y_ref(index) - y];
        etheta = [etheta,  theta_ref(index) - theta];
        n = [n, index];
        [wL, wR] = PV_OffcenterControl(x_ref(index), y_ref(index), theta_ref(index), x_ref_dot(index), y_ref_dot(index), omega_ref(index), x, y, theta, r, b, d, Kp);
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
        index = index + 1;
        pause(0.05)
        if index > numOfSample
            disp("Continue next step!");
            break;
        end
    else
        sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
    end
end
end