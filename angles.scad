// Data Set for D-Box Delta printer - 3 February 2016
qpart=0;
$clearcar = false; // add a pad to indicate clearance
//before creating STL, check closely that parameters are the same in this file and in Lily2.scad, this is not automatic. Be very careful of multiple assignations, the last one is the only valid. Look console messages
// Don't assign in batch execution parameters which are used for other parameter calculation, this DON'T WORK. You have to modify the file manually
// Reference radius is the corner angle
/****************************************************************************
Parts needed for one machine 
// parts specific to an angle size
- 3 foots : 2  full set : 8
- 3 motor supports: 3 full set:9 foot and top complete set: 10
- 2 top supports : 4 (top support not needed for back panel,done by motor support)
= 3 plugs for motor support obturation : 5
- 3 motor anchors : 12 
- 3 tensioners : 13
- 3 carriages : parts 16,17

// parts NOT specific to an angle size
- 3 thumbwheels: 14
- 3 carriages nut retainer: 15 (x3)
- 3 ball cups: 18 
- 3 bearing links: 19 (x 3)
- 3 belt tensioners part  20 (x 3)
- 1 set of 6 rod ends: 22
- If you install SSR without safety shielding, print part 25
For extruder parts, see the dedicated file

//Tool
- Tap tool:47 to tap the printed rod ends. Use an hex bolt, not a real tap tool.

Effector - see Effector_DBOX.scad
- 1 effector 
- hotend support 2 different parts
- part cooling duct - see instructions for printing
- 3 top magnet supports and 3 bottom magnet supports

Extruder - see Dual_extruder.scad

To build the box, you need draft DXF templates 
- Support positions top view: 70 - need some computing time
- cover with stepper cooling holes : 62
- Face panel with door opening : 60 
- Back panel - no hole : 61
- Left side panel - no hole : 62
- Internal side panel with cooling and filter holes : 63
- Base plate: 64
- Top plate : 65  _ holes for angles not shown yet ???
- Sides doors (2) with cooling holes : 66
- Cover panel: 67

**********  RECOMMENDATIONS FOR PRINTING ***********************************
* Use a calibrated machine to have accurate dimensions
* Use material resistant to temperature, ABS or PETG. ABS will be better than PETG if heating the chamber.
* Fill in: Honeycomb, 70% , layer 0.3mm  
* No support
* Layers thickness 0.3, EXCEPT the following, which shall be printed in layer thickness 0.2 or reduced width:
  - Belt attach - part 19 or part 20
  - Magnet holders - top and bottom - (in effector module) - 
Note that printing in layer 0.3 gives stronger parts, so don't be tempted to print in thinner layer for precision, which will not be better, anyway.
Note that fill in shall be 'full contact' between the layers, so, for some slicers, honeycomb may be replaced by 'triangle'. DON'T use rectilinear infill. 3D honeycomb is faster than simple honeycomb, but retract shall be controlled for good contact between infill and walls.
* 3 walls (for layer 0.3)
* 5 layers on top and 5 layers on bottom (for layer 0.3)
* Part cooling duct printing is a bit specific, see dedicated Slic3R profile. in addition there shall be no retract between layers, reduced cooling time (~10 sec.), low minimum speed for cooling (4 mm/s). Note that spiral mode don't print correctly this part on Slic3R.

****************************************************************************/

if (qpart) {
  $ears=true;
  if (qpart==1) {
    $ears=false;
    buildCarAngle();
    gray() 
      rotz(180+45)  // angle rails
        profile_angle (angleSize, angleSize, angleThk, -100); 
  }
  //-- supports  ---------------------------------
  else if (qpart==2) rotz(45) angleSup(); // foot support 
  else if (qpart==3) {rotz(45) angleSup(false); // top support 
   // red() tsl (-angleSize/2,-angleSize/2,47) rotz (180) mirrorz () angleplug(6.8); // check plug
  }  
  else if (qpart==4) top_renf();  //reinforcment   
  else if (qpart==5) angleplug(6.8);  // plug top of angles - required 
  else if (qpart==8) duplx (50,2) angleSup();  // foot support set
  else if (qpart==9) duplx (50,2)angleSup(false); // top support set
  else if (qpart==10) {//  complete support set
    duplx (45,2) angleSup(true); 
    tsl (-35,92) duplx (48,2) rotz(180) angleSup(false);
    tsl (-50,10) duply (85) top_renf();
    tsl (25,152) rotz(45+180) angleplug(6.8);
    tsl (110,20) duply (70) rotz(90+45) angleplug(6.8);  
  }
  else if (qpart==11) rot (0,90) motorPlate();  //motor anchor 3 needed 
  //-- tensioner  --------------------------------
  else if (qpart==12) rot(180) tensionerAngle(); // tensioner - 3 needed
  else if (qpart==13) thumbwheelM4();    // thumbweel for tensioner - 3 needed
  else if (qpart==14) tsl (0,0,6) duplx(16,2) rot(180) nut_retainer();  
  //-- carriage  ---------------------------------
  else if (qpart==15) rot(180) carriage_main();  // Carriage - 3 needed
  else if (qpart==16) carriage_center(); // carriage center part - 3 needed
  else if (qpart==17) rot (-90,0) carriage_link(); // carriage bolts link - 3 needed
  else if (qpart==18) rot (35-180) ball_bar(15);   
  else if (qpart==19) rot(0,90) attbelt(); // 

  //-- Effectors and arms ------------------------
  else if (qpart==20) duply(11,2) rot (0,90) rodend(); 
  
//-- Misc --------------------------------------------------  
     
  //-- miscellaneous  ----------------------------
  else if (qpart==44) difference(){cylz(30,2.8);cylz(-23.9,11);} //ESD ring
  else if (qpart==47) taptool();   // tool to tap the arms plastic ends 
  else if (qpart==51){
    color("red") angleSup(false); 
    tsl (motor_offset_a-2.6) motorPlate();
    gray()
      tsl (motor_offset_a-motorplThk , 0, motorvpos)
        rot (0,90) nema17(); // ?? prefer stl import 
  }
  else if (qpart==52)
    mirrory() set_extruder(0,0,50);
  $details=true;
}

include <Z_library.scad>
//include <X_utils.scad>
STLDir = "STL_Big\\";
STLExtr = "STL_Dirext\\";

angleSize = 40; // size of the vertical iron angle 40
angleThk  = 2; // thickness of the vertical iron angle 2
angleradius = 2.5;
motor_offset  =  -37.694-3; // shall be calculated manually
//motor_offset  =  motor_offset_a--motorplThk;
// OpenScad does not allow re-allocation by a calculation result
motor_offset_a  = -(angleSize+angleThk)*.707-8;  

dia_ball= 7.9;    // REAL diameter of the ball
ball_play = 0.25; // diameter play of ball hole -adjust as needed- shall be relatively tight

holeplay = 0.16; //hole diameter increase - better not modify due to side effects
eardia = 14 ;

//beam_int_radius = 216; // radius on tip of steel angles - used as reference radius - different from other structures references in delta simulator

splate_offset = 5; //?? in top_renf
hvshift = 0; //2.25; // axis are shifted by 4.5 mm to cross, half value
axisclear = 6; //8.5; // defines distance between axis and carriage end note that the axis shift shall be taken into account. real clearance is axisclear-hvshift

extrusion = 0; // Rod diameter
rod_space = 0; // set two rods instead of one extrusion

car_hor_offset= 45; // = (angleSize+angleThk)*0.7+2+counterplThk+dia_ball*0.8;
hcar = 60;          // carriage height
car_vert_dist = 8.5; // vertical offset between the articulation and the top of the carriage - 8.5 for integrated carriage
top_clearance = 10;   // clearance between top of the carriage and top structure - internal base height added 

arm_space = 84; // space between the arms
wire_space= 68; // space between tensioning wire

dia_arm = 6;
railthk = 0; 
railwidth = 0; 
rail_base = 0;
frame_corner_radius= 0; 
frame_face_radius  = 0;

camPos =false;

$vpd=camPos?2800:$vpd;   // camera distance: work only if set outside a module
$vpr=camPos?[80,0,8]:$vpr;   // camera rotation
$vpt=camPos?[190,-67,390]:$vpt; //camera translation  */

// data specific to this printer
//coverPlateThk=10; // hinged cover thickness 

counterplThk = 5; // thickness of the counter plate locking angle

// motor and plate data
motorvpos = 25; // motor vertical position from plate surface
boltvpos = 5; //motor plate bolt vertical position from plate surface
//boltvpos2 = motorvpos+17; //motor plate bolt vertical position from plate surface
motorplThk = 3; // top thickness reinforcment. Reduced by 0.5 on bottom motor plate for deformation compensation

$bdist= angleThk*1.414+23.5; // new variable because openScad cannot reallocate variable with a result (...)

// carriage data 
// adjust fin parameters depending angle size
finextent = -13;
findec = -3;  
finangle = -12; 

carplthk = 2.5; // thickness of main plate
carBBdia   = 13;
carBBshaft = 4;
carBBthk   = 5;
//central pushed parameters
//* angle size 40
push_space = 17*2; //space between push bolts
carplwd = 38; //center carriage width
carpldp = 22; //center carriage depth
//*/
/* angle size 50  
finextent = -9;  
findec = -6;  
finangle = -7;
car_hor_offset= 53;
angleSize = 50; // size of the vertical angle 40
angleThk  = 3; // thickness of the vertical angle 2
$bdist = 32.5;
push_space = 22*2; //40->16.8*2 space between push bolts
carplwd = 48; 
carpldp = 27; 
//*/
push_ht1 = -hcar+5; // push bolt elevation
push_ht2 = -4;
cboltspace = angleSize*1.44+4; // space between bolts on the corners

// belt data
beltwd = 6; // belt width
holebeltdp = beltwd +3; // depth of hole belt -- used ??
beltoffset = -$bdist + beltwd/2; //belt CENTER offset is negative, belt is within the reference plane
belt_axis = beltoffset; // needed in main program ??? don't work
echo (belt_axis=belt_axis);

articulation_hspace =0; // difference between back and front plate height
htbb = 8+articulation_hspace; // bolts hole height/base
htbh = hcar-8; // bolts hole height/base
//carriage_accessories();
hhb=0; // vert wheel space

//*
//Face and side position calculation
minwd = 45; // minimum face width (for internal carriage)
sidethk=3.5;

//* Old D-Box data (iron angles size 35.5)
car_hor_offset= 44;
angleSize = 35.5; // size of the vertical iron angle 40
angleThk  = 1.5;
finextent = -15.4;
findec = -4.5;  
finangle = -10; 
//*/

cplFace = max ((angleSize+angleThk)*0.707+1.5, angleThk*1.414+27.5); // 27.5 minimum depth of centre
// reference face used for the carriage, need to clear the angle AND to left sufficient space for the internal carriage (for the belt)
deltasideface = (minwd+(cplFace+carplthk)*2)/2.828-(angleSize+0.8+sidethk);
dltsface = max (0,deltasideface);
extSdFace = angleSize+0.8+sidethk+dltsface; 
// */
thkNut4  = 3.2;
diamNut3 = 6.1; // checked
diamNut4 = 8.1; // checked

echo(beltoffset=beltoffset);
echo(angleSize=angleSize);
echo(angleThk=angleThk);
echo(arm_space=arm_space);
echo(wire_space=wire_space);
echo("Carriage offset",car_hor_offset);

$bArm=true;
module buildArm (ang_hor,ang_ver) {
  duplx(arm_space) {
    color("grey") 
      rot(ang_hor,0,ang_ver) 
        cylz (dia_arm, ar_length-dia_ball,0,0,dia_ball/2);
    color("silver") 
      sphere (d=dia_ball,$fn=64); // ball
  }
  if (wire_space) 
    color("white") 
      tsl ((arm_space-wire_space)/2)
        duplx(wire_space) 
          rot(ang_hor,0,ang_ver) 
            cylz (1.2, ar_length);  
}
  
$bCar=true; // allow the program to use below module instead of standard carriage
module buildCarAngle() { // modify to allow excentrate articulation (lowered) ??
  color ("red") {
    carriage_main();
    carriage_link();
    tsl (6, beltoffset, -35) 
      rot (90,0, 90)attbelt();
  }  
  /* tsl (0,-cplFace-6, -hcar/2) // abandoned
     rotz(90) mirrory() attbelt2(); */
  color ("lightgreen") carriage_center();
  carriage_accessories();   // # color
  
  ball_bar();
 // cubez (11.8,6,-300, 0,beltoffset,50); // belt check
}

module rodend() { // end of the rods (to screw balls)
  difference() {
    union() {
      hull() {
        cconez (9.5,7,2,16.5); // neutralise holeplay
        cubez(5,5,27, 2.4);   
      }    
      cylz   (8,27);
    }
    cylz (5.95,15, 0,0,-0.5);
    cylz (3.4,40, 0,0,-0.5);
    cconez (4,3.5,-2,-1, 0,0,27);
  }
}

module thumbwheelM4(ht=15) {
  dy=1.5;
  difference() {
    union() {
      for(i=[0:11]) 
        rotz(i*360/12)
          hull() {
            cylz (0.6, ht-1.8,  0,4.9+dy,-6.1);
            dmirrorx() 
             cylz (0.5, ht,  0.8, 3.7+dy, -7);
          }
      cylz (8+2*dy, ht,  0,0,-7);     
      // cyly (-5.5, 66, 0,0,0,50); //nut flat check
    }
    cylz (-4.1, 66); 
    hull() {
      cylz (diamNut4-0.1, 1, 0,0,-5, 6); 
      cylz (diamNut4+0.3, 1, 0,0,9, 6); 
    }
  }
}

module carriage_main () {
 // carplwd = 1.414*(angleSize-angleThk)+3 ; 
 // facewd = carplwd+4.8; // ?? geometric
  coneext = 8; 
  ball_ext = 1.3;  
  facewd = extSdFace*2.828-(cplFace+carplthk)*2;
  module sidecut(dir=1){
    hull() {
     cyly (-8,11,   dir*carBBdia/2,-angleSize,hcar/2-axisclear-14); 
      cyly (-8,11,   dir*(carBBdia/2+12),-angleSize,hcar/2-axisclear-6.3); 
      cyly (-8,11,   dir*carBBdia/2,-angleSize,-hcar/2+axisclear+22); 
      cyly (-8,11,   dir*(carBBdia/2+12),-angleSize,-hcar/2+axisclear+3); 
    }
    tsl (dir*16.8,-angleSize-10, -hcar/2)
      rot (0,38) cubey(8,20,20); // cut top corners
  }
  color(moving_color)  {
    difference() { 
      union() {
        cubez (facewd, carplthk,-hcar,  0,-cplFace-carplthk/2);
        diff() {
          hull () { // bottom reinforcement
            cubez (facewd, 7,9,  0,-cplFace-3.5,-hcar);
            cubez (facewd, 2,3,  0,-cplFace-1.5,-hcar+12.5);
          }  
          dmirrorx() 
            tsl (facewd/2-carplthk,-cplFace, -hcar-1)
              rotz(45) 
                tsl (-18,-carplthk*1.414-10)        
                  cube ([18,10,18]); 
        }  
        cubez (facewd+3.5, 7,-9,  0,-cplFace-3.5); // top reinforcement
        cubez (facewd+10, 5,-9,  0,-cplFace-3.5-2); // top reinforcement
        tsl (0,-car_hor_offset, -car_vert_dist) // top bar socket support
         rot (-35) 
            hull() {
              dmirrorx() 
                cylz (15,9, arm_space/2,0,-ball_ext+0.5, 48); 
              dmirrorx() 
                cylz (7,17, arm_space/2,0,0,48); 
            }  
        wsd=18;
        dmirrorx() // sides 
          tsl (facewd/2,-cplFace-carplthk, -hcar)
            rotz(45) 
               cube ([wsd,sidethk,hcar]);
        intcc = min (1.5+dltsface,3);
        rotz(45) cylz(7.5,-11, carBBdia/2+4.5,-extSdFace+1.3);//switch rod    
        dmirrorx() 
          tsl (0,0,-hcar/2+hvshift) // sides cones
            rotz (45) {
             // dmirrorz() 
                hull() duplx (-18.3) {
                  cconey (carBBdia+3,8, intcc,-2,carBBdia/2,-extSdFace+sidethk,hcar/2-axisclear);
                  cconey (carBBdia+3,8, -2.5,-2,carBBdia/2,-extSdFace,hcar/2-axisclear);
                }  
                hull() duplx (-13) {
                  cconey (carBBdia+3,8, intcc,-2,carBBdia/2,-extSdFace+sidethk,-hcar/2+axisclear);
                 // scale ([0.5,1,1])
                  cconey (carBBdia+3,8, -2.5,-2,carBBdia/2,-extSdFace,-hcar/2+axisclear);
                }
            }  
          // articulation 
        cpx = car_hor_offset-13.34;
        topext = car_hor_offset-cplFace+4.5;         
      } //:::::::::: then whats removed ::::::::::
      rotz(45) cylz(-2.5,33, carBBdia/2+4.5,-extSdFace+1.3); //switch rod    
      tsl(-9)  // view belt
        hull() 
          dmirrorx() {
             cyly (5,-55, 5,0,-15);
             cyly (5,-55, 5,0,-hcar+27);
             cyly (1,-55, 4,0,-hcar+16);
          }
      bar_holes (true); // holes for the ball support
      cubez (120,120,10); // cut top and bottom for cones
      cubez (120,120,-10, 0,0,-hcar);
      cubez (120,10,13, 0,-cplFace-12,-hcar-1); //cut  face  bot reinf
      tsl (0,-cplFace-15.89,-hcar+5)    
        rot(-34.8) cubez (120,10,15); //cut face      
      hull() // cut for top damper bolt 
        dmirrorx()
          cyly (-35,24.5,  7,-cplFace-15,push_ht2-23, 64);       
      hull() // top cut   
        dmirrorx()
          cylz (-30,33,  push_space/2+3,-cplFace-30,push_ht2, 64);   
      dmirrorx() {   // cut the bottom renforcment
        rotz (45) 
          cubez (60,40,-hcar-2, -60,carBBdia+20+2,1); // cut sides and cones ???
        // holes for push bolts
        cyly (4,-66,  push_space/2,0,push_ht1);
        cconey(9,4,2,-1, push_space/2,-cplFace-7,push_ht1);
        cyly (4,-66,  push_space/2,0,push_ht2);
        cyly (diamNut4,-thkNut4,  push_space/2,-cplFace+0.1,push_ht1,  6);
        cyly (diamNut4,-thkNut4,  push_space/2,-cplFace+0.1,push_ht2, 6);
      }
      dmirrorx() 
        tsl (0,0,-hcar/2+hvshift) // bearings shaft holes
          rotz (45) {
            dmirrorz() {
              cyly (-carBBshaft,99,   carBBdia/2,0,hcar/2-axisclear);
              cone3y (3,8.5,  0,2,4,    carBBdia/2,-extSdFace-2.5-6,hcar/2-axisclear);
            }  
            sidecut();
          }  
      tsl(6+0.5,0,-35) //holes for  Belt attach
        dmirrorz()  
          cyly (3,-15, 0,-cplFace+5,4);
    } // end difference
    diff() { // new addition
      dmirrorx() //socket support fins
        rotz (45) 
          tsl (-extSdFace+1.5,findec) 
            rotz (finangle)
              hull() {
                cylz (3,-hcar);
                cylz (5,-18, finextent);
              } 
           // then redrill  
        bar_holes (true); // holes for the ball support      
    }
    coneext = cplFace+beltoffset-5; //belt attach cone extension
    tsl (6+0.5,0,-35) //add Belt attach seat at the end
      difference() { 
        hull() 
          dmirrorz()  
            cconey (13+coneext,7,coneext,-2, 0,-cplFace-0.5,4);
        dmirrorz()  
          cyly (-3,25, 0,-cplFace+5,4);
      }  
  } // end color
  if ($ears)   // Mouse ears to limit warping
    dmirrorx() mirrorz() {
      ear (0.707*angleSize+14,-0.707*angleSize+7);
      ear (arm_space/2+5, -car_hor_offset+1);
      ear (arm_space/2+4, -car_hor_offset+8);
    }  
}  

module ball_bar (space=arm_space) {
  ball_ext = 1.3; // extent of the cup over ball medium plane
  dmirrorx() 
    difference() {
      tsl (space/2,-car_hor_offset, -car_vert_dist)
        rot (-35) hull() { //reduce diameter w/ holeplay coefficient=-0.5
          cylz (11,-ball_ext-1, 0,0,1,32,-0.5); 
          cylz (8,5.8, 0,0,0,32,-0.5); 
        }  
      tsl (space/2,-car_hor_offset,-car_vert_dist) 
        sphere((dia_ball+ball_play)/2, $fn=40);   
    }
}

module bar_holes (main=false) {
  ball_ext = 1.3; // extent of the cup over ball medium plane
  dmirrorx() {
    cyly (4.2,-66,  push_space/2,0,push_ht2);  // push holes
    tsl (0,-car_hor_offset,-car_vert_dist) {
      tsl (arm_space/2) 
        sphere((dia_ball+ball_play)/2, $fn=40);   
      rot (-35) {
        cconez (2,10,-4.2,0,  wire_space/2);
        tsl (wire_space/2) 
           rot (0,0) cylz (2,100,  0,0,-0.7); //wire holes
      }  
    }  
  }
  cylz (-2.5,66,      0,-car_hor_offset+3.8); // top bumper fixation
  tsl(0,-car_hor_offset, -car_vert_dist) // holes for ball sockets
    rot(-35) 
      dmirrorx() hull() {
        //cylz(11,8+10, arm_space/2,0,-ball_ext-8,32,0); 
        cylz (11,-ball_ext-10, arm_space/2,0,1,32); 
        cylz (8,6, arm_space/2,0,0,32);    
      }  
  if (!main)
    cconez (30,6,3,-2,  0,-car_hor_offset+3.8,-car_vert_dist-5.5); 
}

module carriage_center() {
  dshaft = 4;  

  dpthk = -angleThk*1.414;
  BBdec = -8.6+dpthk;
  difference() {
    union() {  
      difference() { 
        cubez (carplwd,carpldp,-hcar, 0,-carpldp/2+dpthk-5.3);
         //::: then whats removed :::
        hull () { // central hole
          dmirrorx() {
            cylz (3,-hcar-2, push_space/2-2.8,  -carpldp+dpthk-2.3,1);
            cylz (3,-hcar-2, 12.2,-20.8+dpthk,       1); 
            cylz (3,-hcar-2, 9,   -16+dpthk,         1);
          }  
        } 
        cubez (carBBthk+1,40,carBBdia+2,  0,0,-6-carBBdia/2-1); // top bearing space
        hull() { // bottom bearing space
          cubez (carBBthk+1,40,carBBdia,  0,0,-hcar+6-carBBdia/2);
          dmirrorx()
            cyly (-2,40,   2,0,-hcar+6-(carBBdia+0.5)/2+13);
        }  
        tsl (0,dpthk+2.1)
          dmirrorx () { // angle cutters
            rotz(44.6) 
              cubez (20,70,-hcar-2,  7.5,-30,1);
            tsl (push_space/2, -carpldp)
              rotz(33) 
                cubez (20,70,-hcar-2, 10,0,1);
          }
        tslz (-hcar/2) // bearing shaft holes
          dmirrorz() 
            cylx (-dshaft,66,  0,BBdec,hcar/2-6); 
        hull() { // middle remove
          cylx (-35,99, 0,-0.8+dpthk+5,   -29,    80);  
          cylx (-1,99,  0,-0.8+dpthk+12,-hcar+27.5-12);   
          cylx (-1,99,  0,-0.8+dpthk-12,-hcar+27.5-12);   
        }
       } 
       // then new additions
       tslz (-hcar/2) // add cylinders for bearing side stop
         difference() {
           dmirrorz() 
             dmirrorx() 
               cylx (dshaft+3,1,  carBBthk/2,BBdec,hcar/2-6); 
           dmirrorz() 
             cylx (-dshaft,66,   0,BBdec,hcar/2-6); 
         }
        // ends of push bolts
        dmirrorx() 
          tslz ((push_ht2+push_ht1)/2)
            dmirrorz () 
              tsl (push_space/2,-carpldp+dpthk-5.3,(push_ht2-push_ht1)/2)
                cconey (8.5,0,2.5,3.8);
      } //::: end union, so whats removed :::
      cubez (100,100,-10, 0,0,-hcar+0.01); // cut bottom push cones
      hull() { // middle opening for belt attach seats
        dmirrorx() {
          cyly (-16, 12, 7,-30+dpthk,-hcar+21);
          cyly (-5, 12, 12.5,-30+dpthk,-30);
          cyly (-2, 12, 4,-30+dpthk,-15);  
        }
      }
      dmirrorx() { //holes for push bolts
        tslz ((push_ht2+push_ht1)/2)
          dmirrorz () 
            tsl (push_space/2,-carpldp-angleThk*1.414-4.3,(push_ht2-push_ht1)/2) 
              cconey (4,2.5,1,-2);   
      }    
  } // end 1rst difference
  if ($ears) {
    ear (0,-12, -hcar); // Mouse ears to limit warping
    dmirrorx() 
      ear (carplwd/2+2,-carpldp-7, -hcar);
  }  
   //carriage_accessories(); 
  //cubez (1.8,6,150, -6,beltoffset,-50); // belt check
}  

module carriage_link() {
  color(moving_color)  {
    //tsl (1,3,-hcar) cylinder (d=3, h=hcar); //test length
    difference() {
      tsl (0,0,-hcar/2){
        hull()  {
          dmirrorx() dmirrorz()     
            cyly (12,2.5, 9,0,hcar/2-axisclear);  
        }    
        dmirrorz()  
          dmirrorx()  
            hull() {  
              cyly (13,2.5, 8,0,hcar/2-axisclear);  
              rotz (45) cyly (8,3,  6.5,-15,hcar/2-axisclear);   
            }
      } //::: then whats removed ::: 
      tslz (-hcar/2) 
        dmirrorx() {
          hull() 
            dmirrorz(){ 
              cyly (16,4, 16,-0.1,hcar/2-20);
              cyly (6,4, 25,-0.1,hcar/2-4);
            }  
          rotz (45) 
            dmirrorz() {
             cyly (-carBBshaft,111,  carBBdia/2,0,hcar/2-axisclear);
             tsl (carBBdia/2,carBBdia/2+5.1,hcar/2-axisclear)
               cconey (7.5,4,-2.2,-8, 0,-18.5);  // cone head
            }  
        }  
     }  
  }
  if ($ears) 
    tsl (0,0,-hcar/2)
      dmirrorz() dmirrorx()
        cyly (eardia,0.5, 16,2,hcar/2+2);
}  

module beltlocker2(thk) {
  difference() { 
    union() { 
      hull() {
        cylx (-5, 8,    0,14,   1);
        cylx (-5, 8,    0,14.5, 1);
        cylx (-5, 8,    0,14,1 );
        cylx (-1.5,8,   0,18.2, -0.7);
      }  
      hull() {
        cylx (-1, 8,  0,18.3,5); 
        cylx (-1, 8,  0,32.5,5);
        cylx (-5, 8,  0,23.7,1.7);
      }
      hull() {
        duply(6) duplz(-1.6)
          cylx (-1, 8,  0,30,5); 
        cylx (-1, 8,  0,36,3); 
      } 
      hull() {  
        cylx (-2.5,8,     0,31.5, -1.25 );
        cylx (-0.8,8,     0,28.6, -2.12 );
        duplz(1.5)
          cylx (-1, 8,  0,36,-2); 
      }  
    }  
    cubez (20,30,-5, 0,22,-thk/2);
  }
//*test tensioner belts
  *tsl (0,20.2)
     rot(40) cubez (6.5,2,100, 0,0,-50);
  *tsl (0,28.5)
     rot(-56) cubez (6.5,2.5,100, 0,0,-50);
  *tsl (0,0,50.2)
     cubez (6.5,100,2.2, 0,0,-50);
 //*/ 
}

module attbelt() { // double end belt locking system
btwd = 6.6;   
thk = 8.2;
wd  = 10.5;  
boltsp = 4;  
  difference() { 
    union() {
      difference() {
       * cylz(1,1);
        hull() 
          dmirrory() dmirrorz()
            cylx (-1,wd, 0,35.5,3.5);   
         //::: then whats removed :::
        dmirrory() { 
          tsl (0,27)
            hull () 
              dmirrorx() dmirrory() 
                cylz(-0.8, 66,  (btwd-0.8)/2, 17.5); 
          cylx (-3.25, 66, 0, boltsp,0);
        }
        cubez (2.7,5.5,20, 1.5,boltsp, -10);    
        cubez (2.7,5.5,20, -1.5,-boltsp, -10);    
      }
      tsl(0,-0.5,-1.5)  beltlocker2(thk); 
      tsl(0,0.5,1.5)  rot(180) beltlocker2(thk); 
    }
  }  
}

module carriage_accessories() {
  BBdec = -8.6-angleThk*1.414; 
  module BBbolt (dir=1) {
    tslz (-hcar/2+dir*hvshift)
      rotz (dir*45)
        dmirrorz() {
          gray() {
            cyly (carBBshaft,-40,
              dir*carBBdia/2,-6.5,hcar/2-axisclear);
            
            cyly (diamNut4,3.2,   
              dir*carBBdia/2,-angleSize+1+carBBthk,hcar/2-axisclear,6);
            cyly (diamNut4,-3.2,  
              dir*carBBdia/2,-extSdFace-2.5,hcar/2-axisclear,6);
            cyly (diamNut4,-3.2,  
              dir*carBBdia/2,-14.5,hcar/2-axisclear,6);
            tsl (dir*carBBdia/2,-6.5,hcar/2-axisclear) // cone head
              cconey (8,4,-1.8,0);
          }
          silver() 
            cyly (carBBdia,carBBthk, 
              dir*carBBdia/2,-angleSize+1,hcar/2-axisclear);
        }
  }
  BBbolt();
  BBbolt(-1);
  gray()  {     
    dmirrorx() { // push bolts
      cyly (4,-10, push_space/2,-cplFace+2,push_ht1);
      cyly (4,-10, push_space/2,-cplFace+2,push_ht2); 
    } 
    tsl (6+0.5,0,-35)
      dmirrorz()  // belt attach
        cyly (3,-15, 0,-cplFace+5,4);
   //cylx (-4,arm_space, 0,-car_hor_offset,-car_vert_dist);  // ball axis
  }   
  silver() 
   tslz (-hcar/2)
      dmirrorz() { // central bearing
        cylx (-carBBdia,carBBthk, 0,BBdec,hcar/2-6);     
        cylx (-carBBshaft,14,     0,BBdec,hcar/2-6);     
      }
 dmirrorx() 
   tsl (arm_space/2,-car_hor_offset,-car_vert_dist) {
     color ("silver")  
       sphere(dia_ball/2, $fn=40);
     *cylz (8,-200, 0,0,-4);  // vertical arms for clearance check        
   }  
} // carriage accessories

//--------------------------------------------------------
module set_extruder (xpos=0, ypos=0, zpos=0) { 
diagear = 9; // hobbed insert diameter  
BBposx = 0;  
BBpos = -6.5-diagear/2-0.5-0.3; //Position of the ball bearing/motor axis  
dec = -4.5;  // filament axis dist to motor axis
angle = 24;  // filament angle / vertical
tens_angle = -87; // bolt tensioner angle (relative to lever)  
tens_h = 22;  // one coordinate of tensioner rotation axis position
wdist= -11.5;  // distance between filament axis and motor plane
  // extruders are rotated and they are designed 'flat on table' 
   tsl (xpos+31,ypos,zpos) 
      rot (0,90,-90) {
        color ("aqua") rot(180) 
          import (str(STLExtr,"Dirext_08_Simple_extr_base.stl"));
        gray() rot(180) nema17(); // ??
        rotz (angle) {
          color ("yellow") {// filament
            cylx (1.75,42,   -10,dec,wdist);
            tsl (-10+42,dec,wdist) 
              rot (0,-14,-12) {
                cylx (1.75,28);
                tsl (28) 
                  rot (0,14,-7) 
                    cylx (1.75,250); 
              }  
          }  
          white() cylx (4,-60, -10,dec,wdist);
          color ("orange") 
            tslz (wdist)
              rot (90) import (str(STLExtr,"Dirext_22_Lever_NutM4.stl"));
          color ("grey") {
            cylz (-13,5,  BBposx,BBpos,wdist); // bearing
            cylz (-4,15, BBposx,BBpos,wdist); // bearing shaft
            tsl (tens_h, 5, wdist)  // tensioner bolt
              rotz(tens_angle) 
                cylx (4,-45,  2); 
          }
          blue() tsl (tens_h, 5, wdist)  // tensioner arti
            rotz(tens_angle)
              rot (-90) 
                import (str(STLExtr,"Dirext_30_Tensioner.stl"));
        }  
        color ("lime") rot(90) mirrory()
          import (str(STLExtr,"Dirext_10_Simple_extr_antivib.stl"));
        red() rot (0,180) 
          import (str(STLExtr,"Dirext_14_Simple_extr_filguide_vert.stl"));
      }
}

//-- Columns ------------------------------------------------------------

module angleplug (dec=6.8) {
  difference() {
    union() {
    cubez (angleSize+6, angleSize+6, 1.8);
      difference() {
        cubez (angleSize-angleThk*2-0.3, angleSize-angleThk*2-0.3, 10);
        cubez (angleSize-angleThk*2-3.6, angleSize-angleThk*2-3.6, 20, 0,0,-1);
        rotz (45)    
          cubez (100,100,100, -50-(angleSize-angleThk*2-0.3)*0.707+1.6,0,-10);
      }  
    }
    //::::::::::::::::
    rotz (45)    
      cubez (100,100,100,  50+dec,0,-10);
  }  
}

module top_renf (ht=12.5, foot=false) { // wall attach
  screwoffset = 9;  // hole aligned with foot
  holedec = 15;
  htp = min (3, ht);
  finang = (foot)?18:26;
  finendht = (foot)?ht/2.5:ht;
  difference () {
    union() {
      dmirrory() {
        if (!foot)
          rotz (45) 
            cubez (3.5, angleSize-3, ht, 3.5/2, angleSize/2-0.1);    
        tsl (0,angleSize*0.7-1)
          rotz (finang) hull() {
             cubex (-3,3,ht,        2,0, ht/2); 
             cubex (-1,3,finendht, -angleSize*0.6,0,finendht/2); 
          }  
      } 
      cubex (-5-splate_offset,16,ht,  splate_offset,0, ht/2);  
      hull() {
        cubez (-1,angleSize*1.4+3.1,htp, -angleSize*0.7+2.8);
        cubez (4,angleSize*1.4+23,htp, splate_offset-2); 
      }  
      cubez (4,angleSize*1.4+23,ht, splate_offset-2); 
    //  cylx (10, splate_offset, 0,0,15); // check
    }
    rotz (135) 
      cubez (angleSize+2,angleSize+2, ht+10, angleSize/2+1, angleSize/2+1        ,-1); 
    dmirrory() {
      cylx (-4,22, 0,angleSize*0.7+6,htp+(ht-htp)/2); 
      rotz (45)
        cylx (-4,22, 0,angleSize-8,htp+(ht-htp)/2);
      if (foot) // place for screws aligned with foot screw
         dmirrory() 
          rotz (45) 
            cylz (-4.2,22, screwoffset,holedec); 
    }  
  }
}

module angleSupHoles (hldia, screwoffset, screwoffset2, holedec)  {
  hull() 
  duplx (4)
    cylz (-4.2,66,beltoffset-2,0); // belt tensioner bolt/nut space 
  dmirrory() 
    cylz (-2.5,66,beltoffset,6.5); // belt tensioner bolt/nut space 
  //cylz (diamNut4,6, beltoffset,0,4, 6); // belt tensioner nut check
  dmirrory() 
    rotz(45) {
      cylz (-hldia,66, screwoffset,holedec);
      cylz (-hldia,66, screwoffset2,angleSize+8);  
    }   
}

module nut_retainer() {
  diff() {
    hull() 
      dmirrorx() dmirrory() 
        cylz (8, 6, 3,7);  
    cylz (-4.1,66);
    cylz (diamNut4, 3.2,0,0,-0.01,6);
    dmirrory() 
      hull() 
        dmirrorx() 
          cylz (-3,66, 2,6.5); 
  }
}

module angleSup(foot = true) {
 // tsl (beltoffset, 0,4.6) nut_retainer(); // test
  agr = max (0, angleradius-0.5); // make internal radius smaller
  screwoffset = 9; // horizontal panel screw position
  screwoffset2 = 10;
  holedec = 15;  
  hldia = 4.2;
  diacone = 16; // cone base diameter
  //support side width = diacone/2+screwoffset = 8+7.5 = 15.5; ??
  diatop = 12; // cone top diameter
  diaconew = 19.5; // cone wall diameter
  angleBaseThk = 1.5;
  coneht = 2; // cone height
  conebaseht =2.5; // base of the bottom cones
  suppThk = 3.5; 
  sdthk = 3.6; // motor support side thickness
  angsupthk = 3.5; // angle side support thickness
  
  cubeSizeExt  = (foot)?6.5:8.5;
  angleBaseExt = (foot)?23.5:motorvpos-angleBaseThk+12;
  angleCutBase = (foot)?4.5:-1;
  mspos = -angleSize*0.7+9.5; // used for motorplate bolting 
 // profileThk   = (foot)?angleThk+0.25:angleSize*0.7;
  screwht = (foot)?13.5:angleBaseExt/2+angleBaseThk;
  dec=1; // rod position
  rodextend = 17; // rod support length
  htrod =(foot)?7:11;
  difference () {
    union() {
      if (!foot)
        hull() { //base plate
          dmirrory() {
            rotz (45) {
              cylz (diacone, angleBaseThk, screwoffset,holedec);
              cylz (diacone, angleBaseThk, screwoffset2,angleSize+8);     
            }  
            if (!foot) // if diacone too small, extend base to motor face
              cylz (6, angleBaseThk, motor_offset_a+3, 31); 
          } 
          if ($clearcar)
            cylz (16, angleBaseThk, 9); // to clear carriage bolting
        }
      if (foot) {
        dmirrory() { 
          rotz(135) {
            hull() {
              cylz (suppThk*2,angleBaseExt);
              cylz (suppThk*2,angleBaseExt, angleSize+2);        } 
            cconey (diaconew, 10,-2.5, angsupthk, //angle screw holes reinf
                     angleSize/2+angleThk/2+1,0,screwht); 
          }  
          rotz (45) { // rods attachs
            tsl (0,angleSize+10.5)
              hull() // triangle rods extension
                rotz(15) {
                  cyly  (8.5,-rodextend,  dec, 0, htrod);  
                  cubey (2,-rodextend,4,  dec,0,2); 
                }
          }
        }    
      }
      else { // top support
        dmirrory() {
          rotz(135)
            difference () {
              hull() {
                cylz (suppThk*2,angleBaseExt ,0,0,angleBaseThk-0.1);
                cylz (suppThk*2,angleBaseExt, angleSize+0.8, 0,angleBaseThk-0.1);          
              } 
              cubez (100, 10, 100,  -10+50, 5, -10);
            }
          cylx(6,motor_offset_a-mspos,       mspos,cboltspace/2,boltvpos); // local reinf for motor bolt hole
          cubex (motor_offset_a-mspos,6,boltvpos,  mspos,cboltspace/2, boltvpos/2);
          rotz (45) 
            filletx (-3, -angleSize,-2,-suppThk, angleBaseThk);
          pos = (angleSize+0.5)*0.707;
          dp = (-motor_offset_a-pos+suppThk*0.707-sdthk*0.707)*1.414;
          tsl (-pos+suppThk*0.707, pos+suppThk*0.707) {
           rotz(45) 
             cubez (dp,sdthk,motorvpos+21,  -dp/2, sdthk/2)  ;
          } 
          rotz (45)  {
            tsl (0,angleSize+10.5)
              hull() // triangle rods extension
                rotz(15) {
                  cyly  (8.5,-rodextend,  dec, 0, htrod);  
                  cubey (1,-rodextend,4,  dec-2,0,2); 
                }            
            cconex (diaconew, 10,coneht,angsupthk,0,angleSize/2+angleThk/2+1,screwht);
          }  
        } 
      } //end top support 
      if (!foot)
        difference() {
          hull() 
            dmirrory() {
              rotz (45) 
                cconez (diacone, diatop, coneht,conebaseht, screwoffset,holedec);
              cconez (diacone, diatop, coneht,conebaseht, -14,9);
            }  
          rotz (135) cubez (50,50,99, 25,25, -1);
        }
      hull() {
        dmirrory() 
          rotz (45) {
            cconez (diacone, diatop, coneht,conebaseht, screwoffset2,angleSize+8);
            if (foot) 
              cconez (diacone, diatop, coneht,conebaseht, screwoffset2-4,angleSize-2);
            else
              cconez (diacone, 10, coneht,conebaseht, 1,angleSize+2.5); 
          }
        }    
    } //::: then whats removed :::
    rotz (135) 
      tslz (angleCutBase) 
        if (foot)
          profile_angle (angleSize+1.5, angleSize+1.5, 4, 99); 
        else 
          difference() {
            cube ([angleSize+0.5,angleSize+0.5,99]); 
            rotz (45) 
              tsl ((angleSize+angleThk+1)*0.707, -50) cube ([20,100,99]); 
          } 
     hull() {
        cylz (1,66,  -1,0,angleCutBase); // angle internal cut hole
        dmirrory()   
          cylz (1,66,  -5.2,4,angleCutBase); // angle internal cut hole
     }     
    dmirrory() {
      rotz (45) 
        tsl (0,angleSize+10.5)
          rotz(15) {
            cyly  (-4,44,  dec, 0, htrod);  
            cyly  (8.6,-4.2,  dec,-rodextend, htrod);  
          }  
      rotz (45) {
        cylx (-hldia,66, 0,angleSize/2+angleThk/2+1,screwht); 
        cylz (10,100,    screwoffset2,angleSize+8,conebaseht+coneht-0.02, 40);  
      } 
    }  
    angleSupHoles (hldia, screwoffset, screwoffset2, holedec);
    if (!foot) {
      dmirrory() 
        cylx(-3,99,0,cboltspace/2,boltvpos); // stepper plate attach 
      hull() dmirrory() // cut face  - neutralise holeplay
        duplz (-5)
          cylx (8.2,-6, motor_offset_a,cboltspace/2,5, $fn,0); 
    }  
    cubez (120,120,-3);
  } // end first difference
  // complementary parts -in above cut zone
  if (!foot) { // top support
    difference() {
      union() {
        lg=2*((angleSize+0.5+sdthk)*1.414+motor_offset_a); 
        cubez (2.5,lg,motorvpos+21,   motor_offset_a+1.25);
        hull () {
          cubez (2.5+motorplThk ,lg-motorplThk*2,-9.5,  motor_offset_a+1.25-motorplThk/2,0,motorvpos+21);
          cubez (2.5,lg,16,  motor_offset_a+1.25,0,motorvpos+5);
        }
        hull () {
          cylz (6,1, beltoffset);  
          cubez (1,6,1, motor_offset_a+1);
        }
      }
      hull() {
        cylx (-22.5,99,0,0,motorvpos);
        dmirrory() cylx (-1,99, 0,4.5,motorvpos+11); // bridge atop center hole
      }  
      dmirrory() {
        cylx (-3,99, 0,15.5,motorvpos+15.5);
        cylx (-5.7,99, 0,15.5,motorvpos-15.5);
        cylx (-3,99,0,cboltspace/2,boltvpos); // redrill
      }
      cylz (-2,66, beltoffset);  
    } 
  }
  //if (foot) 
  top_renf(12.5, true); // ??
} // anglesup

module tensionerAngle() { // build pulley tensioner
htTens=15;
htSides= 20; 
  tslz (-20)
    difference() {
      union() {
        tsl (beltoffset) {
          hull() { // pulley space and top
            dmirrory() dmirrorx() cylz (8,htTens,4.4,6);   
            cylz (13.5,1,0,0,-8);
          }
          cylz (13.5,10,0,0,-15);
          dmirrorx()  // bearing cones
            cconex (htTens+2,8,2.5,-1,  8.1,0,htTens/2);
         }
        //angleThk=3;
        diside = 8+angleThk;
        tsl (-angleSize*0.71-angleThk*0.7-0.6) {
         dmirrory() { // sides 
            hull() {
              cylz (diside,htSides, diside/2-3.5,angleSize*0.71-angleThk/2+0.2, -htSides+htTens);
              cylz (2,htSides, -0.5, angleSize*0.71-angleThk/2+0.2-7, -htSides+htTens);
            }  
            tsl (-1.75) 
              filletz (2, htTens, 3.23,10); 
          }  
          cubez (3, 40, htSides,  0, 0, -htSides+htTens);   
        }
      }  //::: then whats removed :::
      cubez (25,25,2, beltoffset, 0,htTens);
      tsl (beltoffset) { // pulley hole
        hull() {
          dmirrorx() dmirrory() cylz(3,htTens+1, 3.3,5.5);
          cylz (8.6,1,0,0,-6.6);
        }
        cylz (8.6,8, 0,0,-12.5);
        cylz (-4,99);  
      }  
      cylx (-3,99, 0,0,htTens/2); // pulley axis
      cconex (6.2,2.8, 1.2,-2, beltoffset-10.3,0,htTens/2); // countersunk
      
      rotz (135) 
        tsl (-0.1,0,-20) 
          profile_angle (angleSize+0.8, angleSize+0.8, angleThk, 99); 
    }  
    tsl (beltoffset,0,0-20)
    difference() { // pseudo 'washers' - bearing width : 8 mm
      dmirrorx()
        cconex (9,5.5,-1,-1, 5,0,htTens/2); // pulley axis
      cylx (-3,99, 0,0,htTens/2); // pulley axis
    }
}

module motorPlate() { // ref on the base (plate top surface)
  dp=10;
  difference () {
    union() {
      cubez (dp, cboltspace+8, motorvpos-22,   -dp/2);
      hull() {
        cubex (motorplThk -0.5, cboltspace+8, 2, 0,0,1);
        dmirrory() {
          cylx (8,motorplThk -0.5, 0,cboltspace/2, boltvpos);
          cylx (9,motorplThk -0.5, 0,15.5, motorvpos-15.5);
        }  
      }
      dmirrory() hull() {
        cylx (8,-dp, 0,cboltspace/2,boltvpos);
        cylx (8,-dp, 0,25.5,boltvpos);
        cylx (2,-dp, 0,18,boltvpos-3);
        cylx (2,-dp, 0,30.5,boltvpos-3.5);
      }  
    }  // then whats removed 
    dmirrory() cylx (-3,99, 0,cboltspace/2,boltvpos);
    tslz (motorvpos)
      dmirrorz() dmirrory() cylx (-3, 99, 0, 31/2,31/2); // stepper holes 
  }  
}

module fan_guard (clr = "red") { // fan guard for fan 40x40, used also as support, screws square 23x23
  color(clr) 
  difference() {
    union() {
      difference () {
        hull() dmirrorx() dmirrory() cylz (8,1.5, 23,23);
        cylz (-39,55);
        dmirrorx() dmirrory() {
          cylz (-3,55, 16,16); 
          cylz (-3,55, 23,23);
        }
      }  
      cylz (18,1.5);
      for(i=[0:7]) 
        rotz(i*45+22.5) 
          rot(180) cylx (2.7,20, 0,0,-0.7, 3); // triangle
    }
    cubez (60,60,2, 0,0,1.52);
  }
}

$bEffector=true;
$chimera =false;

module buildEffectorAngle() { // not used yet
pospfan = [0,23,36.3-24.5]; // part cooling fan position - shall also create a variable for angle ??
fanang = -30;

  if  ($chimera) {
    color ("yellow")
      rotz(0) 
        tslz (4) 
          rot(180) 
          import("duct_Chimera_square.stl");
    color ("black") rotz(0) {
      tsl (-27,0,38+4) // part fan
        build_fan(40,10);
      tsl (12,0,38-15+4) // hotend fan
        rot(0,90) build_fan(30,10); 
    }  
  }
  else {
    color ("yellow")
      tslz (eff_height) //???
        rotz(0)
          import("Effector_sym.stl");
    color (moving_color) 
      rotz(0)
        import("Effector_sym_supp.stl"); 
    translate (pospfan) // part cooling fan
      tsl (0,0,2)
        rot(fanang) build_fan(30,10);
  }
}

$bHotend=true;
module buildHotendAngle() { // not used yet ??
  if ($chimera) {
    color("silver")
    rotz(-90)
      tsl (0,3,27)
        rot(90,0,180)
          import("Chimera_x.stl");  
  }
  else
    tsl (0,0,0) rotz(-90) {
      color("silver")
        tsl (0,0,36.3-68.4) // 6.6 mm between vertical positions
            import ("Prometheus3nuts.stl");
      tsl (8,0,36.3-31.3) // hotend fan
            rot(0,90) build_fan(25,10);  
    }
}

module taptool() {
  difference() {
    union() {
      dmirrorx() 
        hull() {  
          cubez (1,10,5.5, 4.5);
          cylz (2.5,9, 20);
        }
      hull() {  
        dmirrorx() 
          cubez (1,10,5.5, 4.5);
      }  
    }
    cylz (diamNut4, 3.2, 0,0,2.4, 6);
    cylz (-4, 33);
  }    
}

$bArm = true;
module buildArm (ang_hor,ang_ver) {  
  duplx(arm_space) 
    rot(ang_hor,0,ang_ver) arm(ar_length);
  if (wire_space) 
    color("white") 
      tsl ((arm_space-wire_space)/2)
        duplx(wire_space) 
          rot(ang_hor,0,ang_ver) 
            cylz (1.2, ar_length);  
}
  
module arm (lg=305) {
  carblg = 140;
  alulg = lg-carblg;
  color ("silver") sphere(4);
  color ("black") 
    cylz (4,carblg);
  color ("lime") 
    cylz (8,27, 0,0,carblg-22+alulg-15);
  color ("lightgray") {
    cylz (6,alulg, 0,0,carblg-22);
    cylz (4,-30, 0,0,lg);
  }  
}

module switchsup() { // switch support - abandoned
   thktop = 30;  
   difference() {
     union() {
       hull() {
         dmirrorx() cylz (7.5,-3, 8,-1.25); 
         cubez (21,4, -3, 0,-3);    
       }  
       hull() {  
         cylz (10,-24-thktop);    
         cubez (6,4, -24-thktop, 0,-3);    
       }  
     }  
     dmirrorx() cylz (-3,11, 8,-1.25);  
     cubez (6, 13, 13.5, 0, 5, -22-thktop);
     cubez (4, 20, 13, 0, 0, -22-thktop);
     cubez (3, 4, -19-thktop, 0, -3.5, 10);
   }  
}
//rot (90) switchsup();

//== extract from library ================================================
module tslz (mz) { translate ([0,0,mz]) children();}

module ear(x=0, y=0, z=0) {
   cylz (eardia,0.5, x,y,z);  
}

