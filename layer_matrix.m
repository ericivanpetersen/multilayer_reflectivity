function [ matrix ] = layer_matrix(d,eps,mu,freq,theta,polarization)

%This function calculates the matrix for an individual layer to calculate
%the reflectivity/trasmissivity/absorptivity of a multi-layer packet using
%the matrix method.

%d = layer thickness
%eps = relative complex dielectric permittivity of the layer 
%mu = relative magnetic permeability of the layer
%freq = frequency of the radar (s^-1)
%theta = incidence angle in degrees
%polarization = 0 if TE (Transverse Electric), 1 if TM (Transverse
%   Magnetic)

%constants
eps_0               = 8.854187817e-12; %vacuum permittivity
mu_0                = 4*pi*10^-7; %vacuum permeability

Y                   = sqrt((eps.*eps_0)/(mu.*mu_0)); %admittance
gamma               = i * 2.* pi .* freq * sqrt( (eps.*eps_0) .* (mu.*mu_0)); %propogation constant
%tilted admittance:
if polarization == 0;
    eta             = Y .* cosd(theta);
elseif polarization == 1;
    eta             = Y ./ cosd(theta);
end
delta               = i .* gamma .* d .* cosd(theta);

%matrix elements
m11                 = cos(delta);
m12                 = (i./eta) .* sin(delta);
m21                 = i .* eta .* sin(delta);
m22                 = cos(delta);

matrix              = [ m11 , m12; m21, m22 ];

end

