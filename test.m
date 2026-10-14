clc;
clear all;
close all;

pkg load signal;

T = 1;
f = 1/T;

dt = 0.2;
fs = 1/dt;

t = 1:dt:10;

% Square
y = square(2*pi*f*t);

N = length(y);

square_fft = fft(y);
frequencies = (0:N-1)*(fs/N);

% Plot square wave and FFT
figure;

subplot(2,1,1);
plot(t, y);
title('Square Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(frequencies, abs(square_fft));
title('FFT of Square Wave');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;


% Zero pad
y_padded = [y, zeros(1, length(y))];

N_padded = length(y_padded);

square_fft_padded = fft(y_padded);
frequencies_padded = (0:N_padded-1)*(fs/N_padded);

t_padded = t(1) + (0:N_padded-1)*dt;

figure;

subplot(2,1,1);
plot(t_padded, y_padded);
title('Zero-Padded Square Wave');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
stem(frequencies_padded, abs(square_fft_padded));
title('FFT of Zero-Padded Square Wave');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on;