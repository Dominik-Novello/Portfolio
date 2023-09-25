clear all
clc

h_0 = dsolve('100*D2hz + 20*Dhz + hz = 0', 'hz(0)=0', 'Dhz(0)=1','t');
h_1 = dsolve('100*D2hz + 20*Dhz + .2*hz = 0', 'hz(0)=0', 'Dhz(0)=1','t');

ht_0 = diff(h_0);
ht_1 = diff(h_1);

disp(['impulse response h1(t) = (',char(ht_0),')u(t)']);
disp(['impulse response h2(t) = (',char(ht_1),')u(t)']);

ht_0 = @(t) (exp(-t/10) - (t.*exp(-t/10))/10) .* (t>=0);
ht_1 = @(t) ((5*5^(1/2)*exp(t*(5^(1/2)/25 - 1/10))*(5^(1/2)/25 - 1/10))/2 + (5*5^(1/2)*exp(-t*(5^(1/2)/25 + 1/10))*(5^(1/2)/25 + 1/10))/2) .* (t>=0);

t = -10:.1:300;

subplot(3,1,1);
plot(t,ht_0(t));
xlabel('t');
ylabel('h1(t)');

subplot(3,1,2);
plot(t,ht_1(t));
xlabel('t');
ylabel('h2(t)');

