function [amp_l, phi_l, freq_l, a_l, b_l, amp_min_max, phi_min_max] = findAnandBns(func, T, num_coffs, dp)
    % FINDAANDBS Beregner trigonometriske Fourier-koeffisienter.
    %
    %   [amp_l, phi_l, freq_l, a_l, b_l, amp_min_max, phi_min_max] = ...
    %       findAnandBns(func, T, num_coffs, dp)
    %
    % INPUT:
    %   func       - Funksjonshåndtak til signalet, f.eks. @myFunc.
    %   T          - Signalets periode [s].
    %   num_coffs  - Antall harmoniske Fourier-koeffisienter som beregnes.
    %   dp         - Antall datapunkter som brukes over én periode.
    %
    % OUTPUT:
    %   amp_l         - Amplituden til hver harmoniske komponent.
    %   phi_l         - Fasen til hver harmoniske komponent [rad].
    %   freq_l        - Frekvensen til hver harmoniske komponent [Hz].
    %   a_l           - Cosinuskoeffisientene a_n.
    %   b_l           - Sinuskoeffisientene b_n.
    %   amp_min_max   - [min(amp_l), max(amp_l)].
    %   phi_min_max   - [min(phi_l), max(phi_l)].
    %
    % EKSEMPEL:
    %   [amp, phi, f, a, b, amp_mm, phi_mm] = ...
    %       findAnandBns(@myFunc, 8e-3, 20, 400);
    %
    % Fourier-koeffisientene beregnes numerisk som
    %
    %   a_n = (2/T) * integral(x(t)*cos(n*w_0*t), 0, T)
    %   b_n = (2/T) * integral(x(t)*sin(n*w_0*t), 0, T)
    %
    % og konverteres til formen
    %
    %   A_n*cos(n*w_0*t + phi_n)
    %
    % hvor
    %
    %   A_n   = sqrt(a_n^2 + b_n^2)
    %   phi_n = atan2(-b_n, a_n)
    %
    % Samplepunktene plasseres midt i hvert intervall for å redusere
    % numeriske feil ved diskontinuerlige signaler.

    n = 1:num_coffs;
    w_0 = (2*pi)/T;

    dt = T/dp;
    t = ((0:dp-1) + 0.5)*dt;

    a_l = [];
    b_l = [];
    freq_l = [];

    for i = n
        y_a = func(t).*cos(i*w_0*t);
        y_b = func(t).*sin(i*w_0*t);

        coff_a = 2*mean(y_a);
        coff_b = 2*mean(y_b);

        a_l = [a_l, coff_a];
        b_l = [b_l, coff_b];
        freq_l = [freq_l, i/T];
    end

    amp_l = sqrt(a_l.^2 + b_l.^2);

    % Fjern svært små numeriske avrundingsfeil.
    tol = 1e-12;
    a_l(abs(a_l) < tol) = 0;
    b_l(abs(b_l) < tol) = 0;

    phi_l = atan2(-b_l, a_l);

    % Fase er ikke definert når amplituden er tilnærmet null.
    lim = max(amp_l)*1e-6;
    phi_l(amp_l < lim) = 0;

    amp_min_max = [min(amp_l), max(amp_l)];
    phi_min_max = [min(phi_l), max(phi_l)];
end
