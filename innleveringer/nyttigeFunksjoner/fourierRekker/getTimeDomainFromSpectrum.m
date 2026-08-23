function [t, out] = getTimeDomainFromSpectrum(f, amp_l, phi_l, pds, dp)
    % GETTIMEDOMAINFROMSPECTRUM Rekonstruerer et reelt signal fra frekvenskomponenter.
    %
    %   [t, out] = getTimeDomainFromSpectrum(f, amp_l, phi_l, pds, dp)
    %
    % INPUT:
    %   f       - Frekvensvektor [Hz]. Første element kan være DC, f = 0.
    %   amp_l   - Amplituden til hver frekvenskomponent.
    %   phi_l   - Fasen til hver frekvenskomponent [rad].
    %   pds     - Antall perioder som skal rekonstrueres.
    %   dp      - Ønsket antall datapunkter over de valgte periodene.
    %
    % OUTPUT:
    %   t       - Tidsvektor [s].
    %   out     - Det rekonstruerte signalet.
    %
    % EKSEMPEL:
    %   f = [0, 125, 250, 375];
    %   amp = [0.5, 0.9, 0.64, 0.3];
    %   phi = [0, 0, 0, 0];
    %   [t, out] = getTimeDomainFromSpectrum(f, amp, phi, 3, 1000);
    %
    % Signalet rekonstrueres som
    %
    %   x(t) = sum(A_n*cos(2*pi*f_n*t + phi_n))
    %
    % Grunnfrekvensen hentes fra f(2), siden f(1) kan være DC-leddet.
    % Hvis den valgte tidsoppløsningen gir for lav samplingsfrekvens,
    % økes samplingsfrekvensen til minst 2.5 ganger høyeste frekvens.

    f_max = max(f);
    f0 = f(2);
    T = 1/f0;

    dt = (pds*T)/dp;
    fs = 1/dt;

    % Sørg for tilstrekkelig samplingsfrekvens for høyeste komponent.
    if (fs < 2.5*f_max)
        fs = 2.5*f_max;
        dt = 1/fs;
    end

    t = 0:dt:(pds*T - dt);
    out = zeros(size(t));

    for i = 1:length(t)
        out(i) = sum(amp_l .* cos(2*pi*f*t(i) + phi_l));
    end
end
