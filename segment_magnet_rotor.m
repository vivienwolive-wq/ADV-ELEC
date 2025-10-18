

% ------------------------------------------------
% --  Rotor Construction
% --  with segmentated magnets
%2 ------------------------------------------------

function segmentated_rotor_magnets()
global_values;
 
op_pole=2*pi/Npoles
 op_pole_deg= op_pole*180/pi
 
% --  Base magnet definition
% -- considered base form is rectangular

xx1= Rr*cos(op_mag/Nseg/2);
yy1=-Rr*sin(op_mag/Nseg/2);

xx2=xx1+thi_mag;
yy2= yy1;

xx3=xx2;
yy3=-yy2;

xx4=xx1;
yy4=yy3;
% -- Magnet barycenter or center of mass
xhub=(xx1+xx2+xx3+xx4)/4;
yhub=(yy1+yy2+yy3+yy4)/4;
rhub=sqrt(xhub*xhub+yhub*yhub);



	mi_addnode(  xx1,yy1)
	mi_addnode(  xx2,yy2)
	mi_addnode(  xx3,yy3)
	mi_addnode(  xx4,yy4)

      mi_addsegment(xx1,yy1,xx2,yy2)
      mi_addsegment(xx2,yy2,xx3,yy3)
      mi_addsegment(xx3,yy3,xx4,yy4)
      mi_addsegment(xx4,yy4,xx1,yy1)

	mi_seteditmode('segments')

	mi_selectsegment((xx1+xx2)/2,(yy1+yy2)/2)
    mi_selectsegment((xx1+xx4)/2,(yy1+yy4)/2)
	mi_selectsegment((xx3+xx4)/2,(yy3+yy4)/2)
    mi_selectsegment((xx3+xx2)/2,(yy3+yy3)/2)

	mi_setsegmentprop(' ',0,0,0,7)
    mi_clearselected



% -- Demultiplication of the base magnet blocs
% -- in order to constitue a pole

	mi_seteditmode('group')
	mi_selectgroup(7)
	mi_copyrotate(0,0,op_mag_deg/Nseg,Nseg-1)
	mi_clearselected

   x1=Rr*cos(op_pole-op_mag/Nseg/2)
   y1=Rr*sin(op_pole-op_mag/Nseg/2)
   x11=Rr*cos(op_mag-op_mag/Nseg/2)
   y11=Rr*sin(op_mag-op_mag/Nseg/2)
   tet=op_pole_deg-op_mag_deg
   mi_addnode(  x1,y1)

% -- rotor in arc shape between the magnets

	mi_addarc(x11,y11,x1,y1,tet,5)
	mi_seteditmode('arcsegments')
    mi_selectarcsegment((x11+x1)/2,(y11+y1)/2)
	mi_setarcsegmentprop(2,' ',0,7)
    mi_clearselected


% -- Demultiplication of the Npoles
	mi_seteditmode('group')
	mi_selectgroup(7)
	mi_copyrotate(0,0,op_pole_deg,Npoles-1)
	mi_clearselected


% -- Introducing the magnets under two poles

for p=1:1:Npoles/2
       for i=1:1:Nseg
            dir=(i-1)*op_mag/Nseg  + (p-1)*2*op_pole
            tetor=dir*180/pi
            x_mag=rhub*cos(dir)
            y_mag=rhub*sin(dir)
            mi_addblocklabel(x_mag,y_mag)
            mi_selectlabel(x_mag,y_mag)
            mi_setblockprop('magnet',0,thi_mag,0,tetor,7,1)
            mi_clearselected
       end

       for i=1:1:Nseg
           dir=(i-1)*op_mag/Nseg  + (p-1)*2*op_pole +op_pole
           tetor=dir*180/pi+180
           x_mag=rhub*cos(dir)
           y_mag=rhub*sin(dir)
           mi_addblocklabel(x_mag,y_mag)
           mi_selectlabel(x_mag,y_mag)
           mi_setblockprop('magnet',0,thi_mag,0,tetor,7,1)
           mi_clearselected
        end
end

%  	mi_seteditmode('group')
% 	mi_selectgroup(7)
% 	mi_moverotate(0,0,(op_pole_deg-op_mag_deg)/2+op_mag_deg/Nseg/2)
% 	mi_clearselected




% --------------------------------
% -- The internal contour
% -------------------------------- 

	    mi_drawarc(Ri,0,-Ri,0,180,5);
        mi_drawarc(-Ri,0,Ri,0,180,5);
        

% --------------------------------
% -- Core & Rotor definition
% --------------------------------
        xo=Ri*1.05;
        yo=0;
        mi_addblocklabel(xo,yo)
        mi_selectlabel(xo,yo)
        mi_setblockprop('rotor',0,thi_rot,0,0,1,1)
        mi_clearselected;
        
% --------------------------------
% -- Hub definition
% --------------------------------
        xo=Ri*0.08;
        yo=0;
        mi_addblocklabel(xo,yo)
        mi_selectlabel(xo,yo)
        mi_setblockprop('air',0,thi_hub,0,0,2,1)
        mi_clearselected;
end % -- end of function