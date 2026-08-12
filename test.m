
3;

function out = mySquareV1(t, f0, d_c, bds=[-1,1], cent=false)
    #{ 
        t: tidsvektor
        f0: fundemental frekvens
        d_c: duty cycle 
        bds: bounds aks grenser (hva høy og lav er i verdi) -> bds(1) = lav verdi, bds(2) = høy verdi.  
        cent: få en sentrerrt positiv puls omkring origo (alså tidskifte med halv pulsperiode, t+t1 hvor t1 = (T*d_c/100)/2)

        return verdi -> t: tidsavektor om pds=0 t_ut = t_in eller så er den tilpaset skalert til ms, out: resulterde verdier for y aksen (amplitude vektor).
    #} 

    T = 1/f0;
        
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
 
end;

function [a_0, t, y] = findA0(func, T, dp)

    dt = T/dp;
    t = 0:dt:(T-dt);
    y = func(t);

    a_0 = mean(y);
end;

function [amp_l, phi_l, freq_l, a_l, b_l, amp_min_max, phi_min_max] = findAandBs(func, T, num_coffs, dp)
    % a_n = (2/T) * integral(x(t)cos(w_0*n*t), 0, T)
    % b_n = (2/T) * integral(x(t)sin(w_0*n*t), 0, T)
    % x(t) = dc + ( a_n*cos(w_0*n*t) + b_n*sin(w_0*n*t) ) -> amp*cos(w_0*n*t + phi), 
    % hvor, a_n = amp*cos(phi), b_n = -amp*sin(phi) ->  amp = sqrt(a_n^2+b_n^2) og phi = arctan(-b_n/a_n)

    n = 1:num_coffs;
    w_0 = (2*pi)/T;

    dt = T/dp;
    t = 0:dt:(T-dt);
    
    a_l = [];
    b_l = [];

    freq_l = [];

    amp_l = [];
    phi_l = [];
    for i=n;
        y_a = func(t).*cos(i*w_0*t);
        y_b = func(t).*sin(i*w_0*t);

        coff_a =  2*mean(y_a);
        coff_b =  2*mean(y_b);

        a_l = [a_l, coff_a];
        b_l = [b_l, coff_b];
        freq_l = [freq_l, i/T];
    end;

    amp_l = sqrt(a_l.^2 + b_l.^2);
    phi_l = atan2(-b_l, a_l);

    lim = max(amp_l)*1e-6;
    phi_l(amp_l < lim ) = 0;

    amp_min_max = [min(amp_l), max(amp_l)];
    phi_min_max = [min(phi_l), max(phi_l)];
end;

function [mag_l, phi_l, freq_l, c_l, mag_min_max, phi_min_max] = findCs(func, T, num_coffs, dp)
    % c_n = (1/T) * integral(x(t)*exp(-j*w*n*t), 0, T)
    % x(t) = dc + c_n*exp(j*w*t) -> n = [-l, l] 

    l = num_coffs;
    n = [-l:l];
    w_0 = (2*pi)/T;

    dt = T/dp;
    t = 0:dt:(T-dt);
    
    c_l = [];

    freq_l = [];

    mag_l = [];
    phi_l = [];
    for i=n;
        y1 = func(t).*exp(-j*w_0*i*t);

        coff_c =  mean(y1);

        c_l = [c_l, coff_c];
        freq_l = [freq_l, i/T];
    end;

    mag_l = abs(c_l);
    phi_l = angle(c_l);

    lim = max(mag_l)*1e-6;

    phi_l(mag_l < lim ) = 0;

    mag_min_max = [min(mag_l), max(mag_l)];
    phi_min_max = [min(phi_l), max(phi_l)];
end;

function deg = radToDeg(rad)
    deg = rad.*(180/pi);
end;

function out =  myFunc(t)
    T = 8e-3;
    A = 2;
    f0 = 1/T;
    tau = T/4;
    d_c = round((tau/T)*100);
    out = mySquareV1(t,f0, d_c, [0, A], true);
    %out = sin(t*f0*2*pi) + sin(t*f0*2*pi + pi/4);
end;

A = 2;
T = 8e-3;

dp = 140;
nfreqs = 35;

[dc, t, sq] = findA0(@myFunc, T, dp);
figure(6);
plot(t, sq);
ylim([-.2, A+.2])
[amp_l, phi_l1, freq_l1, a_l, b_l, amp_mm1, phi_mm1] = findAandBs(@myFunc, T, nfreqs, dp);
figure(1);
subplot(2,1,1);
stem([0, freq_l1], [dc, amp_l], "r");
ylim([amp_mm1(1)-.2, amp_mm1(2)+.2]);
ylabel("Amplitude [V]"); xlabel("frekvnes [Hz]")
title("Amplitude")
grid()

subplot(2,1,2)
marg = radToDeg(.2);
phi_mm1 = radToDeg(phi_mm1);
stem(freq_l1, radToDeg(phi_l1), "b");
ylim([phi_mm1(1)-marg, phi_mm1(2)+marg]);
ylabel("Faseskift [deg]"); xlabel("frekvnes [Hz]")
title("fase")
grid()

figure(2);
[mag_l, phi_l, freq_l, c_l, mag_mm, phi_mm] = findCs(@myFunc, T, nfreqs, dp);

subplot(2,1,1)
stem(freq_l, mag_l, "r");

ylim([mag_mm(1)-.2, mag_mm(2)+.2]);
title("Magnitude")
ylabel("Magnitude"); xlabel("frekvnes [Hz]")
grid()

subplot(2,1,2)
phi_mm = radToDeg(phi_mm);
stem(freq_l, radToDeg(phi_l), "b");

ylim([phi_mm(1)-marg, phi_mm(2)+marg]);
title("Fase")
ylabel("Faseskift [deg]"); xlabel("frekvnes [Hz]")
grid()

function [H, gain_l, phi_l, C] = HLowPass(f, f_cut, R)

    C = 1/(f_cut*2*pi*R);
    Z_c = 1./(j*2*pi*f*C);

    H = 1 ./ (1 + j*2*pi*f*R*C);;

    gain_l = abs(H);
    phi_l = angle(H);
end;

R = 10e3;
f_cut = 500;
f = [0, freq_l1];

[H, gain_l, phi_l, C] = HLowPass(f, f_cut, R);
disp(C);

figure(3);
subplot(2,1,1);
plot(f, gain_l);

subplot(2,1,2);
plot(f, phi_l);

% bruk filterer på findAandBs
filterd_amp_l = gain_l.*[dc, amp_l];
filterd_phi_l = phi_l+ [0, phi_l1];
figure(4);
stem(f, filterd_amp_l);
stem(f, filterd_amp_l);

function [t, out]  = getFilterdTimeDomainFromFindAandBsOnePeriode(f,filterd_amp_l, phi_l, pds, dp)
    % bruker x(t) = amp*cos(2*pi*f_n*t + phi) for å starte med
    T = 1/f(2);
    dt = (pds*T)/dp;

    t = 0:dt:(pds*T-dt);
    out =[]
    for t_d=t;
        out = [ out, sum( filterd_amp_l .* cos(2*pi*f*t_d + phi_l )) ];
    end;
end;


[t, out] = getFilterdTimeDomainFromFindAandBsOnePeriode(f, filterd_amp_l, filterd_phi_l, 3,200);
disp(out(20));

figure(5);
plot(t, out);
ylim([-.2, A+.2])