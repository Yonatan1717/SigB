% Oppgave 2
% Oppgave 2

% a)
dt = 5e-6; # s 
fs = 1/dt;
t_start = 0; # s
t_end = 2e-3; # s

t = t_start:dt:t_end; 

% b) 
A = 5; # V
f = 2e3; # Hz
w = 2*pi*f;

s = A*sin(w*t);

figure(1);
subplot(2,1,1)
plot(t, s);

xlabel("time [s]"); ylabel("Amplitude [V]");
ttl = sprintf("Sinus bølge: A = %d [V], f = %d [kHz], dt = %g [us], fs = %g [kHz], dp = %d", A, f/1e3, dt*1e6, fs/1e3, length(t)); 
title(ttl);

% b)
subplot(2,1,2)
plot(t*1e3, s);

xlabel("time [ms]"); ylabel("Amplitude [V]");
ttl = sprintf("Sinus bølge (skalert): A = %d [V], f = %d [kHz], dt = %g [us], fs = %g [kHz], dp = %d", A, f/1e3, dt*1e6, fs/1e3, length(t)); 
title(ttl);

% c-f
dts = [50e-6, 200e-6, 250e-6, 400e-6]; # steg lengder
colors = ["b", "r", "g", "k"];

figure(3)
hold on; 
for i = 1:length(dts); # loope gjennom alle seg lengder
    dt_i = dts(i);
    fs_i = 1/dt_i;
    t_i = t_start:dt_i:t_end; 
    s_i = A*sin(w*t_i);
    spp_i = uint32(fs_i/f); # ca sample pr periode 

    plot(t_i*1e3, s_i, colors(i), "DisplayName", sprintf("dt = %g us, fs = %g [kHz], spp = %d, dp = %d", dt_i*1e6, fs_i/1e3, spp_i, length(t_i)));
end;

ttl = sprintf("Sinus bølge varierende dt: A = %d [V], f = %d [kHz]", A, f/1e3); 
title(ttl);
xlabel("time [ms]"); ylabel("Amplitude [V]");
legend();

hold off;

figure(4);
for i = 1:length(dts)
    dt_i = dts(i);
    fs_i = 1/dt_i;
    t_i = t_start:dt_i:t_end; 
    s_i = A*sin(w*t_i);
    spp_i = uint32(fs_i/f); # ca sample pr periode

    subplot(2,2, i);
    plot(t_i*1e3, s_i, colors(i));

    xlabel("time [ms]"); ylabel("Amplitude [V]");
    ttl_i = sprintf("Sinus bølge: dt = %g [us], fs = %g [kHz], spp = %d, dp = %d", dt_i*1e6, fs_i/1e3, spp_i, length(t_i));
    title(ttl_i);
end;
