% Test Multi-Layer model for a simple 3 layer model

d                   = [1:0.01:15];
eps                 = [1; 5 + 0.0057i; 3.15];
mu                  = [1; 1; 1];
freq                = 2e7; % 20 MHz
theta               = 0;
pol                 = 0;

R                   = ones(size(d)).*NaN;
T                   = ones(size(d)).*NaN;
A                   = ones(size(d)).*NaN;

DD                  = length(d);
for dd=1:DD;
    [R(dd),T(dd),A(dd)]     = multi_layer_rta(d(dd),eps,mu,freq,theta,pol);
end

figure
plot(d,R);
ylabel('Reflectivity');
xlabel('Debris Layer Thickness, m');

%%
radar_chirp                 = csvread('./Chirp_m05tx_m20rx.csv');

R_ch                   = ones(size(d)).*NaN;
T_ch                   = ones(size(d)).*NaN;
A_ch                   = ones(size(d)).*NaN;

DD                  = length(d);
for dd=1:DD;
    [R_ch(dd),T_ch(dd),A_ch(dd)]     = multi_layer_chirp(d(dd),eps,mu,radar_chirp,theta,pol);
end

figure(3)
hold on
plot(d,R_ch);
ylabel('Reflectivity, dB');
xlabel('Debris Layer Thickness, m');


