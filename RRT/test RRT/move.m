function delta = move(source,target)
    angle = find_orientation(source,target);
    delta(1) = sin(angle);
    delta(2) = cos(angle);
    for i = 1:2
        if 0 < delta(i) && delta(i) < 0.3535
            delta(i) = 0;
        elseif 0.3535 <= delta(i) && delta(i) < 1
            delta(i) = 10;
        elseif -0.3535 < delta(i) && delta(i) < 0
            delta(i) = 0;
        elseif -1 < delta(i) && delta(i) <= -0.3535
            delta(i) = -10;
        end
    end
end