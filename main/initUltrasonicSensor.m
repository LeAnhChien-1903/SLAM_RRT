function [sensor1, sensor2] = initUltrasonicSensor(sim, clientID)
[~,sensor1]=sim.simxGetObjectHandle(clientID,'/ultrasonicSensor3',sim.simx_opmode_blocking);
[~,sensor2]=sim.simxGetObjectHandle(clientID,'/ultrasonicSensor4',sim.simx_opmode_blocking);
end