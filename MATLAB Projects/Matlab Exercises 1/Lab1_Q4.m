mainarray = zeros(1,15);
for t = 0:14
    mainarray(t+1) = 4 * cos(2 * pi * (t/14) +.2) + 3 * sin((pi ^ 2) * (t/14));
end

max_val = max(mainarray);
min_val = min(mainarray);
ave_val = mean(mainarray);

ind = 1;
for x = 1:15
    if abs(mainarray(x)) > 4
        array_ind(ind) = x;
        ind = ind + 1;
    end
end
