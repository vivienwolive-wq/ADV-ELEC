
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
scl=3
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
		N_slo_s=180;
% 	-- Tooth pitch
      op_t_s=2*pi/Npart/N_slo_s;        % in rad


% ------------------------------------------------
% -- Stator slot characteristics
% ------------------------------------------------

	w1_s =  6.5 ;   % --Isthmus opening in mm
	w2_s =  10 ; %--Low side slot opening in mm
	w3_s =  10 ;% -High side slot opening in mm

	h1_s  =  2 ; %-- Isthmus height in mm
	h2_s  =  10  ;%-- Base height in mm
	h3_s  = 30  ;% -- Main height in mm
                                         
    % if you want to compare your analytic and the computed slot surface
    % you can uncomment the folowing line
    %S_slo=(pi*(w3_s/2)^2)/2+w3_s*h3_s+w1_s*h1_s+(w1_s+w2_s)*h2_s/2;
% ------------------------------------------------
% -- Rotor characteristics
% ------------------------------------------------

   Npoles =20; % Number of poles
   thi_mag=9.6; % Thickness of the magnets
   p=Npoles/2; % Number of pairs of poles
   Nseg  =6;   % Number of magnet segmentations 
   % Percentage of magnet over a pole pitch in degres and in rad
   op_mag_deg=15 ;    op_mag=op_mag_deg*pi/180; 
   


% ------------------------------
% -- Radius
% ------------------------------
	Re   = 650.0;
	Ra   = 572.95;
    airgap=3;
	Rr   = Ra-airgap-thi_mag;
    Ri   = 380.0;


Nturns=2; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Connectivity matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

   
       Mat_C1=[2 2 1 0 0 0 0 0 -1 -2 -2 -1 0 0 0 0 0 1
               0 0 0 0 0 1 2 2 1 0 0 0 0 0 -1 -2 -2 -1  
               0 0 -1 -2 -2 -1 0 0 0 0 0 1 2 2 1 0 0 0 ]; 
Mat_C=[Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1 Mat_C1];
