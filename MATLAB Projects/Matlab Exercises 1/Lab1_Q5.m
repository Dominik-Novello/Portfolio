s1 = zeros(1,101);
s2 = zeros(1,101);
s3 = zeros(1,101);
for t_it = 0:100
    s1(t_it+1) = sin(2 * pi * 0.2 * (t_it/10));
    s2(t_it+1) = sin((2 * pi * 0.425 * (t_it/10)) + 0.4);
    s3(t_it+1) = s1(t_it+1) + s2(t_it+1);
end

t = 0:.1:10;
plot(t,s1, 'r');
hold on
plot(t,s2, 'b');
plot(t,s3, 'k');
hold off