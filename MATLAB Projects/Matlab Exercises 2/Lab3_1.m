clear all
clc

h_0 = dsolve('2*D2hz + Dhz + 4*hz = 0', 'hz(0)=0', 'Dhz(0)=1','t');

h = diff(h_0);

disp(['impulse response h(t) = (',char(h),')u(t)']);

h = @(t) (exp(-t/4).*cos((31^(1/2)*t)/4) - (31^(1/2)*exp(-t/4).*sin((31^(1/2)*t)/4))/31) .* (t>=0);

t = -10:.01:30;

plot(t,h(t));

xlabel('t');
ylabel('h(t)');