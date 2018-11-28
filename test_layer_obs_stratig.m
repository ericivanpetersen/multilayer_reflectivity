% Calculate reflectivity of model based on observed stratigraphy
clear all
close all

%Setting up the problem
eps1                    = 1; %Air
eps8                    = 3.15; %Basement = pure glacier ice
mu                      = ones(8,1); %Relative permeability = 1
radar_chirp             = csvread('./Chirp_m05tx_m20rx.csv');
theta                   = 0; %nadir
pol                     = 0; %polarization

%Parameter space for epsilons of layers
eps2                    = [5:0.01:7.5]'+0.0057i;
eps3                    = flipud([2.5:0.01:5]')+0.0057i;
NN                      = length(eps2);
%parameter space for thickness of layers:

%produce arrays to fill with RTA results:
R                       = ones(NN,1).*NaN;
R2                      = R;
T                       = ones(NN,1).*NaN;
T2                      = T;
A                       = ones(NN,1).*NaN;
A2                      = A;

d                       = 	[1.7;1.8;1.9;2.6;1.8;2];
d2                      = ones(6,1).*2;

for nn=1:NN;
        e2n                 = eps2(nn);
        e3n                 = eps3(nn);
        eps                 = [eps1;e2n;e3n;e2n;e3n;e2n;e3n;eps8];
        [R(nn),T(nn),A(nn)] = multi_layer_chirp(d,eps,mu,radar_chirp,theta,pol);
        [R2(nn),T2(nn),A2(nn)] = multi_layer_chirp(d2,eps,mu,radar_chirp,theta,pol);
end

figure
plot(real(eps2-eps3),R,real(eps2-eps3),R2);
ylabel('Reflectivity, dB');
xlabel('\epsilon''_{1}-\epsilon''_{2}');
legend('Measured Stratigraphy','Each Layer = 2 m','location','northwest');