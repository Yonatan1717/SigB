% Innlevering 7: numerisk kontroll av alle hovedsvar.
% Matlab/Octave uten ekstra toolbox. Beregningene bruker full presisjon.
Q = @(x) 0.5*erfc(x/sqrt(2));

% 1: ideell minste Nyquist-båndbredde for binær overføring.
Rb1 = 1/(62e-6);
B1 = Rb1/2;
fprintf('1: Rb = %.9f bit/s, Bmin = %.9f Hz\n', Rb1, B1);

% 2: Shannon + Nyquist, med fast symbolrate 2B i del b.
B2 = 3100;
SNR2 = 10^(36/10);
C2 = B2*log2(1+SNR2);
k2_teor = C2/(2*B2);
M2_teor = 2^k2_teor;
k2 = floor(k2_teor);
M2 = 2^k2;
Rb2 = 2*B2*k2;
fprintf('2a: C = %.9f bit/s, Mteor = %.9f\n', C2, M2_teor);
fprintf('2b: k = %d, M = %d, Rb = %.9f bit/s\n', k2, M2, Rb2);

% 3: unngå nulløsningen ved å bruke den positive rotens intervall.
gamma3 = 10^(-0.45/10);
f = @(eta) (2.^eta-1)./eta-gamma3;
eta3 = fzero(f, [0.7 0.75]);
C3 = 3100*eta3;
fprintf('3: eta = %.9f bit/s/Hz, C = %.9f bit/s\n', eta3, C3);

% 4.
B4 = 56000/log2(1+10^(-7/10));
fprintf('4: Bmin = %.9f Hz\n', B4);

% 5.
eta5 = 3.75;
SNR5 = 2^eta5-1;
gamma5 = SNR5/eta5;
fprintf('5: SNR = %.9f dB, Eb/N0 = %.9f dB\n', ...
        10*log10(SNR5), 10*log10(gamma5));

% 6.
Rb6 = 2*35000/(1+0.65);
fprintf('6: Rb = %.9f bit/s\n', Rb6);

% 7.
B7 = 6400*(1+0.55)/2;
Rb7 = 2*B7/(1+0.15);
increase7 = 100*(Rb7/6400-1);
fprintf('7: B = %.9f Hz, Rb = %.9f bit/s, økning = %.9f %%\n', ...
        B7, Rb7, increase7);

% 8: antipodal NRZ. Qinv finnes fra erfcinv, ikke 1/Q.
x8 = sqrt(2)*erfcinv(2e-6);
gamma8 = x8^2/2;
BER8b = Q(sqrt(2*10^(11/10)));
fprintf('8a: Qinv = %.9f, Eb/N0 = %.9f = %.9f dB\n', ...
        x8, gamma8, 10*log10(gamma8));
fprintf('8b: BER = %.12g\n', BER8b);

% 9: Eb er gjennomsnittlig energi per bit, også ved unipolar NRZ.
Rb9 = 48000;
B9 = Rb9/2;
gamma9 = 10^(7.5/10);
SNR9_dB = 7.5+10*log10(Rb9/B9);
BER9c = Q(sqrt(gamma9));
BER9d = Q(sqrt(2*gamma9));
fprintf('9a,b: SNR = %.9f dB, Bmin = %.9f Hz\n', SNR9_dB, B9);
fprintf('9c: BER = %.12g, feil/s = %.9f\n', BER9c, Rb9*BER9c);
fprintf('9d: BER = %.12g, feil/s = %.9f\n', BER9d, Rb9*BER9d);

assert(abs(B1-8064.516129032258) < 1e-6);
assert(abs(C2-37073.84080256372) < 1e-6);
assert(k2 == 5 && M2 == 32 && Rb2 == 31000);
assert(abs(eta3-0.7280100012025266) < 1e-7);
assert(abs(B4-213362.01964076664) < 1e-5);
assert(abs(10*log10(SNR5)-10.95320809865969) < 1e-7);
assert(abs(10*log10(gamma5)-5.212895421382501) < 1e-7);
assert(abs(Rb6-42424.242424242424) < 1e-6);
assert(abs(Rb7-8626.08695652174) < 1e-6);
assert(abs(gamma8-11.297521329854225) < 1e-7);
assert(abs(BER8b-2.6130679535751897e-7) < 1e-12);
assert(abs(SNR9_dB-10.510299956639813) < 1e-7);
assert(abs(BER9c-0.008861051096347857) < 1e-9);
assert(abs(BER9d-0.0003987963351591626) < 1e-10);
fprintf('Alle numeriske kontroller bestått.\n');
