pkg load signal;

f = .5;
f_s = 2000*f;
dt = 1/f_s;
t = 0:dt:(2*10);

w = 2*pi*f;
a = sin(w*t);

x = ifelse(2*sin(w*t) < 0, -1, 1);

h = fir1(1000, (f/f_s)*.5);
b = [0,0];
xb = [0,4];

disp(length(x));
disp(length(h));

hfft = fft(h, length(h));

y = conv(x,h, "same");
subplot(5,1,1);
plot(t,x,"b");
subplot(5,1,2);
plot(t,y,"b", xb, b, "r");
subplot(5,1,3);
plot(t,a,"b", xb, b, "r");
subplot(5,1,4);
plot(0:1/length(h):(1-1/length(h)),h,"b");
subplot(5,1,5);
plot(0:1/length(h):(1-1/length(h)),abs(hfft),"b");
