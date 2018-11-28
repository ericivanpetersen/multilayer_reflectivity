function [R,T,A] = multi_layer_chirp(d,eps,mu,radar_chirp,theta,polarization)
%Incorporate Chirp into multi-layer reflectivity model

%d = layer thicknesses (length of the number of intermediate layers N)
%eps = relative complex dielectric permittivity of the layer (length of all
%layers, including "air" and substrate, i.e. N+2)
%mu = relative magnetic permeability of the layer (length N+2)
%radar_chirp = two columns, column 1 = frequency of the radar (s^-1)
%                       column 2 = spectral value, can be complex
%theta = incidence angle in degrees
%polarization = 0 if TE (Transverse Electric), 1 if TM (Transverse
%   Magnetic)

freq                        = radar_chirp(:,1);
spect                       = abs(radar_chirp(:,2))./sum(abs(radar_chirp(:,2)));

FF                          = length(freq);
RR                          = ones(FF,1).*NaN;
TT                          = RR;
AA                          = RR;

for ff=1:FF;
    [RR(ff),TT(ff),AA(ff)] = multi_layer_rta(d,eps,mu,freq(ff),theta,polarization);
end

R                           = 10.*log10( spect' * 10.^(RR./10) );
T                           = 10.*log10( spect' * 10.^(TT./10) );
A                           = 10.*log10( spect' * 10.^(AA./10) );
%R                           = spect' * RR;
%T                           = spect' * TT;
%A                           = spect' * AA;

end

