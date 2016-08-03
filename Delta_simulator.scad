// Parallel columns delta robot simulator, extracted from my Delta printer design.
// This simulator could emulate any delta travels, provided the parameters are accurate.
// Needs OpenScad 2015.03 or, for animations, the nightly versions.

// Play with it! you won't broke anything. See line 92 for existing datasets. 

// To run the animation click [View][Animate],a panel open in the bottom right of your screen. Set 10~25 in the FPS fied and 360 in the field 'Steps'. A lower number will make larger steps. You can manipulate the view during animation. 
// OpenScad official version 2015.03 have a lot of flickering during animation. This is corrected in the nightly versions, which I recommended to use.  
// Licence GPL V2.0 - Pierre ROUZEAU aka PRZ - 
// version 0.4.3 - 12 June 2015
// 25 May 2015 - add twin rods in addition of extrusion - display bot name - modifs for micros deltas (Fisher delta and Micro Delta) - allow user part build for effector, corners and carriage.
// 29 may 2015 - added internal comments to explain use. Frame order build modified for tranparent panels
// June - allow more personnalisation - review fan , spool - allow dataset text lines
// 12 June 15: 'square Delta' - 29 sept 15 'Zatsit' folded mechanic

// set below variable to false if you want to do a closeup view during animation
camPos = true; //if true force camera position according request in dataset

//??? modifs -> Inversion rotation/translation on spool

//dimensions are in mm.
Delta_name = "Simulator example";
//-- Frame data ----------------------------------------------
beam_int_radius = 175; // radius inside the rectangular columns - used as reference radius
 // if columns are replaced with rods this is the radius of the rod axis plane. 
hbase = 60; // height of the base structure
htop  = 30;  // height of top structure
htotal = 680; // total height, including base and top structure
bed_level = 8; // distance between the top of the bottom structure and the top of the bed.
extrusion = 20;
rod_space = 0; //if > 0 set two rods instead of one extrusion, diameter based on extrusion
  // if set, reference radius is rod axis plane and not extrusion face  
railthk   = 0;  // rail thickness. if > 0, show a cuboid simulating a sliding rail
railwidth = 0; 
rail_base = 0; // base of the rail, which could be higher than bed plate

//-- Carriage data --------------------------------------------------
car_hor_offset=20; //Carriage: horizontal distance between the articulation and the internal of the columns
car_vert_dist=27;  //Carriage: vertical articulation distance/reference plane (at the top of the carriage) 
hcar=75; // carriage height - no effect on travel
dia_ball = 10; 
dia_arm  = 68;

//-- Effector data --------------------------------------
eff_hor_offset=28; //Distance effector center/articulations Kossel mini: 20, Rostock max: 33mm
eff_vert_dist = 12; //Vertical distance between the bottom of effector and the articulations axis

//-- General design data -------------------------------
arm_space=50; // space between the arms
wire_space = 0 ; // space between tensioning wire
top_clearance=10; // clearance between top of the carriage and top structure
delta_angle = 62; //key travel design: arm angle/horizontal for centered effector.
//Will only define the arm length and travels. Does not modify parts. 57~63°
//62° gives slightly longer arms and a near maximum practical usable space with vertical arms while nearing columns (if the iminimum angle is 20°). For a 3D printer, great care shall be done while installing fans which could easily conflict with columns. fan shall be installed 60° from the column and protrude on flat side.
//Reachable area is a rounded triangular shape, with the ends pointed on columns, hence the real limitation of travel is dictated by the clearance on columns. You have the option to define a rough belt simulation, which will show the conflicts - see below.
//  A clever positioning allows elongated parts to be slightly longer than the theoretical usable diameter

arm_length = 0; // Alternatively, you could define the arm length, which will supersedes the design angle - If too long, you will have problem with the animation (reachable area too large drive to overpass vertical for the arms). Set to 0 give priority to the angle. arm length is given axis to axis. 
 
mini_angle = 20; //minimum angle/horizontal. 20° is generally considered as the practical limit. That will not modify the design, only give you an approximate information  about the maximum possible range. The range is not really circular, but will be considered so for practical reasons. You could go below 20°, but there is no real point, because when the other arms are nearing vertical, the effector bang the columns. Also, it drives to dynamic problems (a small effector move need a large carriage move), extra loads and effector loss of stability.

hotend_vert_dist = 20;//vertical distance between hotend nozzle and effector bottom plate. depends from the effector design and hotend type.

//Frame details
frame_corner_radius=1.5*extrusion; //modify corner shape radius.
frame_face_radius=280; // radius of the face. Shall be >> overall radius. 0 is flat
corner_offset = -3; //offset center of the corner sector / beam internal radius
housing_base = 0; // if = 0 no housing shown - usually set to hbase
housing_opening = 300;
belt_dist=0; //distance between the belt and the internal of the column. (belt face at the contact point with effector). if this data is different from 0, rough belt approximation will be shown, for conflict evaluation.
spool_diam = 200; // if spool_diameter > 0, spool shown on top - vertical axis
spool_thk  = 70;

// geometry
rotAng2 = 120; // added angles definition for 'square' delta - see specific dataset
rotAng3 = 240;
frame_rot = 30;
move_rot  = 0;
railrot = -30;

//-- Miscellaneous stuff - no influence on movement ---------------------------------
struct_color = "red";
moving_color = "deepskyblue";
bed_color = [0.5,0.5,0.5,0.5]; // transparent 

$vpd=camPos?2100:undef;      // camera distance: work only if set outside a module
$vpr=camPos?[80,0,42]:undef; // camera rotation
$vpt=camPos?[215,-90,420]:undef; //camera translation  */

//--- Text display ------------------------------------------
txtsize = beam_int_radius/16;
txtxpos = 0.8*beam_int_radius;
txtypos = 1.25*beam_int_radius;
txtzpos = 400;
txtangle= -60;

//== data set included below will supersedes above data ===============================
//-- Uncomment the data set you want to see, else it defaults on an example
// To play with the printers of the datasets, you shall either modify data in the file or 
// set new values AFTER the include <file>.
//--------------------------------------------------------------------
include <Lily2.scad>  //- Data set for Lily Big by PRZ

//=====================================================================================
//$details=true;

//qpart = 1;

$fn=32; // smooth the cylinders

//$t=0.8377;

//-- imposing effector position (if defined, this will supersedes the animation equation)
// note that structure is rotated 30°, so x and y are rotated accordingly.
/* 
xe=100; // impose hotend x coordinate
ye=50;  // impose hotend y coordinate
ze=0; // impose hotend z coordinate */

//Alternatively, you could impose the position in polar coordinates
/*
e_radius=90;
e_angle=-89;
ze=213; 
xe=e_radius*cos(e_angle);
ye=e_radius*sin(e_angle);   //*/

// if you ask for an unreachable point, arms and effector will not be displayed, without warning.

// Displayed angles are those of the arms attached to the back column
// Note that for long arms, the side angles you can see may not be acceptable for rod ends type 'traxxas', 'Igus' or equivalent and are a very limiting factor for the reachable area.

//Last parameters defines camera position at preview- set camPos to 'false' if you want to make an animation with another position else view will be reset at each frame.

//echo_camera();

//====================================================================
*view(); //The animation will run around a cylinder based on the maximum reachable radius at the middle of the columns. If arms are sufficiently long, it will bang on columns, belts, etc.
view_circle (working_dia,0); // view_circle (dia, height) - if off-limits - display may fail
// view_helix (); 

//--- dimensions calculations --------------------------------------------------
radius_cent = beam_int_radius-eff_hor_offset-car_hor_offset;
ar_length = (arm_length)?arm_length: radius_cent/cos(delta_angle); // center to center
d_angle = acos(radius_cent/ar_length);
ht_cent = radius_cent*tan(d_angle);
working_dia =2*(ar_length*cos(mini_angle)-beam_int_radius+car_hor_offset+eff_hor_offset);  
// calculate the maximum usable height - at center - at sides
// reference plane is the base of the effector
effVtPos = hbase+bed_level+hotend_vert_dist; // height of effector base plane; 
// add the base height
carVtPos =effVtPos +(ht_cent+car_vert_dist+eff_vert_dist); //top of carriage vertical position while the head is at bed level

travel_stop = htotal-htop-top_clearance; //default some clearance for switch hysteresis and stops. This is the max position of top of carriage. - not checked by the software
working_height_cent = travel_stop-carVtPos; // considering the carriage able to go up to the plate  
rdiff = beam_int_radius-car_hor_offset-working_dia/2; // horiz dist between top and bottom articulations while at maximum radius (arms nearing vertical)
ht_side = sqrt (ar_length*ar_length-rdiff*rdiff); //Carriage height while at working radius
working_height_min = travel_stop-(effVtPos +(ht_side+car_vert_dist+eff_vert_dist));

//Effector geometrical stability calculation - OpenScad angles in deg
Rd = sqrt (pow(arm_space/2,2)+pow(eff_hor_offset,2));
An = 60-atan (arm_space/2/eff_hor_offset);
ball_end_space = 2*sin(An)*Rd;  echo (ball_end_space =ball_end_space);
//htv = tan (d_angle)*eff_hor_offset; echo (htv=htv); //virtual articulation pos
//virtual_axis_d = htv-eff_vert_dist-hotend_vert_dist; //diff hotend/virtual arti
TES = pow(arm_space,2)/ball_end_space; // arbitrary coef

//====================================================================

module view () {//if no fixed xe,ye,ze, viewing trajectory and other stuff as a function of $t
  // Herebelow the animation sequence (it loops) - 360 steps gives a step every 2° of rotation.
  // 5 sequences: 1:flat peripheral 2:flat curve to center 3:climb up 4: curve from center sligthly down to periphery. 5: Helix down. Note that in sequence 4 carriage bang in the top structure as trajectory is on a cone, but available height is flat on the sides.
   
  if ((xe!=undef)&&(ye!=undef)&&(ze!=undef)) { 
     simul (xe,ye,ze); // arms and effector at the given xe,ye,ze values ze default to 0
  }  
  else { // arms and effector at the animated position (which depends from $t)
    hwm= working_height_min;
    hws= working_height_cent; 
  
    anim_angle=$t*720-150; // two rotations for $t 0->1 //-150 to start on left column 
    r1= working_dia/2; //$t 0 to 0.15
    r2= (0.2-$t)*20*working_dia/2; //$t 0.15 to 0.2
    r3= 0; // $t 0.2 to 0.35
    r4= ($t-0.35)*6.67*working_dia/2; //$t 0.35 to 0.5
    r5= working_dia/2; //$t 0.5 to 1 helix down
     
    h1= 0;
    h2= 0;
    h3= ($t-0.2)*6.67*hws; // hws is max vertical travel at center
    h4= hws-($t-0.35)*6.67*(hws-hwm);
    h5= (1-$t)*2*hwm;  // hwm is max vertical travel at periphery
    
    a_radius= ($t<0.15)?r1:($t<0.2)?r2:($t<0.35)?r3:($t<0.5)?r4:r5;//select sequence value
    a_height= ($t<0.15)?h1:($t<0.2)?h2:($t<0.35)?h3:($t<0.5)?h4:h5;
    
    simul (a_radius*cos(anim_angle),a_radius*sin(anim_angle),a_height);//simulate position (x,y,z) 
  } 
}

module view_circle (dia, height) { //rotation on a given diameter at a set height
  simul (dia/2*cos($t*360),dia/2*sin($t*360),height);//simulate position (x,y,z) 
}

module view_helix () { //-- simple helix on limits, from top to bottom
  simul (working_dia/2*cos($t*360),working_dia/2*sin($t*360),max(0,working_height_min*(1-$t))); 
}  

module simul (x, y, z=0) { //display delta with effector and arms at a given position (note: position rotated 30°)
  rotz (move_rot) {
    delta_cal(x,y,z, 0); // first set of arm, with carriage
    delta_cal(x,y,z, rotAng2); // second set of arm, with carriage
    delta_cal(x,y,z, rotAng3);
    disp_effector(x,y,z); 
  }  
  Frame(); // build at the end to have proper view when panels are transparents
  disp_text(txtangle,txtxpos,txtypos,txtzpos); // display printer data on a panel aside the printer 
}

module delta_cal (x, y, z, rot) { // calculation of arms angles and display
  angt = atan2 (y,x); // atan2 take into account the quadrant 
  rad = sqrt(x*x+y*y);    // radius from center
  xc = rad*cos(angt+rot); //for arm and carriage rotation
  yc = rad*sin(angt+rot);
  drd_plane = sqrt(pow(radius_cent-yc,2)+xc*xc);
  angsign = sign(radius_cent-yc);
  z_angle = angsign*asin(xc/drd_plane); // angle around z axis
  h_angle = angsign*asin(drd_plane/ar_length);
  vpos_car = cos(h_angle)*ar_length-ht_cent; 
  rotz (30)  
    disp_armcar(x,y,z,-rot,-h_angle,z_angle,vpos_car);
  if (rot==0) { // display angles
    txta = str("Angles: vertical: ",90-round(h_angle*10)/10, " horizontal: ", round(z_angle*10)/10);
    ltxtsup = $dtxt? len($dtxt):0;
    rot (0,-10,txtangle-move_rot) tsl (0,$xtxt)
      tsl (txtxpos, txtypos,txtzpos-txtsize*25.5)
        rot (90,0,90) color("black")
          textz(txta, txtsize*0.85, 2, false);
  }
}

module disp_effector(x, y, z){
  wx= arm_space-dia_ball*1.8;
  rotz (30)
    tsl(x,y,effVtPos+z) {  
      if ($bEffector) buildEffector();   
      else color(moving_color) { // simplified effector shape 
      if (eff_vert_dist < 10) // if articulation buried in effector, other shape    
        rot120() 
          tsl (-wx/2)
            cube([wx,eff_hor_offset+dia_ball*0.8,eff_vert_dist*2]); // effector thk 8 (kossel mini), 9 (Delta Fisher)
      else  
        rotz (60) 
          intersection () { // bottom part
            cylz (arm_space +40,12, 0,0,-1,100);
            eqtrianglez (-4*eff_hor_offset-40,10);
          }
      }    
      if ($bHotend) buildHotend();     
      else   
      color ("grey") {
        cylz (16, -52, 0,0,60-hotend_vert_dist);
        tsl (0,0,-hotend_vert_dist)
          cylinder (d1=4, d2=16, h=8);
      } 
    }   
} //disp_effector

module disp_armcar(x,y,z,i, ang_hor, ang_ver, vpos_car, car_col, arm_col) {// arms and carriage
  clear=dia_ball/5;
  thkcar = max(5+railthk, car_hor_offset-9); // car thickness
  thkarti = car_hor_offset-dia_ball/2-clear;
  zpos= z+eff_vert_dist+effVtPos;
  tsl (x,y) rotz (i) { // arms grow from effector
     // Arm creation and duplication
      tsl (-arm_space/2,eff_hor_offset,zpos){
        if ($bArm) 
          buildArm (ang_hor,ang_ver);
        else {
          duplx(arm_space) {
            color("grey") 
              rot(ang_hor,0,ang_ver) 
                cylz (dia_arm, ar_length-dia_ball,0,0,dia_ball/2);
            color("silver") 
              sphere (d=dia_ball,$fn=64); // ball
          }
        } 
        if (wire_space)  
          tsl ((arm_space-wire_space)/2)
            duplx(wire_space) 
               color("white") 
                 rot(ang_hor,0,ang_ver) 
                   cylz (1, ar_length);
        if (eff_vert_dist >=10) // ball supports
          color(moving_color)
            duplx(arm_space)
              cylz (12,-10,0,0,-1);
        else // ball axis
          color("grey") 
            cylx (dia_ball/2,arm_space);
      }
  } //rotate
  rotz (i+90) 
    tsl (beam_int_radius,0,z+carVtPos+vpos_car) 
      rotz (-90) { 
        //z: position of the nozzle
        //carVtPos: position of the carriage while nozzle is at center and z=0
        //vpos_car: carriage position difference with the position while effector centered
        /*  tsl (0,-clear-(car_hor_offset-3)/2, -car_vert_dist)
            cube ([arm_space+1.6*dia_ball,car_hor_offset-2*clear,1.6*dia_ball],center=true);*/
        if ($bCar) buildCar(); //$ prefixed variables are silent if not existing
        else  color(moving_color) {
          cubez (arm_space+1.6*dia_ball,thkcar,-hcar,0,-thkcar/2-clear);  
          cubez (arm_space+1.6*dia_ball,thkarti,1.6*dia_ball,
              0,-thkarti/2-clear,-car_vert_dist-0.8*dia_ball);    
        }  
        if (rod_space) {
          hbear = extrusion*3;
          color ("silver") duplx(-rod_space)
            cylz (extrusion*1.875, -hbear,rod_space/2, 0,(hbear-hcar)/2);
        }  
        duplx(arm_space) // balls
          tsl (-arm_space/2,-car_hor_offset,-car_vert_dist)
            color("silver")
              sphere (d=dia_ball, $fn=64); 
      }	 
}//disp_armcar	

module Frame() { 
dec_housing = (beam_int_radius+3+extrusion)/2 + max(extrusion, railwidth)/2;  
extrusionw = ($extrusionwd)? $extrusionwd:extrusion; 
  
  rotz(frame_rot) {
    echo ($bAllFrame=$bAllFrame);
    if ($bAllFrame) buildAllFrame();
    else color(struct_color) {
      Frame_shape (hbase); // bottom
      Frame_shape (htop, htotal-htop); // top
    }   
    color(struct_color) {
      if (housing_base) // show an housing
        difference () {
          Frame_shape (htotal-housing_base, housing_base);
          Frame_shape (htotal-housing_base+2, housing_base-1, -2);
          rotz (180) // cut the opening 
            //tsl (0,0,(hbase+housing_opening)/2+10)
            hull() {
              cylx(-20,1000,0,dec_housing+10,hbase+10);   
              cylx(-20,1000,0,500,hbase+10);   
              cylx(-20,1000,0,dec_housing+10,hbase+housing_opening-10);   
              cylx(-20,1000,0,500,hbase+housing_opening-10);   
            }
        }
    } 
    rot120(railrot) { // vertical beams and rails
      if (railthk) 
        color("silver")      
          cubez(railthk, railwidth, htotal-rail_base, beam_int_radius-railthk/2,0,rail_base); 
      color("DarkGray") 
        if (extrusion)
          if (rod_space)  
            dmirrory() 
              cylz (extrusion,htotal, beam_int_radius,rod_space/2);
          else  
            cubez(extrusion, extrusionw, htotal, beam_int_radius+extrusion/2); 
      if (belt_dist||$bdist) {
        bd = $bdist ? $bdist:belt_dist;
        ht = $ht_tens?$ht_tens-25:30; // if tensioner at the bottom
        color("black") // show belt
          dmirrory() 
            cubez (6,2.5,htotal-40-ht, beam_int_radius-bd+3,6,ht); 
      }  
    }
    bed_dia = $bedDia?$bedDia:working_dia*1.12;
    if (bed_level) // bed
      color(bed_color) 
        cylz (bed_dia,-3,0,0,hbase+bed_level,80);
  // spool
    sprot = $spool_rot? $spool_rot:[0,0,0];  
    sptsl = $spool_tsl? $spool_tsl:[0,0,htotal+spool_thk/10];    
    if(spool_diam)
      translate (sptsl) rotate (sprot) spool();
    if ($bSide) buildSides(); // allow specific sides to be built - at the end if transparent    
  }  
}

module spool(clr="yellow") {
  difference () { 
    union() {
      color ("black") { 
        cylz (spool_diam, spool_thk/20,0,0,0,50);
        cylz (spool_diam, spool_thk/20,0,0,spool_thk*0.95,50);
      }  
      color (clr)
        cylz (spool_diam*0.92, spool_thk*0.86,0,0,spool_thk*0.07,100);
    }    
    cylz (-40,222); // spool hole
  }
}

module Frame_shape (height, vpos=0, foffset=0) { //??? - mod
//corner_radius = 1.3*extrusion+frame_corner_roundness;
//int_radius= beam_int_radius-frame_corner_roundness+3;
  hxwd = (rod_space)?rod_space:($extrusionwd)?$extrusionwd-extrusion:0;
  if (hxwd)
    hexagon (frame_corner_radius+foffset, hxwd, beam_int_radius, corner_offset, 0, height, vpos); 
  else   
    if (rotAng2==90) { // means this is a 'square' delta
      side = (beam_int_radius+frame_corner_radius*1.4)*1.414;
      rotz(15) cubez (side, side,height,0,0,vpos ); 
    }  
    else  
      rounded_triangle (frame_corner_radius+foffset, frame_face_radius+foffset, beam_int_radius+corner_offset, height, vpos);
}

module disp_text(angz,xpos,ypos,zpos) { // display printer data on a panel
  vtext0 = [
    "  Delta Simulator", 
    str("    ",Delta_name),
    "",
    str("Diameter inside beams: ",round(beam_int_radius*2)," mm"),
    str("Reference height: ",round(htotal)," mm"),
    str("Space between arms: ",arm_space," mm"),
    str("Effector offset: ",round(eff_hor_offset*10)/10," mm"),
    str("Arm radius: ",round(radius_cent*10)/10," mm"),
    str("For design angle: ",round(d_angle*10)/10,"°"),
    str("-Arm length: ",round(ar_length*10)/10," mm"),  
    str("and mini angle: ",round(mini_angle*10)/10,"°"),
    str("-Working diam: ",round(working_dia)," mm"),
    str("For bed/ceiling: ",round(travel_stop-hbase-bed_level)," mm"),
    str("-Centre working height: ",round(working_height_cent)," mm"),
    str("-Minimum working height: ",round(working_height_min)," mm"),
    str("Effector stability:", round(TES), " mm"),
    str("Effector plane/hotend distance:",round(hotend_vert_dist+eff_vert_dist)," mm"),
    ""
  ];
  vtext1 = $dtxt? concat (vtext0,$dtxt):vtext0; //add dataset text, if any - shall be an array
  vtext = concat (vtext1,"", "program License: GPL V2.0 - Author: PRZ");
  ltxt = len(vtext);
    rot (0,-10,angz) tsl (0,$xtxt) {
      color ("white") // panel for writing
        tsl (xpos, ypos-txtsize, zpos-(ltxt+0.8)*1.5*txtsize) 
          cube ([1,24.5*txtsize,(ltxt+2)*1.5*txtsize]); 
      color ("black") { // the writing on the wall
        for (i=[0:ltxt-1]) {
          txs=(i==ltxt-1)?txtsize*0.8:txtsize; // last line is smaller size (license)
          tsl (xpos, ypos, zpos-1.5*txtsize*i)
            rot (90,0,90)
              textz(vtext[i], txs, 2, (i==0));  //(i==0) bold the first line
        }
      } 
    }
} 

//======== LIBRARY (extract from the Z_utility library) =======================
//-- Operators -------------------------------------
//rotation and translations without brackets - 
module rot (x,y=0,z=0) {rotate([x,y,z]) children();}
module rotz (z) {rotate([0,0,z]) children();}
module tsl (x,y=0,z=0) {translate([x,y,z]) children();}
module tslz (mz) { translate ([0,0,mz]) children();}

// for a delta, everything is rotated three times at 120°, so an operator for that 
module rot120 (a=0) {
  for(i=[0,rotAng2,rotAng3])  // rotation angles could be redefined for 'square' delta
    rotate([0,0,i+a]) children();
}

module duplx (dx, nb=1, startx=0) { // duplicate object at distance 'dx', times nb
  for (i=[0:nb])
    tsl (dx*i+startx) children();
}

module duply (dy, nb=1, starty=0) { // duplicate object at distance 'dy',  times nb
  for (i=[0:nb])
    tsl (0,dy*i+starty) children();
}

module duplz (dz, nb=1, startz=0) { // duplicate object at distance 'dz',  times nb
  for (i=[0:nb])
    tsl (0,0,dz*i+startz) children();
}

module dmirrorx() { // duplicate and mirror on x axis
  children();
  mirror ([1,0,0]) children();
}

module dmirrory() { // duplicate and mirror on y axis
  children();
  mirror ([0,1,0]) children();
}

module dmirrorz() { // duplicate and mirror on z axis
  children();
  mirror ([0,0,1]) children();
}

//-- Primitives ------------------------------------

module textz(txt,size,h,bold) { // position text normal to z axis
  st=(bold)? "Liberation Sans:style=Bold":"Liberation Sans";
  linear_extrude(height = h) 
    text (str(txt), size, font=st);
}

module cylz (diam,height,x=0,y=0,z=0,div=$fn) { // Cylinder  on Z axis
  mv=(height<0)?height:0; 	// accept negative height	
  center=(diam<0)?true:false;	
  translate([x,y,mv+z]) 
    cylinder (d=(abs(diam)), h=abs(height), $fn=div, center=center);
}

module cylx (diam,length,x=0,y=0,z=0,div=$fn) {//Cylinder on X axis
  mv=(length<0)?length:0;	// not ok if diam AND length are negative. who cares ? 
  center=(diam<0)?true:false;	
  translate([x+mv,y,z])
    rotate([0,90,0])
      cylinder (d=(abs(diam)), h=abs(length), $fn=div, center=center);
}

module cyly (diam,length,x=0,y=0,z=0,div=$fn) {//Cylinder on X axis
  mv=(length<0)?length:0;	// not ok if diam AND length are negative. who cares ? 
  center=(diam<0)?true:false;	
  translate([x,y+mv,z])
    rotate([-90,0,0])
      cylinder (d=(abs(diam)), h=abs(length), $fn=div, center=center);
}

module cubez(xd,yd,zd,x=0,y=0,z=0) { // centered on x and y, not centered on z
  mz=(zd<0)?zd:0;
  tsl (x-xd/2,y-yd/2,mz+z)
    cube ([abs(xd),abs(yd),abs(zd)]);
}

module eqtrianglez (dim, length) { // dim positive defines triangle base, negative defines the external circle diameter. Centered.
  mz = (length<0)?-length:0; 
  base = (dim<0)? -dim/cos(30)*3/4: dim;
  tsl (0,0-base*cos(30)/3,mz)
    linear_extrude(height=abs(length))
      polygon(points=[[-base/2,0],[base/2,0],[0,base*cos(30)]]);		
}

module sector (diam, height, half_angle) { // cut a sector - non generic module
  difference () { 
    cylinder (d=diam,h=height,$fn=120);
    rotz (-half_angle)
      tsl (-diam,0,-1)
        cube ([diam*2,diam*2,height+2]);
    rotz (half_angle)
      tsl (-diam,-diam*2,-1)
        cube ([diam*2,diam*2,height+2]);
  }  
} 

module rounded_triangle (corner_radius, face_radius, int_radius,h,hpos=0) { // triangle with rounded corners and faces. int_radius is relative to corners
fr = face_radius-corner_radius;  
cosint = int_radius*cos(30);  
face_offset = sqrt(fr*fr-cosint*cosint)-int_radius*0.5; 
ang_face = asin (cosint/fr);    
  hull() 
    rot120(railrot) 
      cylz(corner_radius*2,h,int_radius,0,hpos,80);
  if (ang_face && face_offset) // just to remove warning
    rot120(railrot) // not included in the 'hull()' for performance reasons
      tsl (face_offset,0,hpos) 
        difference() {
          sector (face_radius*2,h,ang_face);
          cubez(face_radius*2,face_radius*2,h+2,face_radius-face_offset,0,-1);
        }  
}

module hexagon (corner_radius, axis_space, axisf_radius, coffset,choffset, h, hpos=0) { 
  hull() {
    rot120 (railrot)
      dmirrory ()
        cylz (corner_radius*2,h, axisf_radius+coffset,axis_space/2+coffset/2+choffset,hpos,48);
  }
}

//-- Miscellaneous -------------------------------------------------------
module build_fan(size=40, thk=6) { //~ok for 25,30,40,60,80,120. Not ok for 92
  holesp = size==120?52.5:size==80?35.75:size==60?25:0.4*size;
  color ("black") {
    difference() {
      hull() 
        dmirrorx() dmirrory() cylz (2,thk,size/2-1,size/2-1);
      cylz (-size *0.95,55);
      dmirrorx() dmirrory() cylz (-(size*0.03+2),55,holesp,holesp);
    }
    cylz (12+size/8, thk-1,0,0,0.5);
  }  
}  

module echo_camera () { // Echo camera variables on console
  echo ("Camera distance: ",$vpd); 
  echo ("Camera translation vector: ",$vpt);  
  echo ("Camera rotation vector: ",$vpr);
}