% ---------------------------------------------------------------------
% ---  This program is a simplified version of a calcul
% --   code for a Permanent Magnet Synchronous Machine (PMSM)
% --   with magnet at the rotor surface
% ------------------------------------------------------------------------

clear all ;
close all ;
clear clc ;
addpath('C:\femm42\mfiles')

shape;
openfemm
newdocument(0);

%variables statement
PHI_SLO=[];
angle_deg=[];
PHI_SLO_MAT=[];
Current_Ia=[];
Current_Ib=[];
Current_Ic=[];
Ia_sqr=[];
Ib_sqr=[];
Ic_sqr=[];
Torque=[];

% External values - FROM EXCEL SPECIFICATIONS
I=74.07; % Current - Calculated from Excel: 150kW, 750V, cosφ=0.9
Omega=209.44; % Rotation speed in rad/s - From Excel: 2000 RPM

global_values; % list of the values used in all scripts

%%%%--------------------------------
%%%% Description of the machine geometry parameters
PMSM_geometry
%%%%--------------------------------


% --*************************************************
% ------  DEFINITION OF THE PROBLEM---------------------
% --*************************************************
freq0=0; % We simulate the machine with a magnetostatic approach (keep 0)
Len=540; % Magnetic length of the machine in mm - Close to Excel: 380mm
Lu =Len*10^-3; % Magnetic length of the machine in m
mi_probdef(freq0,'millimeters','planar',1.0e-8,Len,2)% frequency , unis, geometry, precision, min angle of triangles
freq=66.67; % real frequency of the machine - From Excel: 66.67 Hz
omega=2*pi*freq; % electric pulse


% Definition of the material permeabilities  
mu_air=1;
mu_rot=1000;
mu_sta=1000;
mu_wed=1;
mu_win=1;
mu_mag=1;
% Definition of the coercive field of the chosen magnet 
Hc_mag=875000; % For NeFeB magnets as specified in Excel

% --**********************************************************
% --  DEFINITION OF THE MATERIALS   -------
% --**********************************************************

%%mi addmaterial("materialname", mu x, mu y, H c , J, Cduct, Lam d,
%%Phihmax,lam fill, LamType, Phi hx, Phi hy,NStrands,WireD)
mi_addmaterial('stator'   ,mu_sta      ,mu_sta    ,  0      , 0,  0   , 0.45 ,   0    , 0.98  , 0  ,0   ,0  ,0 )
mi_addmaterial('rotor'    ,mu_rot      ,mu_rot    ,  0      , 0,  0   , 0.45 ,   0    , 0.98  , 0  ,0   ,0  ,0 )
mi_addmaterial('magnet'   ,mu_mag      ,mu_mag    , Hc_mag  , 0,  0   ,  0   ,   0    , 0     , 0  ,0   ,0  ,0 )
mi_addmaterial('air'      ,mu_air      ,mu_air    , 0 )
mi_addmaterial('airgap' ,mu_air      ,mu_air    , 0 )
mi_addmaterial('winding'      ,mu_win      ,mu_win    , 0 , 4, 59.6) % Current density ~4 A/mm² from Excel
mi_addmaterial('wedge',mu_wed,mu_wed, 0 )

%%%%%%%%% Property b(h) of the stator and the rotor
inlin=0
curve_b2h(inlin);
%% ------------------------------------------
%%%--- Definition of the stator ---
stator;
%%%----------------------------
%
%    %%%--- Definition of the rotor  ---
segment_magnet_rotor;
%    %%%----------------------------
%
% --------------------------------
% -- Definition of the air gap
% --------------------------------
xo=Ra-airgap/2;
yo=0;
mi_addblocklabel(xo,yo)
mi_selectlabel(xo,yo)
mi_setblockprop('airgap',0,thi_ag,0,0,4,1)
mi_clearselected;

% Loop to calculate MMF and torque over one rotation
dtheta=3; % increment
dtheta_rad=pi/180*dtheta;
End_loop=180 %37 % End of this rotation study in degres
JL_pole=0; % initialisation of Joule Losses

for j=1:dtheta:End_loop
    theta_elec_deg=j-1
    angle_deg=[angle_deg theta_elec_deg];
    mi_selectgroup(7)
    if j==1
    
    else
    mi_moverotate(0,0,dtheta)
    end
    mi_clearselected
    mi_saveas('C:\Users\vivie\Documents\Ecam\Year 4\Semester 7\Advanced Electrical Machines & Applications\Labs\Code-20251010\PMSM180.fem')
    mi_zoomnatural
    mi_createmesh
    mi_analyse
    mi_purgemesh
    mi_loadsolution
    mo_hidepoints
    mo_hidecontourplot
    
    
    %% Flux calculation
    mo_groupselectblock(11)
    S_slo=mo_blockintegral(5);
    mo_clearblock
    
    for i=11:10+N_slo_s
        
        mo_groupselectblock(i)
        A=mo_blockintegral(1); 
        if j==1
        JL=mo_blockintegral(6);
        JL_pole=JL_pole+JL;
        end
 phi_slo=A*Lu/S_slo;
        mo_clearblock
        
        
        PHI_SLO=[PHI_SLO phi_slo];
    end
    PHI_SLO_MAT=[PHI_SLO_MAT; PHI_SLO];
    PHI_SLO=[];
    
end

angle_meca_rad=(pi/180).*angle_deg;
PHI_ABC=Mat_C*PHI_SLO_MAT';


E_abc=Nturns*gradient(PHI_ABC,dtheta_rad).*omega;

%% MMF harmonics and currents

Npos=length(E_abc(1,:));
ya=2*fft(E_abc(1,:))*(1/Npos);
module_fnd1=abs(ya(2));
phase_fnd1=angle(ya(2));


for j=1:dtheta:End_loop
    theta=j-1;
    pulse=p*(theta)*(pi/180)+phase_fnd1;
    current_ia= I*sqrt(2)*cos(pulse);
    Current_Ia=[Current_Ia current_ia];
    
    pulse=p*(theta)*(pi/180)+phase_fnd1-2*pi/3;
    current_ib= I*sqrt(2)*cos(pulse);
    Current_Ib=[Current_Ib current_ib];
    
    pulse=p*(theta)*(pi/180)+phase_fnd1+2*pi/3;
    current_ic= I*sqrt(2)*cos(pulse);
    Current_Ic=[Current_Ic current_ic];
    
end
     
      
            %Torque calculation
            
            Torque = (E_abc(1,:).*Current_Ia+E_abc(2,:).*Current_Ib+E_abc(3,:).*Current_Ic)/(2*Omega);
            % to divide by 2 to change from MAX to RMS values of E and I

            %Joule losses
            Joule_Losses=JL_pole*p
            
            %Plots
            
            figure(1)
            hold on
            plot(angle_meca_rad,PHI_ABC(1,:),'m')
            plot(angle_meca_rad,PHI_ABC(2,:),'b')
            plot(angle_meca_rad,PHI_ABC(3,:),'g')
            legend('phi a','phi b','phi c')
          title('The phase flux function of the position')
            xlabel('theta en radians')
            ylabel('Flux in Wb')
            hold off
            
            figure(2)
            hold on
            plot(angle_meca_rad,E_abc(1,:),'m')
            plot(angle_meca_rad,E_abc(2,:),'b')
            plot(angle_meca_rad,E_abc(3,:),'g')
            plot(angle_meca_rad,Current_Ia,'m--')
            plot(angle_meca_rad,Current_Ib,'b--')
            plot(angle_meca_rad,Current_Ic,'g--')
            legend('Ea','Eb','Ec','Ia','Ib','Ic')
           title('FEM & Current function of the position')
            xlabel('theta in radians')
            ylabel('FEM')
            hold off
            
           
            figure (3)
            plot(0,0,angle_meca_rad,Torque,'r')
        title('Torque function of the position')
            xlabel('theta in radians')
            ylabel('Torque in N.m')

%closefemm
