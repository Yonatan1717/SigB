% ============================================================
% Oppgave 3
%
% Egne hjelpefunksjoner ligger i:
%   ../../nyttigeFunksjoner/
%
% Bruk "help funksjonsnavn" for dokumentasjon, eksempel:
%   help mySquareV1
%   help bitWaveGen
% ============================================================

pkg load signal;

script_dir = fileparts(mfilename("fullpath"))
addpath(fullfile(script_dir, "..", "..", "nyttigeFunksjoner"));


%% Oppgave a) - Firkantpuls

% 100 samples per periode gir en tilstrekkelig jevn firkantpuls.
f0 = 10e3;
T = 1/f0;

spp = 100;                 % Samples per periode
fs = f0*spp;               % Samplingsfrekvens
dt = 1/fs;

t_start = 0;
t_end = T*4 - dt;          % Fire perioder
t = t_start:dt:t_end;

d_c  = 50;                 % Duty cycle [%]
d_c2 = 20;                 % Duty cycle [%]


% Generer signalene med egen mySquareV1-funksjon.
[_, out_m]  = mySquareV1(t, f0, d_c);
[_, out_m2] = mySquareV1(t, f0, d_c2, [0,1], 0, true);


% Generer tilsvarende signaler med Octave sin square()-funksjon.
out = square(2*pi*f0*t, d_c);

% Forskyv signalet med en halv pulsbredde for å sentrere pulsen.
t_shift = T*(d_c2/100)/2;

out2 = square(2*pi*f0*(t + t_shift), d_c2);

% Skaler amplituden fra [-1, 1] til [0, 1].
out2 = (out2 + 1)/2;


% Skaler tidsaksen til millisekunder.
t_ms = t*1e3;


% Sammenligning av mySquareV1 og square().
figure(1);

subplot(2,1,1);
hold on;

plot(t_ms, out_m2, "r", ...
    "DisplayName", sprintf("mySquareV1, d_c = %d %%, sentrert", d_c2));

plot(t_ms, out_m, "b", ...
    "DisplayName", sprintf("mySquareV1, d_c = %d %%", d_c));

ylim([-1.2, 1.2]);
xlabel("Time [ms]");
ylabel("Amplitude [V]");
title("mySquareV1");
legend();
grid on;


subplot(2,1,2);
hold on;

plot(t_ms, out2, "r", ...
    "DisplayName", sprintf("d_c = %d %%, sentrert", d_c2));

plot(t_ms, out, "b", ...
    "DisplayName", sprintf("d_c = %d %%", d_c));

ylim([-1.2, 1.2]);
xlabel("Time [ms]");
ylabel("Amplitude [V]");
title("square-funksjonen i Octave");
legend();
grid on;



%% Oppgave b) - Bitsekvens

bits = [1, 0, 1, 0];

T   = 1e-3;                % Bittid [s]
spp = 100;                 % Samples per bit
sh  = 50;                  % Forskyvning [%]

% Generer bitsekvens med egen bitWaveGen-funksjon.
[t, out] = bitWaveGen(bits, T, spp, sh);


% Plot bitsekvensen.
figure(3);

dsp = sprintf( ...
    "bitWaveGen, bits = [%s], T = %g [ms], spp = %d, sh = %d %%", ...
    num2str(bits), T*1e3, spp, sh);

plot(t, out, "b", "DisplayName", dsp);

xlabel("Time [ms]");
ylabel("Amplitude [V]");
xticks(0:0.5:t(end));
ylim([-0.2, 1.2]);

legend();
grid on;
