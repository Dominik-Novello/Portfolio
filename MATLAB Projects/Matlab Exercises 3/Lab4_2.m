close all
clear all
clc

x = @(t) 0.6 * ((t>=-2) - (cos(pi * t)+1) .* ((t >= -1) - (t >= 1)) - (t >= 2));
t = -5:.01:5;
t2 = -5:.01:25;
Nk = 51;
dT = t(2) - t(1);
T = dT * (length(t) - 1);
w0 = (2 * pi) / T;

Ck = Lab4_1(x, t, Nk, 1);

figure(3)

x2 = zeros(size(t2));
k = -floor(length(Ck)/2):floor(length(Ck)/2);

for ii = 1:length(Ck)
    x2 = x2 + (Ck(ii) * exp(j * k(ii) * w0 * t2));
end

subplot(2,1,1)
plot(t2, x2);
xlabel('t');
title('reconstructed signal');