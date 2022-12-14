classdef Sensor < handle
    properties
        % Sensor properties
        range           % Range of laser sensor (metres)
        range_min       % Minimum distance of sensor reading
        fov             % Angle over which sensor operates (field of view)
        noise           % Measurement noise (range and bearing)
        angular_res     % Angular resolution (separation between readings)
    end
    
    methods
        
        function sen = Sensor                       % Constructor method
            % Default values based on Hokuyo URG-04LX-UG01 datasheet 
            % (website info is different and probably wrong!)
            % The number 684 is the number of points from V-REP sensor.
            sen.range       =   4.095;
            sen.range_min   =   0.06;
            sen.fov         =   240 * pi/180;
            sen.noise       =   [0.01; 0.01];   % 1%, 1%
            sen.angular_res =   (240.0/684.0) * pi/180.0;         % 0.351 degree
        end
        
        % Find all measurements that are out of the sensor's range and set
        % them to an impossible value so that they can be removed
        function [y, idx] = constrainMeasurement(sen, y)
            off_range = y(1, :) > sen.range | y(1, :) < sen.range_min;
            off_ang = y(2, :) > sen.fov/2 | ...
                y(2, :) < -sen.fov/2;
            y(:, off_range) = inf;
            y(:, off_ang) = inf;
            idx = find(y(1, :) < inf | y(2, :) < inf);
        end
        
        % Generate a scan where the full sweep gives the max range value
        function y = generateEmptyScan(sen)
            readings_a = -sen.fov/2 : sen.angular_res : sen.fov/2;
            numLasers = length(readings_a);
            y = [repmat(sen.range, 1, numLasers); readings_a];
        end

    end
end