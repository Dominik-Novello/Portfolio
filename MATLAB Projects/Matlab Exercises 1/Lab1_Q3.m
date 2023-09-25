output = zeros(1,3);
for w = 7:9
    great_x = 0;
    large_t = 0;
    t = 0;
    while great_x < 10
        t = t + .01;
        t1 = exp(1.2) * cos((w * 5) * t);
        t2 = t ^ 3;
        great_x = max(t1, t2);
    end
    output(w - 6) = t - .01;
end