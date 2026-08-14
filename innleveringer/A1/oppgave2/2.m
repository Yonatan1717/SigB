% ============================================================
% Oppgave 2
%
% Generering og sampling av en sinuskurve med ulike
% samplingsintervaller.
% ============================================================

%% Oppgave a) - Tidsvektor

dt = 5e-6;                 % Tidssteg [s]
fs = 1/dt;                 % Samplingsfrekvens [Hz]

t_start = 0;               % Starttid [s]
t_end   = 2e-3;            % Sluttid [s]

t = t_start:dt:t_end;


%% Oppgave b) - Sinussignal

A = 5;                     % Amplitude [V]
f = 2e3;                   % Frekvens [Hz]
w = 2*pi*f;                % Vinkelfrekvens [rad/s]

s = A*sin(w*t);


% Plot med tidsakse i sekunder
figure(1);

subplot(2,1,1);
plot(t, s, "LineWidth", 1.2);

xlabel("Time [s]");
ylabel("Amplitude [V]");

ttl = sprintf( ...
    "Sinusbølge: A = %d [V], f = %g [kHz], dt = %g [us], fs = %g [kHz], dp = %d", ...
    A, f/1e3, dt*1e6, fs/1e3, length(t));

title(ttl);
grid on;


% Plot med tidsakse i millisekunder
subplot(2,1,2);
plot(t*1e3, s, "LineWidth", 1.2);

xlabel("Time [ms]");
ylabel("Amplitude [V]");

ttl = sprintf( ...
    "Sinusbølge, skalert tidsakse: A = %d [V], f = %g [kHz], dt = %g [us], fs = %g [kHz], dp = %d", ...
    A, f/1e3, dt*1e6, fs/1e3, length(t));

title(ttl);
grid on;


%% Oppgave c-f) - Varierende samplingsintervall

dts = [50e-6, 200e-6, 250e-6, 400e-6];   % Tidssteg [s]
colors = ["b", "r", "g", "k"];


% Alle signalene i samme figur
figure(3);
hold on;

for i = 1:length(dts)
    dt_i = dts(i);
    fs_i = 1/dt_i;

    t_i = t_start:dt_i:t_end;
    s_i = A*sin(w*t_i);

    spp_i = fs_i/f;        % Samples per periode

    dsp = sprintf( ...
        "dt = %g us, fs = %g [kHz], spp = %g, dp = %d", ...
        dt_i*1e6, fs_i/1e3, spp_i, length(t_i));

    plot( ...
        t_i*1e3, ...
        s_i, ...
        colors(i), ...
        "LineWidth", 1.2, ...
        "DisplayName", dsp);
end

title(sprintf( ...
    "Sinusbølge med varierende dt: A = %d [V], f = %g [kHz]", ...
    A, f/1e3));

xlabel("Time [ms]");
ylabel("Amplitude [V]");

legend();
grid on;
hold off;


% Hvert signal i eget subplot
figure(4);

for i = 1:length(dts)
    dt_i = dts(i);
    fs_i = 1/dt_i;

    t_i = t_start:dt_i:t_end;
    s_i = A*sin(w*t_i);

    spp_i = fs_i/f;        % Samples per periode

    subplot(2,2,i);

    plot( ...
        t_i*1e3, ...
        s_i, ...
        colors(i), ...
        "LineWidth", 1.2);

    xlabel("Time [ms]");
    ylabel("Amplitude [V]");

    ttl_i = sprintf( ...
        "dt = %g [us], fs = %g [kHz], spp = %g, dp = %d", ...
        dt_i*1e6, fs_i/1e3, spp_i, length(t_i));

    title(ttl_i);
    grid on;
end