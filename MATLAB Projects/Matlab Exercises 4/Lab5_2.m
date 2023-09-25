close all
clear
clc

Gw = @(w) 2 * ((abs(w) >= 5) & (abs(w) <= 10));
Hw = @(w) (5 * abs(w)) * (abs(w) <= 20);
Mw = @(w) (2 * ((abs(w) >= 5) & (abs(w) <= 10))) * ((5 * abs(w)) * (abs(w) <= 20));
dT = 0.1;
dW = 0.01;

w = -34.1:dW:34.1;
t = -100:dT:100;

g = zeros(1, length(t));
for ii=1:length(t)
    g(ii)= trapz(w,(1 / (2 *pi)) * Gw(w).*exp(1i*w*t(ii)));
end