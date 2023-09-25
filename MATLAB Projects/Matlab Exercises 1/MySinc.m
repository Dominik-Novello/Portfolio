function sinc = MySinc(x)
    if x == 0
        sinc = 1;
    else
        sinc = sin(x)/x;
    end
end