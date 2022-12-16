function distance = readUltrasonicSensor(sim, clientID, sensor)
[~,detectionState,distanceArray,~,~]=sim.simxReadProximitySensor(clientID,sensor,sim.simx_opmode_streaming);
if detectionState > 0
    distance = distanceArray(3);
else
    distance = 2.5;
end