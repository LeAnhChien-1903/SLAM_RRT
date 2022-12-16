close all  % close all opening figure windows
clear % Clear all variables in workspace
clc
sim=remApi('remoteApi');
sim.simxFinish(-1);
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5);
if (clientID>-1)
    disp('Connected');
    [motorLeft, motorRight, center, original] = initRobot(sim, clientID);
    [sensor1, sensor2] = initUltrasonicSensor(sim, clientID);
    for i = 1:2
        sim.simxSetJointTargetVelocity(clientID, motorLeft, 0.1, sim.simx_opmode_blocking);
        sim.simxSetJointTargetVelocity(clientID, motorRight, 0.1, sim.simx_opmode_blocking);
        pose = getCurrentPose(sim, clientID, center, -1);
        pause(0.01);
    end
    sim.simxSetJointTargetVelocity(clientID, motorLeft, 0, sim.simx_opmode_blocking);
    sim.simxSetJointTargetVelocity(clientID, motorRight, 0, sim.simx_opmode_blocking);
    while 1
        distance1 = readUltrasonicSensor(sim, clientID, sensor1);
        distance2 = readUltrasonicSensor(sim, clientID, sensor2);
        disp([distance1, distance2]);
    end

        %         figure(2)
        %         currentPosition = convertRealToPixel([x, y], 20);
        %         [h,w] = RRT(currentPosition, binary_map, 500);
        %         h_real = convertPixelToReal(h, 10, 20);
        %         w_real = convertPixelToReal(w, 10, 20);
        %         figure(1)
        %         hold on
        %         grid on
        %         plot(x, y, 'r.');
        %         x_real = [x_real, x];
        %         y_real = [y_real, y];
        %         theta_real = [theta_real, theta];
        %         ex = [ex,  x_ref(index) - x];
        %         ey = [ey,  y_ref(index) - y];
        %         etheta = [etheta,  theta_ref(index) - theta];
        %         n = [n, index];
        %         [wL, wR] = PV_OffcenterControl(x_ref(index), y_ref(index), theta_ref(index), x_ref_dot(index), y_ref_dot(index), omega_ref(index), x, y, theta, r, b, e, Kp);
        %         if isnan(wL)
        %             wL = 0;
        %         end
        %         if isnan(wR)
        %             wR = 0;
        %         end
        %         if wL > 1
        %             wL = 1;
        %         elseif wL < -1
        %             wL = -1;
        %         end
        %         if wR > 1
        %             wR = 1;
        %         elseif wR < -1
        %             wR = -1;
        %         end
        %         sim.simxSetJointTargetVelocity(clientID, motorLeft, wL, sim.simx_opmode_blocking);
        %         sim.simxSetJointTargetVelocity(clientID, motorRight, wR, sim.simx_opmode_blocking);
        %         disp([wL, wR]);
        %         index = index + 1;
        %         pause(0.05)
%         if index > length(x_ref)
%             break;
%         end
%     end
    %     new_map = 1 - occupancyMatrix(map);
    %     imwrite(new_map, 'map.png')
    %     figure(2)
    %     subplot(3, 1, 1)
    %     hold on
    %     grid on
    %     plot(n, ex, 'r.')
    %     subplot(3, 1, 2)
    %     hold on
    %     grid on
    %     plot(n, ey, 'b.')
    %     subplot(3, 1, 3)
    %     hold on
    %     grid on
    %     plot(n, etheta, 'g.')
else
    disp('Failed connecting to remote API server');
end
sim.delete();% call the destructor!
disp('Program ended');