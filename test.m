
clear all; close all; clc;
pkg load signal;
pkg load communications;

script_dir = fileparts(mfilename("fullpath"))
addpath(genpath(fullfile(script_dir, "innleveringer", "nyttigeFunksjoner")));


function out =  myFunc(t)
    T = 8e-3;
    A = 2;
    f0 = 1/T;
    tau = T/4;
    d_c = round((tau/T)*100);
    [_ , out] = mySquareV1(t,f0, d_c, [0, A],0, true);
    % out = sin(t*f0*2*pi) + sin(t*f0*2*pi + pi/4);
end;

A = 2;
T = 8e-3;

dp = 1000;
nfreqs = 500;

[dc, t, sq] = findA0(@myFunc, T, dp);
figure(6);
plot(t, sq);
ylim([-.2, A+.2])
[amp_l, phi_l1, freq_l1, a_l, b_l, amp_mm1, phi_mm1] = findAnandBns(@myFunc, T, nfreqs, dp);

figure(1);
subplot(2,1,1);
stem([0, freq_l1], [dc, amp_l], "r", "filled", "lineWidth", 1.3);
ylim([amp_mm1(1)-.2, amp_mm1(2)+.2]);
ylabel("Amplitude [V]"); xlabel("frekvnes [Hz]");
title("Amplitude");
grid();

subplot(2,1,2);
marg = radToDeg(.2);
phi_mm1 = radToDeg(phi_mm1);
stem(freq_l1, radToDeg(phi_l1), "b", "filled", "lineWidth", 1.3);
ylim([phi_mm1(1)-marg, phi_mm1(2)+marg]);
ylabel("Faseskift [deg]"); xlabel("frekvnes [Hz]");
title("fase");
grid();

figure(2);
[mag_l, phi_l, freq_l, c_l, mag_mm, phi_mm] = findCns(@myFunc, T, nfreqs, dp);

subplot(2,1,1);
stem(freq_l, mag_l, "r", "filled", "lineWidth", 1.3);

ylim([mag_mm(1)-.2, mag_mm(2)+.2]);
title("Magnitude");
ylabel("Magnitude"); xlabel("frekvnes [Hz]");
grid();

subplot(2,1,2);
phi_mm = radToDeg(phi_mm);
stem(freq_l, radToDeg(phi_l), "b", "filled", "lineWidth", 1.3);

ylim([phi_mm(1)-marg, phi_mm(2)+marg]);
title("Fase");
ylabel("Faseskift [deg]"); xlabel("frekvnes [Hz]");
grid();

function [H, gain_l, phi_l, C] = HRCLowPass(f, f_cut, R)

    C = 1/(f_cut*2*pi*R);

    H = 1 ./ (1 + j*2*pi*f*R*C);

    gain_l = abs(H);
    phi_l = angle(H);
end;

R = 10e3;
f_cut = 500;
f = [0, freq_l1];

[H, gain_l, phi_l, C] = HRCLowPass(f, f_cut, R);
disp(sprintf("R = %g [Ohm], C = %g [F], RC = %g [s]", R, C, R*C));
figure(3);
subplot(2,1,1);
plot(f, gain_l);

subplot(2,1,2);
plot(f, phi_l);

% bruk filterer på findAandBs
filterd_amp_l = gain_l.*[dc, amp_l];
filterd_phi_l = phi_l+ [0, phi_l1];
figure(4);

subplot(2,1,1);
stem(f, filterd_amp_l, "r", "filled", "lineWidth", 1.3);
ylabel("Amplitude");
grid on;

subplot(2,1,2);
stem(f, radToDeg(filterd_phi_l), "b", "filled", "lineWidth", 1.3);
ylabel("Fase [deg]");
xlabel("Frekvens [Hz]");
grid on;

function [t, out]  = getFilterdTimeDomainFromFindAandBsOnePeriode(f,filterd_amp_l, phi_l, pds, dp)
    % bruker x(t) = amp*cos(2*pi*f_n*t + phi) for å starte med
    f_max = max(f);
    f0 = f(2);
    T = 1/f0;
    dt = (pds*T)/dp;

    fs = 1/dt;
    if (fs < f_max*2.5)
        fs = f_max*2.5;
        dt = 1/fs;
    end

    t = 0:dt:(pds*T-dt);
    out =[];
    for t_d=t;
        out = [ out, sum( filterd_amp_l .* cos(2*pi*f*t_d + phi_l )) ];
    end;
end;


[t, out] = getFilterdTimeDomainFromFindAandBsOnePeriode(f, filterd_amp_l, filterd_phi_l, 3,200);

figure(5);
plot(t, out);
ylim([-.2, A+.2])