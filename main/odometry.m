function pose = odometry(sim, clientID, motorLeft, motorRight, prevPose, deltaT)
r = 0.1955/2;
d = 0.1655 * 2;
wL = sim.simxGetObjectFloatParameter(clientID, motorLeft, sim.jointfloatparam_velocity, sim.simx_opmode_streaming);
wR = sim.simxGetObjectFloatParameter(clientID, motorRight, sim.jointfloatparam_velocity, sim.simx_opmode_streaming);
v = r*(wL + wR)/2;
deltaK = r*(wR - wL)*deltaT/d;
x_new = prevPose(1) + v*deltaT*cos(theta);
y_new = prevPose(2) + v*deltaT*sin(theta);
theta_new = convertTheta(prevPose(3) + deltaK);
pose = [x_new, y_new, theta_new];
end