% ============================================================
% Innlevering 3 - Fourier-serie og RC lavpassfilter
%
% Egne hjelpefunksjoner ligger i:
%   ../nyttigeFunksjoner/
%
% Siden denne filen er tenkt plassert direkte i:
%   innleveringer/A3/
%
% kan alle hjelpefunksjoner lastes inn relativt til scriptet.
%
% Bruk "help funksjonsnavn" for dokumentasjon, eksempel:
%   help mySquareV1
%   help findA0
%   help findAnandBns
%   help findCns
%   help radToDeg
% ============================================================

clear all;
close all;
clc;

pkg load signal;
pkg load communications;

% Legg til mappa med egne hjelpefunksjoner
script_dir = fileparts(mfilename("fullpath"));
addpath(genpath(fullfile(script_dir, "..", "..", "nyttigeFunksjoner")));

% Mappe for genererte plot
plot_dir = fullfile(script_dir, "plots");

if !exist(plot_dir, "dir")
    mkdir(plot_dir);
end

% Lokale funksjoner
function out = pulseTrain(t, A, T, tau)

    % Genererer pulstoget som er gitt i oppgaven
    f0 = 1/T;
    d_c = round((tau/T)*100);

    [_, out] = mySquareV1(t, f0, d_c, [0, A], 0, true);

end


%% Felles parametere

A   = 2;                   % Amplitude [V]
tau = 2e-3;                % Pulsbredde [s]
T   = 8e-3;                % Periodetid [s]
f0  = 1/T;                 % Grunnharmonisk frekvens [Hz]

dp = 1000;                 % Beregningspunkter per periode
N  = 6;                    % Antall Fourier-komponenter

% Parametere for RC lavpassfilter
R     = 10e3;              % Motstand [Ohm]
f_cut = 500;               % Knekkfrekvens [Hz]


% Signal-funksjon som brukes.
func = @(t) pulseTrain(t, A, T, tau);


%% Oppgave b) - Numeriske Fourier-koeffisienter

% Beregn DC-komponenten.
[dc, t_sq, sq] = findA0(func, T, dp);

% Beregn amplituder, faser og reelle Fourier-koeffisienter.
[amp_l, phi_l, freq_l, a_l, b_l, amp_mm, phi_mm] = ...
    findAnandBns(func, T, N, dp);

% Vis de viktigste numeriske verdiene i terminalen.
disp(" ");

disp("=== Fourier-koeffisienter ===");
disp(sprintf("DC = %g V", dc));
disp("Frekvens [Hz] | Amplitude [V] | Fase [deg] | k <= 10");

if length(freq_l) > 10

    disp([freq_l(1:10)', amp_l(1:10)', radToDeg(phi_l(1:10))']);

else

    disp([freq_l', amp_l', radToDeg(phi_l)']);

end


%% Oppgave c) - Fourier-serien i tids- og frekvensdomene

% Plot det opprinnelige rektangulære pulstoget.
figure(1);

plot(t_sq*1e3, sq, "k", "linewidth", 1.3);

xlabel("Tid [ms]");
ylabel("Amplitude [V]");
title("Opprinnelig rektangulært pulstog");

ylim([-0.2, A + 0.2]);

grid on;

print(fullfile(plot_dir, "oppgave_c_pulstog.png"), "-dpng", "-r300");


% Plot amplitudespekter og fasespekter for den reelle Fourier-serien.
figure(2);

subplot(2,1,1);

stem([0, freq_l], [dc, amp_l], "r", "filled", "linewidth", 1.3);

ylabel("Amplitude [V]");
xlabel("Frekvens [Hz]");
title("Amplitudespekter");

grid on;


subplot(2,1,2);

stem(freq_l, radToDeg(phi_l), "b", "filled", "linewidth", 1.3);

ylabel("Faseskift [deg]");
xlabel("Frekvens [Hz]");
title("Fasespekter");

grid on;

print(fullfile(plot_dir, "oppgave_c_fourier_spekter.png"), "-dpng", "-r300");


% Rekonstruer Fourier-serien i tidsdomenet.
f_l = [0, freq_l];

unfiltered_amp_l = [dc, amp_l];
unfiltered_phi_l = [0, phi_l];

[t_fourier, yin] = getTimeDomainFromSpectrum( ...
    f_l, unfiltered_amp_l, unfiltered_phi_l, 3, 1000);


% Generer originalsignalet på samme tidsakse for sammenligning.
original = func(t_fourier);

figure(3);

hold on;

plot(t_fourier*1e3, original, "k", ...
    "linewidth", 1.3, "DisplayName", "Rektangulært pulstog");

plot(t_fourier*1e3, yin, "b", ...
    "linewidth", 1.2, ...
    "DisplayName", sprintf("Fourier-serie, N = %d", N));

hold off;

xlabel("Tid [ms]");
ylabel("Amplitude [V]");
title("Rektangulært pulstog og Fourier-tilnærming");

ylim([-0.2, A + 0.4]);

legend();
grid on;

print(fullfile(plot_dir, "oppgave_c_fourier_tid.png"), "-dpng", "-r300");


%% kompleks Fourier-serie

% Beregn de komplekse Fourier-koeffisientene.
[mag_l, phi_c_l, freq_c_l, c_l, mag_c_mm, phi_c_mm] = ...
    findCns(func, T, N, dp);

figure(4);

subplot(2,1,1);

stem(freq_c_l, mag_l, "r", "filled", "linewidth", 1.3);

ylabel("Magnitude");
xlabel("Frekvens [Hz]");
title("Kompleks Fourier-serie - magnitude");

grid on;


subplot(2,1,2);

stem(freq_c_l, radToDeg(phi_c_l), "b", "filled", "linewidth", 1.3);

ylabel("Faseskift [deg]");
xlabel("Frekvens [Hz]");
title("Kompleks Fourier-serie - fase");

grid on;

print(fullfile(plot_dir, "kompleks_fourier_spekter.png"), "-dpng", "-r300");


%% Oppgave e) - Frekvensrespons for RC lavpassfilter

[H, gain_l, filter_phi_l, C] = rcLowPass(f_l, f_cut, R);

% Skriv ut beregnede komponentverdier og filterrespons.
disp(" ");

disp("=== RC lavpassfilter ===");

disp(sprintf("R = %g Ohm", R));
disp(sprintf("C = %g F", C));
disp(sprintf("RC = %g s", R*C));

disp("Frekvens [Hz] | |H(f)| | Fase [deg] | k <= 10");

if length(f_l) > 10

    disp([f_l(1:10)', gain_l(1:10)', radToDeg(filter_phi_l(1:10))']);

else

    disp([f_l', gain_l', radToDeg(filter_phi_l)']);

end


% Plot filterets respons for de aktuelle Fourier-frekvensene.
figure(5);

subplot(2,1,1);

stem(f_l, gain_l, "r", "filled", "linewidth", 1.3);

ylabel("|H(f)|");
xlabel("Frekvens [Hz]");
title(sprintf("RC lavpassfilter, f_c = %g Hz", f_cut));

grid on;


subplot(2,1,2);

stem(f_l, radToDeg(filter_phi_l), "b", "filled", "linewidth", 1.3);

ylabel("Fase [deg]");
xlabel("Frekvens [Hz]");

grid on;

print(fullfile(plot_dir, "oppgave_e_filterrespons.png"), "-dpng", "-r300");


%% Oppgave f) - Filtrert frekvensspekter og utgangssignal

% Filteret demper amplituden og legger til faseforskyvning.
filtered_amp_l = gain_l .* unfiltered_amp_l;
filtered_phi_l = filter_phi_l + unfiltered_phi_l;


% Plot frekvenskomponentene etter filteret.
figure(6);

subplot(2,1,1);

stem(f_l, filtered_amp_l, "r", "filled", "linewidth", 1.3);

ylabel("Amplitude [V]");
xlabel("Frekvens [Hz]");
title("Frekvenskomponenter etter RC-filter");

grid on;


subplot(2,1,2);

stem(f_l, radToDeg(filtered_phi_l), "b", "filled", "linewidth", 1.3);

ylabel("Fase [deg]");
xlabel("Frekvens [Hz]");

grid on;

print(fullfile(plot_dir, "oppgave_f_filtrert_spekter.png"), "-dpng", "-r300");


% Rekonstruer det filtrerte signalet i tidsdomenet.
[t_out, yout] = getTimeDomainFromSpectrum( ...
    f_l, filtered_amp_l, filtered_phi_l, 3, 1000);


% Beregn innsignalet på samme tidsakse som utsignalet.
[_, yin] = getTimeDomainFromSpectrum( ...
    f_l, unfiltered_amp_l, unfiltered_phi_l, 3, 1000);


original = func(t_out);

figure(7);

hold on;

plot(t_out*1e3, original, "k", ...
    "linewidth", 1.2, "DisplayName", "Rektangulært pulstog");

plot(t_out*1e3, yin, "b", ...
    "linewidth", 1.2, "DisplayName", "Fourier-serie før filter");

plot(t_out*1e3, yout, "r", ...
    "linewidth", 1.3, "DisplayName", "Fourier-serie etter filter");

hold off;

xlabel("Tid [ms]");
ylabel("Amplitude [V]");

title(sprintf("Inn- og utsignal, N = %d og f_c = %g Hz", N, f_cut));

ylim([-0.2, A + 0.4]);

legend();
grid on;

print(fullfile(plot_dir, "oppgave_f_inn_og_utsignal.png"), "-dpng", "-r300");

% Etter filteret
disp("=== Fourier-koeffisienter etter filteret ===");
disp("Frekvens [Hz] | Amplitude [V] | Fase [deg] | k <= 10");

if length(f_l) > 10
    disp([f_l(1:10)', filtered_amp_l(1-:10)', radToDeg(filtered_phi_l(1:10))']);
else
    disp([f_l', filtered_amp_l', radToDeg(filtered_phi_l)']);
end