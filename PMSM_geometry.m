% ------------------------------------
% --  Permanent magnet machine
% ------------------------------------
global_values;

% ------------------------------------------
% -- Relative permeabilities
% ------------------------------------------
mu_air=1;
mu_cag=1;
mu_wed=1;
mu_sta=1000;
mu_rot=1000;
mu_win=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Meshing size definition         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
scl=3;
%Area thickness coefficients
        thi_sta      =  1*scl;
        thi_slo      =  0.8*scl;
        thi_rot      =  3*scl;
        thi_ag      =  0.5*scl;
        thi_wed      =  0.8*scl;
        thi_hub      =  10.2*scl;
        thi_mag      =  0.8*scl;
        
% ---------------------------------------
% -- Geometric parameters
% ---------------------------------------
        Npart=1; % We are studiying a complete machine (keep 1)
% 	-- Slot number 
		N_slo_s=30;  % From Excel: 24 slots
% 	-- Tooth pitch
      op_t_s=2*pi/Npart/N_slo_s;        % in rad


% ------------------------------------------------
% -- Stator slot characteristics - UPDATED
% ------------------------------------------------

	w1_s =  4 ;   % --Isthmus opening in mm
	w2_s =  10 ;  % --Low side slot opening in mm (your selected width)
	w3_s =  10;  % --High side slot opening in mm

	h1_s  =  2 ;  % --Isthmus height in mm
	h2_s  =  3 ;  % --Base height in mm
	h3_s  =  15; % --Main height in mm (your selected total height = 29.5 mm)
                                         
    % Slot surface area calculation
    S_slo=(pi*(w3_s/2)^2)/2+w3_s*h3_s+w1_s*h1_s+(w1_s+w2_s)*h2_s/2;
    
% ------------------------------------------------
% -- Rotor characteristics
% ------------------------------------------------

   Npoles =4; % Number of poles - From Excel: 4 poles
   thi_mag=3.4; % Thickness of the magnets - From Excel: 3.4 mm
   p=Npoles/2; % Number of pairs of poles
   Nseg  =6;   % Number of magnet segmentations 
   % Percentage of magnet over a pole pitch in degres and in rad
   op_mag_deg=80 ;    op_mag=op_mag_deg*pi/180;  % From Excel: 80° magnet coverage
   

% ------------------------------
% -- Radius
% ------------------------------
	Re   = 300.0;  % Max radius = 300mm (600mm diameter / 2)
	Ra   = 350/2;    % Bore radius = 225mm (450mm diameter / 2)
    airgap=3;    % From Excel: 0.8 mm air gap
	Rr   = Ra-airgap-thi_mag;  % Rotor radius
    Ri   = 100.0;  % Inner radius

Nturns=6;  % From Excel: 11 turns per coil

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Connectivity matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
   
     Mat_C1=[2 2 1 0 0 0 0 -1 -2 -2 0 0 0 0 0 2 2 1 0 0 0 0 -1 -2 -2 0 0 0 0 0
               0 0 0 0 0 2 2 1 0 0 0 0 -1 -2 -2 0 0 0 0 0 2 2 1 0 0 0 0 -1 -2 -2
               0 0 -1 -2 -2 0 0 0 0 0 2 2 1 0 0 0 0 -1 -2 -2 0 0 0 0 0 2 2 1 0 0
];
Mat_C=[Mat_C1];
