function deg = radToDeg(rad)
    % RADTODEG Konverterer en vinkel fra radianer til grader.
    %
    %   deg = radToDeg(rad)
    %
    % INPUT:
    %   rad  - Vinkel eller vektor/matrise med vinkler [rad].
    %
    % OUTPUT:
    %   deg  - Vinkel eller vektor/matrise med vinkler [deg].
    %
    % EKSEMPEL:
    %   deg = radToDeg(pi/2);
    %
    % Dette gir:
    %
    %   deg = 90

    deg = rad.*(180/pi);
end
