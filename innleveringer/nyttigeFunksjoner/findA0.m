function [a_0, t, y] = findA0(func, T, dp)
    % FINDA0 Beregner DC-komponenten (a_0) til et periodisk signal.
    %
    %   [a_0, t, y] = findA0(func, T, dp)
    %
    % INPUT:
    %   func  - Funksjonshåndtak til signalet, f.eks. @myFunc.
    %   T     - Signalets periode [s].
    %   dp    - Antall datapunkter som brukes over én periode.
    %
    % OUTPUT:
    %   a_0   - Signalets middelverdi / DC-komponent.
    %   t     - Tidsvektor over én periode [s].
    %   y     - Signalverdiene func(t).
    %
    % EKSEMPEL:
    %   [a0, t, y] = findA0(@myFunc, 8e-3, 400);
    %
    % Funksjonen approksimerer
    %
    %       a_0 = (1/T) * integral(x(t), 0, T)
    %
    % ved å bruke middelverdien av jevnt fordelte samplepunkter.
    % Samplepunktene plasseres midt i hvert intervall for å unngå
    % problemer dersom signalet har diskontinuiteter på intervallgrensene.

    dt = T/dp;
    t = ((0:dp-1) + 0.5)*dt;

    y = func(t);
    a_0 = mean(y);
end
