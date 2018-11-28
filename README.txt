Code to calculate Reflectivity, Transmissivity, and Absorptivity (RTA)
of an N-layered material.

Major Functions to Use:
multi_layer_rta( d, eps, mu, freq, theta, polarization )
	Returns Reflectivity, Transmissivity, Absorptivity of layer packet
	d = layer thicknesses, length N where N is number of layers
	eps = layer relative complex permittivity
	mu = layer relative magnetic permeability
	NOTE: eps, mu can be any length N+2, where N is number of layers;
		they must be same length however.
	ALSO: first and last layers in eps, mu are the "top" and "bottom" 
		layers above and below your layer packet
	freq = EM frequency in Hz
	theta = incidence angle
	polarization: 0 = Transverse Electric, 1 = Transverse Magnetic
		(Doesn't matter if nadir [theta = 0])
multi_layer_chirp( d, eps, mu, radar_chirp, theta, polarization)
	Same as multi_layer_rta but integrates over radar chirp. Uses
		multi_layer_rta

Secondary Functions:
layer_matrix
	-Used by multi_layer_rta to calculate matrix for individual
	layers.

Test Functions are also available to illustrate usage.
