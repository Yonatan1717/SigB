
a = 3;


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

function [a_0, y, t] = findA0(func, T, dp)

    dt = T/dp;
    t = 0:dt:(T-dt);
    y = func(t);

    a_0 = round((sum(y)/(length(t)))*1e3)/1e3;
end;

function [a_l, b_l, val_l, freq_l, dc, m] = findAandBs(func, T, num_coffs, dp)
    %a = integral(x(t)cos(w_0*n*t), 0, T)
    %b = integral(x(t)sin(w_0*n*t), 0, T)
    % x(t) = dc + a_n*cos(w_0*n*t)

    n = 0:num_coffs;
    w_0 = (2*pi)/T;

    dt = T/dp;
    t = 0:dt:(T-dt);
    
    a_l = [];
    b_l = [];

    val_l = [];
    freq_l = [];
    for i=n;
        y1 = func(t).*cos(i*w_0*t);
        y2 = func(t).*sin(i*w_0*t);

        coff_a =  sum(y1)/(length(t));
        coff_b =  sum(y2)/(length(t));

        a_l = [a_l, coff_a];
        b_l = [b_l, coff_b];
        freq_l = [freq_l, (w_0*i)/(2*pi)];
    end;

    dc =  a_l(1)
    m = max([a_l, b_l])

end;

function out =  myFunc(t)
    T = 8e-3;
    A = 2;
    f0 = 1/T;
    tau = T/4;
    d_c = round((tau/T)*100);
    out = mySquareV1(t,f0, d_c, [0, A], true);
    out = sin(t*f0*2*pi);
end;

T = 8e-3;

[a_l, b_l, val_l, freq_l, dc, m] = findAandBs(@myFunc, T, 20, 125);
stem(freq_l, b_l+a_l)
ylim([-.2,m+.2])






