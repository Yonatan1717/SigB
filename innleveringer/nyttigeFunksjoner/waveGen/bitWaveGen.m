function [t, out] = bitWaveGen(bits, T, spp, sh=0)
    % BITWAVEGEN Genererer et binært signal fra en bitsekvens.
    %
    %   [t, out] = bitWaveGen(bits, T, spp)
    %   [t, out] = bitWaveGen(bits, T, spp, sh)
    %
    % INPUT:
    %   bits - Vektor med bits, for eksempel [1, 0, 1, 0].
    %   T    - Bittid [s].
    %   spp  - Samples per bit.
    %   sh   - Tidsforskyvning [% av bittiden].
    %          Forskyvningen tilsvarer T*(sh/100).
    %          Standard: 0.
    %
    % OUTPUT:
    %   t    - Tidsvektor skalert til millisekunder [ms].
    %   out  - Generert amplitudevektor med verdiene 0 og 1.
    %
    % EKSEMPEL:
    %   bits = [1, 0, 1, 0];
    %   [t, y] = bitWaveGen(bits, 1e-3, 100, 50);
    %
    % Funksjonen lager spp samples for hver bit og kan forskyve
    % signalet med en gitt prosentandel av bittiden.

    dt = T/spp;
    pds = length(bits);
    sh_num = round(spp*(sh/100));

    t = 0:dt:(T*pds-dt);

    first = bits(1);
    out = [];

    for i = 1:pds
        if i == 1
            out = [out, addZerosOrOnes(bits(i), spp-sh_num)];
        else
            out = [out, addZerosOrOnes(bits(i), spp)];
        end
    end

    out = [out, addZerosOrOnes(first, sh_num)];

    t = t*1e3;   % Skaler til ms
end