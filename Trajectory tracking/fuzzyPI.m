function [response, sum, prev] = fuzzyPI(error, sumerror, preverror, kp, ki, deltaT)
changeInError = (error - preverror) / deltaT;
if changeInError > 5
    changeInError = 5;
end
if changeInError < -5
    changeInError = -5;
end
if error > 5
    error = 5;
end
if error < -5
    error = -5;
end
[deltaKp, deltaKi] = fuzzyLogic(error, changeInError);
kp = kp + deltaKp;
ki = ki + deltaKi;
P = kp*error;
sumerror = sumerror + ki*(error + preverror)/2;
I = sumerror;
response= P + I;
sum = sumerror;
prev = preverror;
end