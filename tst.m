x1 = [4, -1, 0, 5, 0];
x2 = [6, -1, 7, -1, 1];
x3 = [-4, 3, 2, 1, 0];

x4 = x2+x3

x_conv1 = conv(x1, x4);
disp(x_conv1);

x_conv2 = conv(x1, x2) + conv(x1, x3);
disp(x_conv2);

#diff
disp(x_conv1 - x_conv2);

######################
x1 = [2, 3, -1];
h = [1, 3, 2];

y = conv(x1, h);
disp(y);

pkg load signal; % signal-pakken må evt lades
close all; clear all; clc; format long;
b=[1 3 2]; % b-vektor (tellerpolynom), (sml FIR-filter i oppg. 3)
a=[1 -1.6 0.64]; % a-vektor (nevnerpolynom)
nullpkt= roots(b), abs_nullpkt = abs(nullpkt)
poler = roots(a), abs_poler = abs(poler)
zplane(b,a) % Tegn evt Pol-nullpunkts-diagrammet
h=impz(b,a, 45); % Impulsrespons (de 45 første verdiene)
% figure; stem(h); % Plot evt bare implulsresponsen
x=[2 3 -1]; % Innsignal
y = conv(x,h); % Utsignal gitt av konvolusjon
y= y(1:length(h)); % Begrens lengden til det samme lengde som h[n], for plotting
% Ly = length(y) % Kontroller evt lengden på y-vektor
figure; hold on;
stem(h,'b'); stem(y,'r'); hold off;
grid; yticks([-10:5:55]);
legend('h[n] - Impulsrespons', 'y[n] - Utsignal');
y(3:length(y)) % Tar bort de to første nullene og skriver ut resultatet


xx=[10,14,2,6,8,20,1,17,14,7,15,16];
x = [zeros(1,3), xx, zeros(1,2)]; % Legger til '0-ere' i starten og slutten
% Må ha 3 '0-ere' i starten for den rekursive løsningen.
% '0-ere' kan også legges inn manuelt:
% x=[0, 0, 0, xx, 0, 0];
% a) IKKE-rekursiv løsning (utsignal y)
y = zeros(size(x));
for n=3:length(x) % kunne ha startet på n=4, første element ut som ikke er null
 y(n)=(x(n)+x(n-1)+x(n-2))/3;
end;
% b) Rekursiv løsning (utsignal yr)
yr = zeros(size(x)); % Samme lengde som y (for IKKE-rekursiv løsning)
for n=4:length(x) % Må begynne for n=4 siden vi har x(n-3)
 yr(n)=yr(n-1) + (x(n)-x(n-3))/3;
end;
% Skriv ut de to resultatene og differensen for å se at de er like
y(1:8), yr(1:8) % Skriver ut de 8 første elementene
Differens = y-yr % Noen veldig små tall viser numerisk unøyaktighet
% ----------------------------------------------------------
% Alternativt, plot resultatene ('stem') og se at de er like.
% Behøver IKKE å spesifisere x-aksen
figure;
stem(y,'b.'); title('Ikke rekursiv løsning'); grid;
xlabel('n'); ylabel('Utsignal y(n)');
figure;
stem(yr,'r.'); title('Rekursiv løsning'); grid;
xlabel('n'); ylabel('Utsignal y(n)');
% Enklere å se eventuelle forskjeller om man plotter i samme diagram
figure; hold on;
stem(y,'b.'); stem(yr,'r.'); hold off; grid;
legend('IKKE rekursiv', 'Rekursiv', 'Location','northwest');
xlabel('n'); ylabel('Utsignal');


clear all; clc; format compact;
pkg load signal; % Brukes i Octave
n = [0:63];
b = [0.02 0.04 0.08 0.12 0.15 0.16 0.15 0.12 0.08 0.04 0.02]; % FIR
x0625 = sin(0.0625*pi*n); % Diskret frekvens pi/16
y0625 = filter(b,1,x0625);
figure; hold on; grid;
stem(n, x0625, 'b'); stem(n, y0625, 'r'); yticks([-1:0.1:1]);
% set(gca, 'ytick', -1:0.05:1); % Alternativ
% Merk 'ytick' og 'yticks'
hold off;


xx = [10,14,2,6,8,20,1,17,14,7,15,16];
x = [zeros(1,3), xx, zeros(1,2)];
y = zeros(size(x));
for n = 3:length(x)
    y(n) = (x(n)+x(n-1)+x(n-2))/3;
end
yr = zeros(size(x));
for n = 4:length(x)
    yr(n) = yr(n-1) + (x(n)-x(n-3))/3;
end
disp('y = '); disp(y);
disp('yr = '); disp(yr);
disp('Differens = '); disp(y-yr);



b = [0.02 0.04 0.08 0.12 0.15 0.16 ...
0.15 0.12 0.08 0.04 0.02];


hcofs = [];

for n = 1:length(b)
    hcofs = [hcofs, exp(-1j*0.0625*pi*(-n))];
end

disp('hcofs = '); disp(hcofs);

H = [];
for n = 1:length(b)
    H(n) = sum(b.*hcofs);
end
disp('|H| = '); disp(abs(H));

    


zplane([1, 3,2], [0, 0]); % Plot poler og nuller for FIR-filteret

