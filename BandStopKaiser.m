
%EN2570 Digital Signal Processing − Project clear all;
close all;
%K.G.G.L.A. de Silva %150103P
%Last Updated : 2017 Nov 10
% Get A,B,C in 150ABC (index)
indexNo = str2double(inputdlg(’Enter Index Number’, ’Index Number’,1)); C = mod(indexNo,10) ;
B = mod( floor (indexNo/10) ,10) ;
A = mod( floor (indexNo/100) ,10) ;
%A=1;B=0;C=3; %Calculate the paramteres
Ap=0.05+(0.01*A); Aa = 40 + B;
Omega_p1 Omega_p2 Omega_a1 Omega_a2 Omega_s
%Compute
= C*100 + 300;
= C*100 + 850;
= C*100 + 400;
= C*100 + 700;
= 2*(C*100 + 1200);
the transition width, cut off freqeuncies and sampling period
Bt = min((Omega_a1 − Omega_p1) ,(Omega_p2 − Omega_a2) ) ; Omega_c1 = Omega_p1 + Bt/2;
Omega_c2 = Omega_p2 − Bt/2;
T = 2*pi / Omega_s;
%Compute delta value
40
41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82
delta_p = (10^(0.05*Ap) − 1) /(10^(0.05*Ap) + 1) ; ;
delta = min(delta_p,delta_a); %Compute actual stop band attenuation
Aaa = −20*log10(delta); %Choose Parameter alpha
if Aaa <= 21 alpha = 0;
delta_a =
10^(−0.05*Aa)
elseif (21 < Aaa) && (Aaa <= 50)
alpha = 0.5842*(Aaa−21)^0.4 + 0.07886*(Aaa−21);
else
alpha = 0.1102*(Aaa−8.7); end
%Choose parameter D
if Aaa <= 21
D = 0.9222;
else
D = (Aaa − 7.95) /14.36; end
%Select N
if mod(ceil(Omega_s*D/Bt + 1),2) == 1 N = ceil(Omega_s*D/Bt + 1);
else
N = ceil (Omega_s*D/Bt + 1) + 1;
end
%Compute and plot the Window function
range2 = (N−1)/2;
n = −range2 : 1 : range2;
beta = alpha*(1 − (2*n/(N−1)) .^2) .^0.5;
I_beta = 0; I_alpha = 0; for k = 1 : 100
I_beta = I_beta + ((1/factorial(k))*(beta/2).^k).^2;
I_alpha = I_alpha + ((1/factorial(k))*(alpha/2)^k)^2;
end

I_beta = I_beta + ones(1,numel(I_beta)); I_alpha = I_alpha + ones(1,numel(I_alpha));
w = I_beta ./ I_alpha ;
figure;stem(n,w,’fill ’); xlabel(’n’);ylabel(’w[n]’);title(’Windowing Function’); grid on;
%Compute and plot h[n]
range1 = (N−1)/2;
n1 =−range1 : 1 : −1;
h1 = ((1/pi)./n1).*(sin(Omega_c1*T.*n1) − sin(Omega_c2*T.*n1)); h0 = 1 + 2*(Omega_c1 − Omega_c2)/Omega_s;
n2=1 : 1 : range1;
h2 = ((1/pi)./n2).*(sin(Omega_c1*T.*n2) − sin(Omega_c2*T.*n2)); h = [h1,h0,h2];
n = [n1,0,n2];
figure;stem(n,h,’fill’);grid on; xlabel(’n’);ylabel(’h[n]’);title(’Impulse Response of Ideal Bandstop
Filter’);
%Compute the f i l t e r respone
h_filter = h.*w;
%subplot(1,2,1);
stem(n, h_filter ) ;
xlabel(’n’);ylabel(’h[n]’);title(’Impulse Response of Non Causal Filter’
);grid on; n_shifted = [ 0 : 1 :N−1];
%subplot(1,2,2);
stem(n_shifted,h_filter ,’fill ’); xlabel(’n’);ylabel(’h[n]’);title(’Impulse Response of Causal Filter’);
grid on;
%Magnitude Response of the
fvtool ( h_filter ) ; freqz(h_filter);
%generate the excitation

n=0:1:300;
L = numel(n) ;
x = sin(325*T*n) + sin(850*T*n) + sin(1275*T*n);
%Plot the DFT of the excitation
NFFT = 2^nextpow2(L); % Next power of 2 from length of y Y=fft(x,NFFT)/L;
f = (Omega_s)/2*linspace(0,1,NFFT/2+1); figure ;
subplot (3 ,1 ,1) ;
p l o t ( f , 2 * a b s ( Y ( 1 : NFFT / 2 + 1 ) ) ) ;
title ( ’DFT of Excitation ’) xlabel( ’Frequency (rad/s) ’) ylabel(’|X(f)|’);grid on;
%Plot the DFT of filtered signal
x_f = conv(x,h_filter,’same’);
L = numel(x_f);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y Y=fft(x_f,NFFT)/L;
f = (Omega_s)/2*linspace(0,1,NFFT/2+1); subplot (3 ,1 ,2) ;
p l o t ( f , 2 * a b s ( Y ( 1 : NFFT / 2 + 1 ) ) ) ;
title ( ’DFT of Filtered Signal ’) xlabel( ’Frequency (rad/s) ’) ylabel(’|X(f)|’);grid on;
%Plot the DFT of the excitation passed through an ideal bandstop f i l t e r
x_i = sin(325*T*n) + sin(1275*T*n);
L = numel(n) ;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y Y=fft(x_i,NFFT)/L;
f = (Omega_s)/2*linspace(0,1,NFFT/2+1); subplot (3 ,1 ,3) ;
p l o t ( f , 2 * a b s ( Y ( 1 : NFFT / 2 + 1 ) ) ) ;
title ( ’DFT of Excitation Passed through an Ideal Bandstop Filter ’) xlabel( ’Frequency (rad/s) ’)
ylabel(’|X(f)|’);grid on;

168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197
198
199
%Plot the excitation in time domain
figure ;
stem ( n , x , ’ r ’ , ’ f i l l ’ ) ;
title ( ’Excitation in the Time Domain’) xlabel(’n’)
ylabel(’x[n]’);grid on;
%Plot the Filtered signal in the time domain
nl = [0:1:numel(x_f)−1];
figure ; stem(nl,x_f,’r’,’fill ’);
title ( ’Filtered Signal in the Time Domain’) xlabel(’n’)
ylabel(’x[n]’);grid on;
%Plot the Ideally Filtered signal in the time domain
figure ;
stem ( n , x _ i , ’ r ’ , ’ f i l l ’ ) ;
title ( ’Ideally Filtered Signal in the Time Domain’) xlabel(’n’)
ylabel(’x[n]’);grid on;
%Validation using the designfilt function
HpFilt = designfilt(’bandstopfir’,’PassbandFrequency1’,600, ... ’ StopbandFrequency1 ’ , 7 0 0 , ’ StopbandFrequency2 ’ , 1 0 0 0 , ’
PassbandFrequency2’,1150,’PassbandRipple1’,0.06, ... ’StopbandAttenuation ’ ,40 , ’PassbandRipple2 ’ ,0.06 , ’DesignMethod
’ , ’ kaiserwin ’ , ’SampleRate ’ ,3000) ; fvtool(HpFilt);
