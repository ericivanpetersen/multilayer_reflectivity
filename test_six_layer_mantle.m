%Experiment for six mantle layers.
clear all
%close all

%% Consistent layer thickness, variable epsilons & d

%Setting up the problem
eps1                    = 1; %Air
eps8                    = 3.15; %Basement = pure glacier ice
mu                      = ones(8,1); %Relative permeability = 1
freq                    = 2e7; %20 MHz
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
        [R(dd,nn),T(dd,nn),A(dd,nn)] = multi_layer_rta(d,eps,mu,freq,theta,pol);
    end
end

i2                      = find(D==2);
i7                      = find(real(eps2)==7);

figure(1)
hold on
plot(real(eps3),R(i2,:));
ylabel('Reflectivity, dB');
xlabel('Dielectric Constant, Layer 2');
%ax1 = gca; % current axes
%ax1_pos = ax1.Position; % position of first axes
%ax2 = axes('Position',ax1_pos,...
 %'XAxisLocation','top',...
  %  'YAxisLocation','right',...
   % 'Color','none');

figure
surf(real(eps3),6*D,R,'EdgeColor','None');
colormap(jet)
view(2);
xlabel('Dielectric Constant');
ylabel('Debris Layer Thickness, m');
colorbar

figure(3)
hold on
plot(6.*D,R(:,i7));
ylabel('Reflectivity, dB');
xlabel('Debris Layer Thickness, m');

%% Adding in an "original glacial debris layer"
clear all

%Setting up the problem
eps1                    = 1; %Air
eps9                    = 3.15; %Basement = pure glacier ice
eps8                    = 9; %Arbitrary dielectric constant of glacial debris
d8                      = 3; %Arbitrary 3 m thick debris
mu                      = ones(9,1); %Relative permeability = 1
freq                    = 2e7; %20 MHz
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
    d                   = [d;d8];
    for nn=1:NN;
        e2n                 = eps2(nn);
        e3n                 = eps3(nn);
        eps                 = [eps1;e2n;e3n;e2n;e3n;e2n;e3n;eps8;eps9];
        [R(dd,nn),T(dd,nn),A(dd,nn)] = multi_layer_rta(d,eps,mu,freq,theta,pol);
    end
end

i2                      = find(D==2);
i7                      = find(real(eps2)==7);

figure
plot(real(eps3),R(i2,:));
ylabel('Reflectivity, dB');
xlabel('Dielectric Constant Mantle 1');
%ax1 = gca; % current axes
%ax1_pos = ax1.Position; % position of first axes
%ax2 = axes('Position',ax1_pos,...
 %'XAxisLocation','top',...
  %  'YAxisLocation','right',...
   % 'Color','none');

figure
surf(real(eps3),6*D+d8,R,'EdgeColor','None');
colormap(jet)
view(2);
xlabel('Dielectric Constant');
ylabel('Debris Layer Thickness, m');
colorbar

figure
plot(6.*D+d8,R(:,i7));
ylabel('Reflectivity, dB');
xlabel('Debris Layer Thickness, m');
