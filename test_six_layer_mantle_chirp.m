%Experiment for six mantle layers.
clear all
close all

%% Consistent layer thickness, variable epsilons & d

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
D                       = [0.1:0.01:3]';
DD                      = length(D);

%produce arrays to fill with RTA results:
R                       = ones(DD,NN).*NaN;
T                       = ones(DD,NN).*NaN;
A                       = ones(DD,NN).*NaN;

for dd=1:DD;
    d                   = ones(6,1).*D(dd);
    for nn=1:NN;
        e2n                 = eps2(nn);
        e3n                 = eps3(nn);
        eps                 = [eps1;e2n;e3n;e2n;e3n;e2n;e3n;eps8];
        [R(dd,nn),T(dd,nn),A(dd,nn)] = multi_layer_chirp(d,eps,mu,radar_chirp,theta,pol);
    end
end

i2                      = find(D==2);
i7                      = find(real(eps2)==7);

figure
plot(real(eps2-eps3),R(i2,:));
ylabel('Reflectivity, dB');
xlabel('Dielectric Constant Mantle 1');
%ax1 = gca; % current axes
%ax1_pos = ax1.Position; % position of first axes
%ax2 = axes('Position',ax1_pos,...
 %'XAxisLocation','top',...
  %  'YAxisLocation','right',...
   % 'Color','none');

figure
surf(real(eps2-eps3),6*D,R,'EdgeColor','None');
colormap(jet)
view(2);
xlabel('Dielectric Constant');
ylabel('Debris Layer Thickness, m');
colorbar

figure
plot(6.*D,R(:,i7));
ylabel('Reflectivity, dB');
xlabel('Debris Layer Thickness, m');