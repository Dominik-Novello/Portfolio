close all
clear all
clc

xt = @(t) sin(400 * pi * t) .* (t>=0);

ht = @(t) 400 * exp(-200 * t) .* cos(400 * pi * t) .* (t>=0);

dT = 1/(400 * pi);
tx = -.1:dT:0.1;
th = -.1:dT:0.1;
ty = (min(th) + min(tx)):dT:(max(tx) + max(th));

subplot(3,1,1);
plot(tx,xt(tx));
xlabel('t');
ylabel('x(t)');
grid;

subplot(3,1,2);
plot(th, ht(th), 'r');
xlabel('t');
ylabel('h(t)');
grid;

yt = conv(xt,ht)*dT;
subplot(3,1,3);
plot(ty, yt, 'b');
xlabel('t');
ylabel('y(t)');
xlim([min(txh), max(txh)]);
grid;