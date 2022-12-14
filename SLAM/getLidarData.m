function [erro, data] = getLidarData(clientID, sim)
%GETLIDARDATA Get data from LIDAR sensor
%   Gets a vector with the LIDAR data in format [x1 y1 z1 x2 y2 z2 ... xn yn zn] 
%   and convert it to polar form.
    [erro,signal] = sim.simxGetStringSignal(clientID,'lidarData',sim.simx_opmode_streaming);
    if(sim.simx_return_ok == erro)
        dataVec = double(sim.simxUnpackFloats(signal));
        dataMatrix = reshape(dataVec, 3, []);
        [theta, dist] = cart2pol(dataMatrix(1,:,:), dataMatrix(2,:,:));
        data = [dist; theta];
    else
        data = [];
    end
end