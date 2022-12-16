function result = convertTheta(theta)
result = mod(theta, 2*pi);
if (result > pi)
   result = result -2*pi;
end
if result < -pi
    result = 2*pi + result;
end
end
