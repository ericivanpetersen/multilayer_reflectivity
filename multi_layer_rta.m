function [R,T,A] = multi_layer_rta(d,eps,mu,freq,theta,polarization)
%Function to calculate the Reflectivity, Transmissivity, and Absorptivity
%of a multi-layer packet via the matrix method (described in Born and Wolf
%Optics Textbook and Kenneth Pascoe's Air Force Technical Report).

%d = layer thicknesses (length of the number of intermediate layers N)
%eps = relative complex dielectric permittivity of the layer (length of all
%layers, including "air" and substrate, i.e. N+2)
%mu = relative magnetic permeability of the layer (length N+2)
%freq = frequency of the radar (s^-1)
%theta = incidence angle in degrees
%polarization = 0 if TE (Transverse Electric), 1 if TM (Transverse
%   Magnetic)

%constants
eps_0               = 8.854187817e-12; %vacuum permittivity
mu_0                = 4*pi*10^-7; %vacuum permeability

NN                  = length(d); %number of intermediate layers
matrices            = cell(NN,1); %each individual matrix

%calculate matrix for each layer 
for nn=1:NN;
    matrices{nn}                = layer_matrix(d(nn), eps(nn+1), mu(nn+1), ...
                                    freq, theta, polarization);
    %Iteratively calculate the TOTAL MATRIX!
    if nn == 1;
        MATRIX                  = matrices{nn};
    elseif nn > 1;
        MATRIX                  = MATRIX * matrices{nn};
    end
end

%define elements of TOTAL MATRIX:
m11                 = MATRIX(1,1);
m12                 = MATRIX(1,2);
m21                 = MATRIX(2,1);
m22                 = MATRIX(2,2);

Y                   = sqrt((eps.*eps_0)./(mu.*mu_0)); %admittance
%tilted admittance
if polarization == 0;
    eta             = Y .* cosd(theta);
elseif polarization == 1;
    eta             = Y ./ cosd(theta);
end

%eta of air or 1st layer and eta of substrate/final layer
eta1                = eta(1);
etaN                = eta(end);

%calculate Reflectivity:
rho                 = ( eta1.*(m11 + m12.* etaN) - (m21 + m22.*etaN) )./ ...
                       ( eta1.*(m11 + m12.* etaN) + (m21 + m22.*etaN) );
R                   = rho .* conj(rho);
%calculate Transmissivity:
tau                 = 2.*eta1 ./ ( eta1.*(m11 + m12.* etaN) + (m21 + m22 .* etaN));
T                   = real(etaN ./ eta1) .* tau .* conj(tau);
%calculate Absorptivity:
A                   = (4*eta1 * real((m11 + m12 * etaN) .* conj(m21 + m22 .*etaN)...
                        - etaN)) ./ ...
                        ((eta1 .*(m11 + m12.*etaN) + (m21 + m22.*etaN)) .* ...
                            conj(eta1 .*(m11 + m12.*etaN) + (m21 + m22.*etaN)));
                        
%convert to dB:
R                   = 10*log10(R);
T                   = 10*log10(T);
A                   = 10*log10(A);

end

