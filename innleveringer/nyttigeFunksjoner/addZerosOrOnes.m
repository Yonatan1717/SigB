function y = addZerosOrOnes(x, num)
    % ADDZEROSORONES Genererer en vektor med enten nuller eller enere.
    %
    %   y = addZerosOrOnes(x, num)
    %
    % INPUT:
    %   x   - Bestemmer verdien i vektoren.
    %         x = 0 gir nuller, ellers gis enere.
    %   num - Antall elementer som skal genereres.
    %
    % OUTPUT:
    %   y   - Radvektor med num nuller eller enere.
    %
    % EKSEMPEL:
    %   y = addZerosOrOnes(1, 5);
    %   % Gir: [1 1 1 1 1]

    if x == 0
        y = zeros(1, num);
    else
        y = ones(1, num);
    end
end