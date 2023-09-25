close all
clear all
clc
clf  % clear figure

%% signal: x, impulse response: h
x = @(time) 2*(time>=0 & time<2);
h = @(time) (time>=0 & time<1);

%% we need two time variables 'tau' and 't'
% 'tau' will be the variable for integration : resolution of 'tau' will 
                        % determine error limit of numerical integration
% 't' will be the variable for introducing time delay h(t-tau) : will
                        % determine the resolution of output signal y(t)
% the result will be in terms of time variable 't'
% y(t)=Integration (x(tau)*h(t-tau))*dtau, with limits of tau=-inf to +inf

dtau = 0.1;   % time step of tau (time), smaller value will improve the 
              % shape of signal 'x' and 'h'

tau = -10:dtau:40;  % 'tau' should cover time scale from -inf to 
                  % +inf, however, we are taking a range that
                  % specifies non-zero region of 'x' and 'h'
                
dT=0.1;   % step for variable 't': will define time resolution of 
          % output signal 'y'
          
% has to be careful while chooseing the limits for 't'
% y(t) will have non-zero value from min(non_zero_x)+min(non_zero_h)+ to
% max(non_zero_x)+ max(non_zero_h)
t = -10:dT:40;  % time variable for the time delay and output signal
y = NaN(1, length (t)); % Pre-allocate memory with NaN (Not a Number)
                        % will help during debugging 


for ii=1:length(t)  % evaluating integration of x(tau)*h(t-tau)
                    % for a specific time delay t(ii)
    t(ii)
    
    xh = h(t(ii)-tau).*x(tau); % x(tau) is an array with same length as
                               % time variable 'tau'
                               % h(-tau) is an array with same length as x(tau)
                               % h(t(ii)-tau) is a delayed version of
                               % signal h(-tau)
                               
    y(ii)=trapz(tau,xh)   % evaluating the overlap intergal of x(tau) and
                           % h(t-tau)
                           
    
  
%% plotting in fancy way, good to know what the code does, but not a  
%  necessary requirment
    subplot (211)
    plot(tau, x(tau), 'k-', tau, h(t(ii)-tau), 'b--', t(ii), 0, 'ok');
    xlabel('\tau'); axis ([tau(1) tau(end) -2.0 2.5]); grid;
    legend('x(\tau)','h(t-\tau)');
    
    subplot (212)
    plot (t, y, 'k', t (ii), y(ii), 'ok');
    xlabel ('t'); ylabel ('y(t) = \int x(\tau)h(t-\tau) d\tau');
    axis ([tau(1) tau(end) -1.0 5.0]); grid;
    drawnow;
    
  end