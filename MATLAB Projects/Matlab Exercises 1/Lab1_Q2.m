xt = zeros(3,5);

for f = 2:4
    for t = 0:4
        xt(f-1,t+1) = 3 * cos((2 * pi * (f * 5) * (t / 10)) + 0.1);
    end
end