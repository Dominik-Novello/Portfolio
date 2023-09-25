function [Ck]=Lab4_1(x,t,Nk,p)
% Ck = exponential fourier series cofficient
% x = single period of a signal
% t = time corrosponding to 'x'
% Nk = (optional input) number of exponential terms
% p = plotting option ; p=0, no plots, p = 1 plot Ck vs k and reconstructed signal
% dT = t(2)-t(1) = temporal resolution of signal (x)
% T = peiod of signal 'x'
% w0= angular frequency of signal 'x'
dT=t(2)-t(1);
T= dT*length(t);
w0=2*pi/T;
% Check the number of inputs, 'nargin' returns number of input arguments
if nargin <2
    error('Not enough input argument!')
elseif nargin == 2
    Nk=101; % you can set any default value you like
    p=0; % not plots
elseif nargin ==3
    p=0; % not plots
end
k=-floor(Nk/2):floor(Nk/2); % if Nk=11, k=-5:5; if Nk=12, k=-6:6
%% evaluate Ck
for ii = 1:length(k)
    Ck(ii) = (1/T)*trapz(t, x(t).*exp(-j*k(ii)*w0*t));
end
%% plot spectrum and reconstructed signal
if p==1
% plot abs(Ck) vs k and angle(Ck) vs k
    subplot(2,1,1);
    w0k = w0 * k;
    stem(w0k, abs(Ck));
    xlabel('w0k');
    ylabel('|C_k|');

    subplot(2,1,2);
    stem(w0k,angle(Ck)*(180/pi));
    xlabel('w0k');
    ylabel('\angleC_k');
% plot 3 cycles of the signal 'x' and the reconstructed signal
    x_ext = repmat(x(t), 1, 3);
    t_ext = t(1):dT:t(1)+(3*length(t)-1)*dT;

    x_reconstructed = zeros(size(t_ext));

    for ii = 1:length(k)
        x_reconstructed = x_reconstructed + Ck(ii) * exp(j * k(ii) * w0 *t_ext);
    end
    figure(2)
    subplot(2,1,1)
    plot(t_ext, x_ext);
    xlabel('t');
    title('original signal');

    subplot(2, 1, 2)
    plot(t_ext, x_reconstructed);
    xlabel('t');
    title('reconstructed signal')
end
end
