% Innlevering 7, oppgave 3: båndbreddeeffektivitet ved Shannon-grensen.
% Beregn positiv løsning; eta = 0 gir ingen informasjonsoverføring.
gamma_b = 10^(-0.45/10);
f = @(eta) (2.^eta-1)./eta - gamma_b;
eta_max = fzero(f, [0.7 0.75]);
C = 3100*eta_max;
fprintf('eta_max = %.9f bit/s/Hz\n', eta_max);
fprintf('C = %.9f bit/s\n', C);

% Samme figur som er inkludert i besvarelsen.
eta = linspace(0.001, 1.5, 1000);
gamma_limit_dB = 10*log10((2.^eta-1)./eta);
figure('Color', 'w');
plot(eta, gamma_limit_dB, 'b', 'LineWidth', 1.5);
hold on;
plot([0 1.5], [-0.45 -0.45], '--', 'Color', [0.5 0.5 0.5]);
plot(eta_max, -0.45, 'ro', 'MarkerFaceColor', 'r');
hold off;
grid on;
xlim([0 1.5]);
xlabel('\eta = C/B [bit/s/Hz]');
ylabel('E_b/N_0 [dB]');
legend('Shannon-grensen', 'Tilgjengelig E_b/N_0', ...
       'Maksimal effektivitet', 'Location', 'northwest');
base = fileparts(mfilename('fullpath'));
media = fullfile(base, '..', 'Media');
if ~exist(media, 'dir'), mkdir(media); end
print(fullfile(media, 'grapf1.png'), '-dpng', '-r300');
