%% signal x(t)=2,-1<t<0 and impulse response h(t)=1-t,0<t<1
close all
clear all
clc
%% definfing universal time step, will use as a scaling factor
dT=0.01;
%% defining x(t), a piecewise function
% x(t)=2,-1<t<0
t1x=-1:dT:0-dT; % non overlapping time-segments
t2x=0:dT:2;
x1=2*ones(size(t1x));
x2=zeros(size(t2x));
x=[x1 x2];
tx=[t1x t2x]; % tx definded from -1 to 2
%% defining h(t), a piecewise function
%h(t)=1-t,0<t<1
t1h=-2:dT:0-dT; % non overlapping time-segments
t2h=0:dT:1;
t3h=1+dT:dT:2;
% h1=zeros(size(t1h));
h2=1-t2h;
h3=zeros(size(t3h));
h=[ h2 h3];
th=[t2h t3h]; % th definded from -2 to 2
%%
figure
subplot(311)
plot(tx,x);
ylabel('x(t)')
subplot(312)
plot(th,h)
ylabel('h(t)')
%
y=conv(x,h);
% y=conv(x,h)*dT; % scaling facotor dT
%
% % y has a larger length than 'x' and 'h'
% length(x)
% length(y)
% length(h)
%% size of convoluted signal is sum of size of x(t) and h(t)
ty=min(tx)+min(th):dT:max(tx)+max(th);
subplot(313)
plot(ty,y);
ylabel('x(t)*h(t)')
xlim([min(tx)+min(th) max(tx)+max(th)])
%
%
%
%% h= deconv(y,x)
% 1st element of 'x' must not be zero.
% y(1)=0; % no error
h(1)=1; % error !!
xx=deconv(y,h)*(1/dT); % scaling factor (1/dT)
t_xx=min(ty)-min(th):dT:max(ty)-max(th);
figure
plot(t_xx,xx)
ylim([-.1 1.1]);
ylabel('x(t)')
% legend('impulse response h(t)')