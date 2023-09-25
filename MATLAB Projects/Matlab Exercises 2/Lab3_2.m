close all
clear all
clc
%% Signals/Impulse Response
x1=@(t) 5 .* (t>=0) .* (10>=t);

x2=@(t) 2 * x1(t-10);

x_comb=@(t) x1(t) + (2 * x1(t-10));

h=@(t) (exp(-t/4).*cos((31^(1/2)*t)/4) - (31^(1/2)*exp(-t/4).*sin((31^(1/2)*t)/4))/31).*(t>=0);

dtau = 0.1;
tau = -10:dtau:40;

dT=0.1;
t = -10:dT:40;
%%
figure (1)
y1 = NaN(1, length (t));
for x=1:length(t) % Integrate X1 / H(-t)
    x1h = h(t(x)-tau).*x1(tau);
    y1(x)=trapz(tau,x1h);

    subplot (211)
    plot(tau, x1(tau), 'k-');
    xlabel('\tau','fontsize',13);
    legend('x1(\tau)','fontsize',13);
    subplot (212)
    plot (t, y1, 'k', t (x), y1(x), 'ok');
    xlabel ('t','fontsize',13); ylabel ('y1(t)','fontsize',13);
    drawnow;
end
%%
figure (2)
y2 = NaN(1, length (t));
for x=1:length(t) % evaluating integration of x(tau)*h(t-tau)
    x2h = h(t(x)-tau).*x2(tau);
    y2(x)=trapz(tau,x2h);

    subplot (211)
    plot(tau, x2(tau), 'k-');
    xlabel('\tau','fontsize',13);
    legend('2\timesx1(\tau-10)','fontsize',13);
    subplot (212)
    plot (t, y2, 'k', t (x), y2(x), 'ok');
    xlabel ('t','fontsize',13); ylabel ('y2(t)','fontsize',13);
    drawnow; 
end
%
figure (3)
y_comb = NaN(1, length (t));
for x=1:length(t) % evaluating integration of x(tau)*h(t-tau)
    x_combh = h(t(x)-tau).*x_comb(tau);
    y_comb(x)=trapz(tau,x_combh);

    subplot (211)
    plot(tau, x_comb(tau), 'k-');
    xlabel('\tau','fontsize',13);
    legend('x1(\tau)+5x1(\tau-5)','fontsize',13);
    subplot (212)
    plot (t, y_comb, 'k', t (x), y_comb(x), 'ok');
    xlabel ('t','fontsize',13); ylabel ('Y_Comb(t)','fontsize',13);
    drawnow;
end
%%
figure (4)
ytotal= y1 + y2;
subplot(211)
plot(t,ytotal)
ylabel('Y_Total','fontsize',13)
xlabel ('t','fontsize',13)
subplot(212)
plot(t,y_comb)
ylabel('Y_Comd','fontsize',13)
xlabel ('t','fontsize',13)
