function [t, out] = mySquareV2(f0, d_c, spp, bds=[-1,1], pds=5, sh=0)
    % MYSQUAREV2 Genererer en firkantpuls direkte i tidsdomenet.
    %
    %   [t, out] = mySquareV2(f0, d_c, spp)
    %   [t, out] = mySquareV2(f0, d_c, spp, bds, pds, sh)
    %
    % INPUT:
    %   f0   - Fundamentalfrekvens [Hz].
    %   d_c  - Duty cycle [%].
    %   spp  - Samples per periode.
    %   bds  - Amplitudenivåer [lav, høy]. Standard: [-1, 1].
    %   pds  - Antall perioder som skal genereres. Standard: 5.
    %   sh   - Tidsforskyvning [% av perioden].
    %          Forskyvningen tilsvarer t + T*(sh/100).
    %          Standard: 0.
    %
    % OUTPUT:
    %   t    - Generert tidsvektor skalert til millisekunder [ms].
    %   out  - Generert amplitudevektor.
    %
    % EKSEMPEL:
    %   [t, y] = mySquareV2(10e3, 50, 100);
    %
    % Funksjonen genererer firkantpulsen ved å bruke modulo
    % av periodetiden T direkte i tidsdomenet.

    d_c = d_c/100;

    T = 1/f0;
    dt = T/spp;

    pulse_end_time = T*d_c;

    t = 0:dt:(T*pds-dt);
    t_mod = mod(t + T*(sh/100), T);

    out = t_mod;
    out(t_mod < pulse_end_time) = bds(2);
    out(t_mod >= pulse_end_time) = bds(1);

    t = t*1e3;   % Skaler til ms
end