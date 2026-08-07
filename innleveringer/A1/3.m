% Oppgave 3
% Oppgave 3

pkg load signal;

function [t, out] = mySquareV1(t, f0, d_c, bds=[-1,1], pds=0, cent=false);
    #{ 
        t: tidsvektor
        f0: fundemental frekvens
        d_c: duty cycle 
        bds: bounds aks grenser (hva høy og lav er i verdi) -> bds(1) = lav verdi, bds(2) = høy verdi.  
        pds: antall perioder man ønsker 
        cent: få en sentrerrt positiv puls omkring origo (alså tidskifte med halv pulsperiode, t+t1 hvor t1 = (T*d_c/100)/2)

        return verdi -> t: tidsavektor om pds=0 t_ut = t_in eller så er den tilpaset skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #} 

    T = 1/f0;

    if pds != 0;
        t_stop = T*pds;
        idx = find(t >= t_stop, 1)-1;
        t = t(1:idx);
    end;
        
    d_c = d_c/100;
    rads = t*2*pi*f0;

    if cent;
        rads = t*2*pi*f0 + (2*pi*d_c)/2;
    end;

    pulse_end_rad = 2*pi*d_c;
    n_rad = mod(rads, 2*pi );

    out = n_rad;
    out(n_rad > pulse_end_rad) = bds(1);
    out(n_rad <= pulse_end_rad) = bds(2);

    t = t*1e3; # skaler til ms
 
end;

function [t, out] = mySquareV2(f0, d_c, spp, pds=5, cent=false)
    #{ 
        f0: fundemental frekvens
        d_c: duty cycle 
        spp: samples per periode 
        pds: antall perioder man ønsker 
        cent: få en sentrerrt positeiv puls omkring origo (alså tidskifte med halv pulsperiode, t+t1 hvor t1 = (T*d_c/100)/2)

        return verdi -> t: resulterdne tidsavektor skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #}

    T = 1/f0;
    d_c = d_c/100; 
    dt = T/spp;

    pc = round(spp*d_c);
    t = 0:dt:(T*pds-dt);
    if !cent;
        one_p = [ones(1,pc), zeros(1,spp-pc)];
    else;
        one_s = ones(1, pc);
        one_p = [one_s(1:round(end/2)), zeros(1,spp-pc), one_s((round(end/2)+1):end)];
    end;
   
    out = [];
    for i=1:pds;
        out = [out , one_p];
    end;

    t = t*1e3;
end;

function [t, out] = mySquareV3(f0, d_c, spp, bds=[-1,1], pds=5, sh=0)
    #{ 
        f0: fundemental frekvens
        d_c: duty cycle 
        spp: samples per periode 
        bds: bounds aks grenser (hva høy og lav er i verdi) -> bds(1) = lav verdi, bds(2) = høy verdi. 
        pds: antall perioder man ønsker 
        shfit: sh i tid gitt i prosent -> t + T*(sh/100)

        return verdi -> t: resulterdne tidsavektor skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #} 

    d_c = d_c/100; 
    T = 1/f0;
    dt = T/spp;
    pulse_end_time = T*d_c;

    t = 0:dt:(T*pds-dt);
    t_mod =  mod(t + T*(sh/100), T);

    out = t_mod;
    out(t_mod <= pulse_end_time) = bds(2);
    out(t_mod > pulse_end_time) = bds(1);

    t = t*1e3; 
end;

% a) 
% 100 sample pr periode ga en god nok firekant puls
f0 = 10e3; 
T = 1/f0;
fs = f0*100;

t_start = 0;
t_end = T*4;
dt = 1/fs;

d_c = 50; # %
d_c2 = 20; # %

t = (t_start:dt:t_end);

% sammenligning av mySquareV1  og square funksjonen i Octave
[_, out_m] = mySquareV1(t, f0, d_c);
[_, out_m2] = mySquareV1(t, f0, d_c2, [0,1], 0, true);

out = square(t*2*pi*f0, d_c);
t_1 = T*(d_c2/100)/2; 
out2 = square((t+t_1)*2*pi*f0, d_c2); #shiftet for å få en sentrert puls, dette tilsvarer det som er gjort i mySquareV1 med cent = true.
out2 = (out2 + 1)/2; # skalere til 0 og 1

figure(1);

subplot(2,1,1);
hold on;
t = t*1e3; # skaler til ms
plot(t,out_m, "b", "DisplayName", sprintf("mySquareV1, d_c = %d %%", d_c));
plot(t,out_m2, "r", "DisplayName", sprintf("mySquareV1, d_c = %d %%, sentrert", d_c2));
ylim([-1.2, 1.2]);
xlabel('Time [ms]');
ylabel('Amplitude [V]');
title(sprintf("mySquareV1, d_c = %d %%", d_c));
legend();

subplot(2,1,2);
hold on;
plot(t, out, "b", "DisplayName", sprintf("d_c = %d %%", d_c));
plot(t, out2, "r", "DisplayName", sprintf("d_c = %d %%, sentrert", d_c2));
ylim([-1.2, 1.2]);
xlabel('Time [ms]');
ylabel('Amplitude [V]');
title(sprintf("square funksjon i Octave, d_c = %d %%", d_c));
legend();


% a) test av mySquareV2 og mySquareV3

f0 = 1e3; 
d_c = 50; # %
spp = 1000; # sample per periode
pds = 3;
bds = [0,1];

[t, out] = mySquareV2(f0, d_c, spp, pds, true);
[t2, out2] = mySquareV3(f0, d_c, spp, bds, pds);

figure(2);
subplot(2,1,1);
hold on;
plot(t, out, "b", "DisplayName", sprintf("my-squre-2, d_c = %d %%, sentrert", d_c));
plot(t2, out2, "r", "DisplayName", sprintf("my-squre-2-bedre, d_c = %d %%", d_c));
xlabel('Time [ms]');
ylabel('Amplitude [V]');
ylim([bds(1)-0.2, bds(2)+0.2]);
xticks(0:0.5:t(end));
legend();

% en av grafene skal ha en shift i tid på 25% av pulsperioden T*(sh/100), dette tilsvarer sentrert puls slik som vist i føste versjon av my_squre2.
subplot(2,1,2);
sh = 25; # %
[t3, out3] = mySquareV2(f0, d_c, spp, pds, false);
[t4, out4] = mySquareV3(f0, d_c, spp, bds, pds, sh);
hold on;
plot(t3, out3, "b", "DisplayName", sprintf("my-squre-2, d_c = %d %%", d_c));
plot(t4, out4, "r", "DisplayName", sprintf("my-squre-2-bedre, d_c = %d %%, sh = %d %%", d_c, sh));
xlabel('Time [ms]');
ylabel('Amplitude [V]');
ylim([bds(1)-0.2, bds(2)+0.2]);
xticks(0:0.5:t3(end));
legend();


% b)
function [t, out] = bitWaveGen(bits, T, spp, sh=0)
    #{ 
        bits: vektor med bits (1 og 0) som skal generere en puls
        T: bit tid (periode) i sekunder
        spp: samples per periode 
        shfit: sh i tid gitt i prosent -> t + T*(sh/100)

        return verdi -> t: resulterdne tidsavektor skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #}

    dt = T/spp;
    pds = length(bits);
    sh_num = T*(sh/100);

    t = 0:dt:(T*pds-dt-sh_num);
    out = [];
    for i=1:pds;
        if bits(i) == 1;
            out = [out, ones(1,spp)];
        else;
            out = [out, zeros(1,spp)];
        end;
    end;
    out = out((round(sh_num/dt)+1):end);

    t = t*1e3; 
end;

bits = [1,0,1,0];
T = 1e-3; # s
spp = 10; # sample per periode
sh = 25; # %
[t, out] = bitWaveGen(bits, T, spp, sh);
figure(3);
plot(t, out, "b", "DisplayName", sprintf("bitWaveGen, bits = [%s], T = %g [ms], spp = %d, sh = %d %%", num2str(bits), T*1e3, spp, sh));
xlabel('Time [ms]');
ylabel('Amplitude [V]');
xticks(0:0.5:t(end));
ylim([-0.2, 1.2]);
legend();


