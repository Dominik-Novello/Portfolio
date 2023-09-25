close all
clear
clc

Gw = @(w) 2 * ((abs(w) >= 5) & (abs(w) <= 10));
Yw = @(w) 2 * ((abs(w-5) >= 5) & (abs(w-5) <= 10));
dT = 0.1;
dW = 0.01;

w = -34.1:dW:34.1;
t = -100:dT:100;

g_plot = zeros(1, length(w));
for y = 1:length(w)
    g_plot(y) = Gw(w(y));
end

g = zeros(1, length(t));
for ii=1:length(t)
    g(ii)= trapz(w,(1 / (2 *pi)) * Gw(w).*exp(1i*w*t(ii)));
end

g_real = real(g);
g_imag = imag(g);

figure (1)
subplot(3,1,1);
plot(w, g_plot);
title('G(w)');

subplot(3,1,2);
plot(t,g_real);
title('Re(g(t))');

subplot(3,1,3);
plot(t, g_imag);
title('Im(g(t))');

%% Y(w)

y_plot = zeros(1,length(w));
for q = 1:length(w)
    y_plot(q) = Yw(w(q));
end

y = zeros(1, length(t));
for ii=1:length(t)
    y(ii)= trapz(w,(1 / (2 *pi)) * Yw(w).*exp(1i*w*t(ii)));
end

y_real = real(y);
y_imag = imag(y);

figure (2)
subplot(3,1,1);
plot(w, y_plot);
title('Y(w)');

subplot(3,1,2);
plot(t,y_real);
title('Re(y(t))');

subplot(3,1,3);
plot(t, y_imag);
title('Im(y(t))');