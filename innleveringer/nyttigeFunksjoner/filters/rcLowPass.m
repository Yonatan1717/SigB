function [H, gain_l, phi_l, C] = rcLowPass(f, f_cut, R)
    % RCLOWPASS Beregner frekvensresponsen til et førsteordens RC-lavpassfilter.
    %
    %   [H, gain_l, phi_l, C] = rcLowPass(f, f_cut, R)
    %
    % INPUT:
    %   f       - Frekvens eller frekvensvektor [Hz].
    %   f_cut   - Filterets knekkfrekvens [Hz].
    %   R       - Motstandsverdi [Ohm].
    %
    % OUTPUT:
    %   H       - Kompleks frekvensrespons H(jw).
    %   gain_l  - Absoluttverdien |H(jw)|.
    %   phi_l   - Faseforskyvningen [rad].
    %   C       - Kapasitansen som gir ønsket knekkfrekvens [F].
    %
    % EKSEMPEL:
    %   f = [0, 125, 250, 375, 500];
    %   [H, gain, phi, C] = rcLowPass(f, 500, 10e3);
    %
    % Filteret beskrives av
    %
    %   H(jw) = 1 / (1 + jwRC)
    %
    % der
    %
    %   C = 1 / (2*pi*f_cut*R)

    C = 1/(2*pi*f_cut*R);

    H = 1 ./ (1 + 1j*2*pi*f*R*C);

    gain_l = abs(H);
    phi_l = angle(H);
end
