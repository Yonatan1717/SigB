% Oppgave 3
% Oppgave 3

function [t, out] = my_squere(t, f0, d_c, bds=[-1,1], pds=0, cent=false);
    #{ 
        t: tidsvektor
        f0: fundemental frekvens
        d_c: duty cycle 
        bds: bounds aks grenser (hva høy og lav er i verdi) -> bds(1) = lav verdi, bds(2) = høy verdi.  
        pds: antall perioder man ønsker 
        cent: få en sentrerrt positiv puls omkring origo (alså tidskifte med halv pulsperiode, t-t1 hvor t1 = (T*d_c)/2)

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

    t = t*1e3;
 
end;

% a) 
% 100 sample pr periode ga en god nok firekant puls
f0 = 1e3; 
fs = f0*100;

t_start = 0;
t_end = 1;
dt = 1/fs;

bds = [-1,1];
bds2= [0,1];

t_org = (t_start:dt:t_end);
[t, out] = my_squere(t_org, f0, 50, bds, 4);
[t2, out2] = my_squere(t_org, f0, 20, bds2, 4, true);

figure(1);

subplot(2,1,1);
plot(t,out);
ylim([bds(1)-0.2, bds(2)+0.2]);
xlabel('Time [ms]');
ylabel('Amplitude [V]');

subplot(2,1,2);
plot(t2, out2);
ylim([bds2(1)-0.2, bds2(2)+0.2]);
xlabel('Time [ms]');
ylabel('Amplitude [V]');


% b)
function [t, out] = my_squre2(f0, d_c, spp, pds=5, cent=false)
    #{ 
        f0: fundemental frekvens
        d_c: duty cycle 
        spp: samples per periode 
        pds: antall perioder man ønsker 
        cent: få en sentrerrt positeiv puls omkring origo (alså tidskifte med halv pulsperiode, t-t1 hvor t1 = (T*d_c)/2)

        return verdi -> t: resulterdne tidsavektor skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #}

    T = 1/f0;
    d_c = d_c/100; 
    dt = T/spp;

    pc = spp*d_c;
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

function [t, out] = my_squre2_bedre(f0, d_c, spp, bds=[-1,1], pds=5, shift=0)
    #{ 
        f0: fundemental frekvens
        d_c: duty cycle 
        spp: samples per periode 
        bds: bounds aks grenser (hva høy og lav er i verdi) -> bds(1) = lav verdi, bds(2) = høy verdi. 
        pds: antall perioder man ønsker 
        shfit: shift i tid gitt i prosent -> t + T*(shift/100)

        return verdi -> t: resulterdne tidsavektor skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #} 

    d_c = d_c/100; 
    T = 1/f0;
    dt = T/spp;
    pulse_end_time = T*d_c;

    t = 0:dt:(T*pds-dt);
    t_mod =  mod(t + T*(shift/100), T);

    out = t_mod;
    out(t_mod <= pulse_end_time) = bds(2);
    out(t_mod > pulse_end_time) = bds(1);

    t = t*1e3;
end;


f0 = 1e3; 
d_c = 50; # %
spp = 100; # sample per periode
pds = 3;
bds = [0,1];

[t, out] = my_squre2(f0, d_c, spp, pds, true);
[t2, out2] = my_squre2_bedre(f0, d_c, spp, bds, pds);

figure(2);
hold on;
plot(t, out);
plot(t2, out2, "r");
xlabel('Time [ms]');
ylabel('Amplitude [V]');
xticks(0:.5:t(end));
legend("my-squre-2", "my-squre2-bedre");
ylim([bds(1)-0.2, bds(2)+0.2]);






