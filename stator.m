%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Realisation of the statoric slots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 function num_slo=stator_1()
  
global_values;
 


   	mi_addboundprop('per1',0,0,0,0,0,0,0,0,4)
   	mi_addboundprop('per2',0,0,0,0,0,0,0,0,4)
   	mi_addboundprop('per3',0,0,0,0,0,0,0,0,4)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% The base statoric slot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%angle definition in radian
   tet_s=w1_s/2/Ra;
	%tet  =op_t_s-tet_s
	x0=Ra*cos(op_t_s/2)  ; y0=Ra*sin(op_t_s/2);

%definition of slots coordinates
	x1=Ra*cos(tet_s)    ;      y1=Ra*sin(tet_s); 
	x2=Ra + h1_s           ;      y2=w1_s/2;
	x3=x2+ h2_s            ;      y3=w2_s/2;
	x4=x3+ h3_s            ;      y4=w3_s/2;
    x5=x4+ w3_s/2;


    mi_drawpolyline([x1,y1;x2,y2;x3,y3;x4,y4]);
    mi_drawline(x2,0,x2,y2);
    mi_drawarc(x5,0,x4,y4,pi/2*180/pi,2);



	mi_seteditmode('segments');
	mi_selectsegment((x1+x2)/2,(y1+y2)/2);
	mi_selectsegment((x2+x3)/2,(y2+y3)/2);
	mi_selectsegment((x3+x4)/2,(y3+y4)/2);
 	mi_selectsegment(x2,0);
	mi_setsegmentprop(' ',2,0,0,9);
 	
    mi_seteditmode('arcsegments');
    mi_selectarcsegment((x5+x4)/2,y4/2);
    mi_setarcsegmentprop(10,' ',0,9);
    mi_clearselected;
% 
%Symetry with respect to axis y=0
   mi_seteditmode('group');
   mi_selectgroup(9);
   mi_mirror(0,0,Ra,0);
   mi_clearselected;

% Rotation of a half of a tooth step
	mi_seteditmode('group');
	mi_selectgroup(9);
	mi_moverotate(0,0,op_t_s/2*180/pi);
	mi_deleteselected;

% Demultiplication of the statoric slots
	mi_seteditmode('group');
	mi_selectgroup(9);
	mi_copyrotate(0,0,op_t_s*180/pi,(N_slo_s-1));
	mi_deleteselected;

    Ia=complex(I,0);
    Ib=complex(-I/2,(-sqrt(3)/2)*I);
    Ic=complex(-I/2,(sqrt(3)/2)*I);
    Currents=[Ia Ib Ic];
    
    windings=Currents*Mat_C;
for i=1:N_slo_s
    aa=['circuit_',int2str(i)];
    mi_addcircprop(aa,windings(i),1)
end


% Numbering of the statoric slots
       for i=1:N_slo_s
       xx=(Ra+h3_s/2)*cos((i-1+0.5)*op_t_s);
        yy=(Ra+h3_s/2)*sin((i-1+0.5)*op_t_s);
        num_slo(i)=i+10;
	    mi_seteditmode('group');
        mi_addblocklabel(xx,yy);
        mi_selectlabel(xx,yy);
        aa=['circuit_',int2str(i)];
        mi_setblockprop('winding',0,thi_slo,aa,0,i+10,1);  
        mi_clearselected;
        
       end
        
%Numbering of the wedges
       for i=1:N_slo_s
        xx=(Ra+h1_s/2)*cos((i-1+0.5)*op_t_s);
        yy=(Ra+h1_s/2)*sin((i-1+0.5)*op_t_s);

	    mi_seteditmode('group');
        mi_addblocklabel(xx,yy);
        mi_selectlabel(xx,yy);
        mi_setblockprop('wedge',0,thi_wed,0,0,(N_slo_s+11),0);
        mi_clearselected;
       end

  

% --------------------------------
% -- The external contour
% -------------------------------- 

	    mi_drawarc(Re,0,-Re,0,180,5);
        mi_drawarc(-Re,0,Re,0,180,5);
% --------------------------------
% -- The bore contour
% -------------------------------- 

	    mi_drawarc(Ra,0,-Ra,0,180,5);
        mi_drawarc(-Ra,0,Ra,0,180,5);
        

% --------------------------------
% -- Stator & core definition
% --------------------------------
        xo=Re*0.95;
        yo=0;
        mi_addblocklabel(xo,yo)
        mi_selectlabel(xo,yo)
        mi_setblockprop('stator',0,thi_sta,0,0,3,1)
        mi_clearselected;
% ---------------------------------------------
% -- Boundary conditions of the external contour
% --------------------------------------------
% -- Boundary conditions definition
   mi_addboundprop('A=0',0,0,0,0,0,0,0,0,0)
   mi_seteditmode('arcsegments');  
   xxx=0;
   yyy=Re;
   mi_selectarcsegment(xxx,yyy)
   mi_selectarcsegment(xxx,-yyy)
   mi_setarcsegmentprop(10,'A=0',0,0);

   mi_clearselected;

end