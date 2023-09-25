ind = 1; 
for x = (-2 * pi):.1:(2 * pi)
    SincHold(ind) = MySinc(x);
    SinHold(ind) = sinc(x);
    ind = ind + 1;
end

base = -2 * pi:.1:2 * pi;
plot(base,SincHold);
hold on
plot(base,SinHold);
hold off