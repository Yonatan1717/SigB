function [mag_l, phi_l, freq_l, c_l, mag_min_max, phi_min_max] = findCns(func, T, num_coffs, dp)
    % FINDCNS Beregner komplekse Fourier-koeffisienter c_n.
    %
    %   [mag_l, phi_l, freq_l, c_l, mag_min_max, phi_min_max] = ...
    %       findCns(func, T, num_coffs, dp)
    %
    % INPUT:
    %   func       - Funksjonshåndtak til signalet, f.eks. @myFunc.
    %   T          - Signalets periode [s].
    %   num_coffs  - Antall positive og negative harmoniske som beregnes.
    %   dp         - Antall datapunkter som brukes over én periode.
    %
    % OUTPUT:
    %   mag_l         - Magnituden |c_n|.
    %   phi_l         - Fasen til c_n [rad].
    %   freq_l        - Frekvensene fra -num_coffs/T til +num_coffs/T [Hz].
    %   c_l           - De komplekse Fourier-koeffisientene c_n.
    %   mag_min_max   - [min(mag_l), max(mag_l)].
    %   phi_min_max   - [min(phi_l), max(phi_l)].
    %
    % EKSEMPEL:
    %   [mag, phi, f, c, mag_mm, phi_mm] = ...
    %       findCns(@myFunc, 8e-3, 20, 400);
    %
    % Koeffisientene beregnes numerisk som
    %
    %   c_n = (1/T) * integral(x(t)*exp(-j*n*w_0*t), 0, T)
    %
    % for n = -num_coffs : num_coffs.
    %
    % Samplepunktene plasseres midt i hvert intervall for å redusere
    % numeriske feil ved diskontinuerlige signaler.

    l = num_coffs;
    n = -l:l;
    w_0 = (2*pi)/T;

    dt = T/dp;
    t = ((0:dp-1) + 0.5)*dt;

    c_l = [];
    freq_l = [];

    for i = n
        y1 = func(t).*exp(-j*w_0*i*t);
        coff_c = mean(y1);

        c_l = [c_l, coff_c];
        freq_l = [freq_l, i/T];
    end

    mag_l = abs(c_l);

    % Del opp i real- og imaginærdel og fjern svært små
    % numeriske avrundingsfeil før fase beregnes.
    tol = 1e-12;

    a = real(c_l);
    b = imag(c_l);

    a(abs(a) < tol) = 0;
    b(abs(b) < tol) = 0;

    phi_l = atan2(b, a);

    % Fase er ikke definert når magnituden er tilnærmet null.
    lim = max(mag_l)*1e-6;
    phi_l(mag_l < lim) = 0;

    mag_min_max = [min(mag_l), max(mag_l)];
    phi_min_max = [min(phi_l), max(phi_l)];
end
