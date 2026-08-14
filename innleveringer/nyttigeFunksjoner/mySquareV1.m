function [t, out] = mySquareV1(t, f0, d_c, bds=[-1,1], pds=0, cent=false)
    % MYSQUAREV1 Genererer en firkantpuls ved bruk av fase og modulo.
    %
    %   [t, out] = mySquareV1(t, f0, d_c)
    %   [t, out] = mySquareV1(t, f0, d_c, bds, pds, cent)
    %
    % INPUT:
    %   t     - Tidsvektor [s].
    %   f0    - Fundamentalfrekvens [Hz].
    %   d_c   - Duty cycle [%].
    %   bds   - Amplitudenivåer [lav, høy]. Standard: [-1, 1].
    %   pds   - Antall perioder som skal brukes.
    %           pds = 0 bruker hele tidsvektoren. Standard: 0.
    %   cent  - Hvis true sentreres den positive pulsen rundt origo.
    %           Standard: false.
    %
    % OUTPUT:
    %   t     - Tidsvektor skalert til millisekunder [ms].
    %   out   - Generert amplitudeverktor.
    %
    % EKSEMPEL:
    %   [t, y] = mySquareV1(0:1e-6:1e-3, 10e3, 50);
    %
    % Funksjonen uttrykker signalets fase i radianer og bruker
    % modulo 2*pi for å generere den periodiske firkantpulsen.

    T = 1/f0;

    if pds != 0
        t_stop = T*pds;
        idx = find(t >= t_stop, 1)-1;
        t = t(1:idx);
    end
        
    d_c = d_c/100;
    rads = t*2*pi*f0;

    if cent
        rads = t*2*pi*f0 + (2*pi*d_c)/2;
    end

    pulse_end_rad = 2*pi*d_c;
    n_rad = mod(rads, 2*pi);

    out = n_rad;
    out(n_rad >= pulse_end_rad) = bds(1);
    out(n_rad < pulse_end_rad) = bds(2);

    t = t*1e3;   % Skaler til ms
end