X = 10^(-0.45/10);
f = @(Y) (2.^Y - 1)./Y - X;
Y = fzero(f, [0.1 1]);
C = 3100*Y;
disp(["Y = ", num2str(Y)]);


function out = solve_Y(x)
    out = (2.^x - 1)./x;
end

x = 0;
while true
    Y = solve_Y(x);
    if abs(Y - X) < 1e-6
        disp(['x = ', num2str(x), ' => Y = ', num2str(Y)]);
        break;
    end
    x = x + 0.000001; % Increment x to avoid infinite loop
end