function [difference] = computeDifference(angleStart, angleEnd)
if angleStart >= 0 && angleEnd >= 0
    difference = abs(angleStart - angleEnd);
elseif angleStart <= 0 && angleEnd <= 0
    difference = abs(angleStart - angleEnd);
elseif angleStart >= 0 && angleEnd <= 0
    result1 = pi - angleStart + pi + angleEnd;
    result2 =  angleStart - angleEnd;
    if result1 < result2
        difference = result1;
    else
        difference = result2;
    end
elseif angleStart <= 0 && angleEnd >= 0
    result1 = 2*pi - angleEnd + angleStart;
    result2 = angleEnd - angleStart;
     if result1 < result2
        difference = result1;
    else
        difference = result2;
     end   
end
end