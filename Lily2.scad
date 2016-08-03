include <Z_library.scad>
include <X_utils.scad>
xpart=0; // neutralise X_utils demo
// Data Set for Hexagon Minimum Delta printer -LilY - January 2015
// To be build from scratch (Lily 'S'), or with  standard Fisher components (Lily 'F')
// Copyright Pierre ROUZEAU AKA 'PRZ'
// Program license GPL 2.0
// documentation licence cc BY-SA and GFDL 1.2
// Design licence CERN OHL V1.2

part=0;
thkglass=3; // glass thickness for glass retainers
//$noTop = true;
//$noTopSup = true;
//$noCover = true;
$boxed = true;

if (part) { // set part =0 (no part) for delta simulation
  $details=true;
  $fn=32;
  if (part==1) foot(); //foot with elevated support, for Fisher std rods
  else if (part==2) foot2(); // base to use with wallsup (no surelevation)
  else if (part==3) wallsup();  // wall support, in conjunction with above part  
  else if (part==4) {
    motor_support(); 
    *tsl (0,0,-34) foot2()
    *tsl (0,motor_offset)rot(-90)nema17();
  }
  else if (part==5) if ($isAngle) carriage_main();  else carriage();   
  else if (part==7) tensioner(true); // tensioner for flanged bearings  -- add a washer between bearings
  else if (part==8) duplx (25,2) rot (180) twheel(); // option: tensioner wheel
  else if (part==9) duply (10,7) arm_junction(); // arms junction
  else if (part==10) dmirrorx() tsl (28) rot (90-22.5) extruder_bracket(); // extruder plate attach 
  else if (part==11) { 
    boardsup();
    tsl (0,-10) mirrory() boardsup(1);}
  else if (part==12) duplpartx (5, 18,11) rot(90) glasslock(thkglass);  // parameter is glass thickness
    
  else if (part==21) ref_stick();  // print the reference stick  
    
 //-- accessories -----------------------------------   
  else if (part==22) Lily_plate(); // The final touch: name plate "Lily"
  else if (part==23) SSR_protect(); // electrical shield of SSR's     
  else if (part==24) PS_retainer(); // Fisher power supply retainer (PS independant computer block type, Section 62x40)
  else if (part==25) duplx(55) hiding_plate(); // Aesthetic: hiding screws
  else if (part==26) duply(20) door_pad(22);   
  else if (part==27) bed_cable_insul(75); // protect bed supply cable   - lily big
  else if (part==28) {
    duplx (10,5)cablestop();
    duplx (10,2,50)cablestop(6);
  }
  else if (part==29) rotz(90) ESD_shield(32,38,46);
 //-- panels ------------------------------------   
  else if (part>50 && part<60) {
    $details=true;
    projection() 
      rot (0,90) panel(part-50); // for panels - holes  
  }  
  else if (part>=60 && part<70) {
    $details=true;
    projection() 
      panel(part-50); // for panels - holes        
  }  
}

Delta_name = str("Lily F 131/500 by PRZ");
holeplay = 0.16; // added diameter to ALL cylinder (internal/external)
ballplay = 0.14; // added play to ball diameter - shall give tight socket
dia_ball = 5.96; // real ball diameter

housing_base=0; // no housing
diamNut3 = 6.1; // checked
diamNut4 = 8.1; // checked
frame_rot = 0;
move_rot  = -30;

// Data for radius 131 and height between plate 500, called HXMF 131/500
Effector_STL= "STL/Lily_30_effector_F.stl";
Hotsup_STL = "STL/Lily_31_hotend_support_F.stl";
Hotend_STL = "";

//radius 139 correspond to reference measure of 186mm
echo ("reference_l",reference_l());

htotal = 426+45-13+42; // total height between plates 
//echo (htotal=htotal);

hbase=0; // used in simulator. the floor is at level 0
bed_level = 0.1; // > 0 To show surface
extrusion = 0;  // stop the simulator rod module
rod_dia   = 8;  // Rod diameter
lbearing_dia = 15;
rod_space = 42; //set two rods instead of one extrusion 42 is same as Fisher 1.0

rod_base  = 46; // height of the base of the rods

top_panelthk =18;
cover_panelthk =10; // cover over steppers
basethk  = 18;
panelthk = 18; // structural sides
boxpanelthk = 10; //closing panels, door, etc.

car_hor_offset= 16; // horizontal offset of the articulation (/ rod axis)
hcar = 16; // height of the carriage
car_vert_dist = 4.5; // distance between articulation axis and carriage top
top_clearance =  8 + 46; // motor 43 // clearance between top of the carriage and top structure - 8 is height of rubber pads, 46 is height of motor support

eff_hor_offset= 28; // offset of the effector (arm articulation axis/center)
eff_vert_dist = 0;  //vertical  distance betwwen effector plane reference and articulation axis
arm_space= 58;  // space between the arms
wire_space= 46; // space between the wires

ball_ext =1.25; // the ball cups extend over median plane by this value
dia_arm = 3;
railthk =0; 
railwidth =0; 
rail_base=0;
frame_corner_radius=0; 
frame_face_radius= 0;
corner_offset=14;
hotend_offset = 6;
hotend_dist = 17; // for STL htend file import position

beltwd=6; // belt width
belt_dist = 2; // belt FACE distance with rod axis
belt_axis = beltwd/2-belt_dist; // belt axis distance to rod axis
//echo (belt_axis =belt_axis);

motor_offset = -8; // face of the motor distance with the rod axis
motor_voffset = -23; //motor axis position/bottom of top plate

spool_diam = 200;  
$spool_rot = [0,0,0];
$spool_tsl = [80,60,htotal+18+15];

$bedDia=200; // force the bed diameter 

boardwd = 100; //electronic board dimensions
boardlg = 125;

struct_color = "Turquoise";
moving_color = "Lawngreen";
bed_color = "silver";
panel_color = [0.5,0.5,0.5,0.5]; // transparent panels
//panel_color = "white";

camPos=false; // set it false deactivate camera position (to make a film in any position)

$vpd=camPos?1750:$vpd;   // camera distance: work only if set outside a module
$vpr=camPos?[80,0,42]:$vpr;   // camera rotation
$vpt=camPos?[190,-67,290]:$vpt; //camera translation */

//sub data set of  this printer
//delta_angle = 62; 
arm_length = 190; // supersedes delta_angle  
mini_angle = 25;  // minimum angle of the arms
hotend_vert_dist = 31; // dist of hotend nozzle to reference plane (ball axis)

$ht_tens = 72; // height of tensioner frame (height of bottom of the corner)

sw_offset = -10; // offset of the switch

basewd = 370; // base/top panel width 
basedp = 320; // base/top panel depth
basewoffset = 0;  // base/top panel side offset
basedpoffset = 4; // base/top panel front offset

// side plate dimensions 
splatewd = 150; // before alternative datasets
$subbase=false;
windoorwd = 150; // door windows width
windoorht = 400; // door windows height
  
htsub = 0; // below structure height
httop = 0; // motors on top -> 60

beltwd=6; // belt width
//beltoffset = -$bdist + beltwd/2; //belt CENTER offset is negative, belt is within the reference plane
// positioning rods (used to have reliable triangle angles) 
ref_base = -50.88-4;
function reference_l() = beam_int_radius*1.73205+ref_base; //measure distance with a reference rod 
toprodlg =round(reference_l()+39+10); 
botrodlg =($wallsup)?round(reference_l()+31+10):round(reference_l()+29+10); 
toprodht = htotal-13+motor_voffset;
botrodht = 4.25; // with M4 threaded rods
posrod = rod_space+9.65; // the positioning rod axis crossing
posrodaxo = 70.1; // offset along axis of positioning rods
posrod_offset = 12; // offset beween bottom and top positioning rods

txtangle=-90;
txtzpos = 380;
txtypos = 1.3*beam_int_radius;
stext =  [str("Rod length: ",round(htotal-rod_base-28), " mm")];

//* next paragraph are alternative geometry
//- add a leading '/'  to the first line, that will uncomment whole paragraph
// and the data will supersede above data

/* Alternative dataset with same components as HXMF 131/500 is HXMF 139/500 - Fisher kit based
//  -> usable diameter 186 mm H centre ~ 225mm, periphery 215mm - base slightly enlarged
// uncommenting the block will supersede former data  
Delta_name = str("Lily F 139/500 by PRZ");
beam_int_radius = 139;
arm_length = 204;
mini_angle = 23; 
basewd = 380;
basedp = 340;
basedpoffset = 6;
htotal=500;
$wallsup = 0;
rod_base  = 46;
$ht_tens = 72;
hotend_vert_dist = 31;
$bedDia=200; 
//*/

/* Alternative dataset with same components HXMS 139/530 - Scratch build
//  -> usable diameter 188 mm H centre ~ 245 mm, periphery 215mm - base slightly enlarged
// uncommenting the block will supersede former data  
rod_space = 58;
arm_space = 80;
wire_space = 68;
Delta_name = str("LilY S 138/530 by PRZ");
beam_int_radius = 139;
arm_length = 205;
mini_angle = 24; 
basewd = 390;
basedp = 340;
basedpoffset = 1;
sw_offset = -12.5; // offset of the switch
htotal=530;
$wallsup = 68;
rod_base= 3;
$ht_tens = 50;
hotend_vert_dist = 33;
$bedDia=200; 
lbearing_dia =12;
//
//Effector_STL= "STL/Lily_35_effector_S2.stl";
//Hotsup_STL = "STL/Lily_36_hotend_support_S.stl";
splatewd = 170;

//*/

/* Alternative dataset with same components HXMS 172/630 - Scratch build
//  -> usable diameter 188 mm H centre ~ 245 mm, periphery 215mm - base slightly enlarged
// uncommenting the block will supersede former data  
Delta_name = str("Lily 'S' 172/630 by PRZ"); // shall use 10 or 12 mm rods, not designed yet
beam_int_radius = 172;
arm_length = 266;
mini_angle = 22; 
basewd = 460;
basedp = 400;
basedpoffset = 6;
htotal = 630;
rod_dia = 10;
lbearing_dia = 19;
rod_space = 44;
$wallsup = 90;
rod_base = 2;
$ht_tens = 70;
hotend_vert_dist = 40;
$bedDia = 260; 
car_hor_offset= 18;
splatewd = 180;
$subbase =true; // structure below floor for spool & power supply
htsub = 220; // height of the sub-base -could be whatever you want, depending spool you use + tensioner clearance
spoolsep_dp = 220; // depth of spool space - panel 15mm shorter
$spool_tsl = [115,-85,-120];
//*/

/* Alternative dataset with Extrusions HXMS 188/800 - Scratch build
//  -> usable diameter 286 mm H centre ~ 245 mm, periphery 215mm - base slightly enlarged
// uncommenting the block will supersede former data  
Delta_name = str("Lily V 188/800 by PRZ"); // future, with 20x40 V-Slot profiles
//Movement part design to be done...
// Effector will be the D-Box effector
beam_int_radius = 188;
arm_length = 305;
mini_angle = 22; 
arm_space= 84;  // space between the arms
wire_space= 68; // space between the wires
basewd = 520;
basedp = 450;
basedpoffset = 6;
htotal=800;
$wallsup = 100;
$ht_tens = 80;
hotend_vert_dist = 40;
$bedDia=300; 
car_hor_offset= 18;
splatewd = 180;
rod_space=0;
dia_arm=6;
dia_ball =8;
corner_offset=20; // extrusion thickness
frame_corner_radius=0; 
belt_dist=8.5;
motor_offset = -12; 
eff_hor_offset= 30;

splatewd = 230;
basedpoffset = 2; // base/top panel front offset
motor_voffset = panelthk+23;
htsub = 220; // height of the sub-base -
$isExtrusion = true;
spoolsep_dp = 220; // depth of spool space - panel 15mm shorter
$spool_tsl = [115,-100,-120];

//*/

//* Alternative dataset with D-Box components HXMB 215/840 - Scratch build
//  -> usable diameter 286 mm H centre ~ 245 mm, periphery 215mm - base slightly enlarged
// uncommenting the block will supersede former data  
Delta_name = str("Lily Big V216/780 by PRZ"); 
include <angles.scad> // include AFTER parameters, as are needed in included file 
// angle dimensions are included in angles.scad file
// Movement part design to be done...
// Effector will be the D-Box effector
//echo (motor_offset=motor_offset);
//echo ("beltoffset:",beltoffset);
//belt_axis = beltoffset; // beltoffset defined in angles.scad
belt_axis = -22.621; // direct allocation as cannot reuse allocation in the include ???
echo (belt_axis=belt_axis);
qpart=0; // neutralise view in angles module
$isAngle = true; // tells that rail is an angle, used as a selector
beam_int_radius = 216;

arm_length = 305;
mini_angle = 22.5; 
arm_space= 86;  // space between the arms
wire_space= 70; // space between the wires on carriage (different from effector wire space)
basewd = 540;
basedp = 470;
basedpoffset = 8;
hbase =0;
htop = 0; // for this model, the reference is between the plates and motors are above
htotal=780; // with angle 825, angle shall protrude 34mm above top panel
$wallsup = 0;
$ht_tens = 80;
hotend_vert_dist = 25;
$bedDia=300; 
bed_level = 20; 
car_hor_offset= 45; // = (angleSize+angleThk)*0.7+1+counterplThk+dia_ball*0.8;
splatewd = 220;
rod_space=0;
dia_arm=6;
dia_ball =8;

hcar = 60;          // carriage height
car_vert_dist = 8.5; // vertical offset between the articulation and the top of the carriage - 8.5 for integrated carriage
top_clearance = 10+10;   // clearance between top of the carriage and top structure -

corner_offset = 5; // may be reduced to 4 due to angle rounded 
frame_corner_radius=0; 

Effector_STL= "STL_Big/Lily_Big_30_effector_B.stl";
Hotsup_STL = "STL_Big/Lily_Big_31_hotend_support_B.stl";
Hotend_STL = "STL_Big/Prometheus2nuts.stl";

stext = [str("Angle length: ",round(htotal+27+top_panelthk), " mm")];
// text specific to this type, just before Licence text

//$bdist= angleThk*1.414+23.5; // new variable because openScad cannot reallocate variable with a result (...) use function ??

//beltoffset = -$bdist + beltwd/2; //belt CENTER offset is negative, belt is within the reference plane
//belt_dist=8.5;
eff_hor_offset= 30;

motor_voffset = top_panelthk+23;
//$subbase =true; // structure below floor for spool & power supply
htsub = 220; // height of the sub-base -
httop = 60;
spoolsep_dp = 220; // depth of spool space - panel 15mm shorter
$spool_rot=[0,90,0];  
//$spool_tsl=[-115,-55, beam_int_radius-pyshift+15];   
$spool_tsl = [170,105,-125];

windoorwd = 200;
windoorht = 400;  

// positioning rods
ref_base = -97.4; // for geometry rods
toprodlg = round(reference_l()+46); //geometry rod length
botrodlg = toprodlg; // top/bottom rods are identical
toprodht = htotal+10.3+top_panelthk; //??
botrodht = 7;
posrod = 27.85; // the positioning rod axis crossing
posrodaxo = 72.85; // offset along axis of positioning rods
posrod_offset = 0; // offset beween bottom and top positioning rods
//color ("red") cylz (280,100, 0,-200,0, 60); door check

//*/

module cyltest (dia) {
  difference() {
    union() {
      cylz (dia+2,0.7, 0,0,0,200);
      cylz (dia,30, 0,0,0,200);
    }  
    cylz (dia-15,10,0,0,-1, 200);
    cylz (dia-1.2,30, 0,0,0.7, 200); 
  }
}
*cyltest(100);

  splatedist = beam_int_radius+corner_offset+frame_corner_radius; // distance of structure panels
  rdc = sqrt(splatedist*splatedist+splatewd/2*splatewd/2);
  angle = 60-asin (splatewd/2/rdc);
  platedist = rdc *cos (angle); // distance of intermediate panels
  platewd = rdc *sin (angle)*2;
  dpshift = boxpanelthk*0.577; //panel seated on back panel, so shift from axis
  sd_doorwd = (splatedist+panelthk) + ((splatedist+panelthk)*0.5-cos(30)*splatewd/2-(panelthk-boxpanelthk)/2);  //Side door width
  front_doorwd = platewd+panelthk*2*cos(30);
  backpanelht = htotal + ceil(((htsub)?htsub+basethk+top_panelthk+60:0)/5)*5; // back panel height
  midpaneldp =  ceil((splatedist + platedist+panelthk/2+boxpanelthk)/10)*10; // if there is a sub-box, depth of mid panel bolted on back panel

  $dtxt = concat([ // $dtxt shall be an array
    str("Struct. panels: ",round(splatewd),"x",htotal, "x",panelthk," mm"),
    str("Back panel: ",round(basewd-30),"x",backpanelht, "x",panelthk," mm"),
    str("Box panels: 2x ",round(platewd),"x",htotal, "x",boxpanelthk," mm"),
    str("Front/sd. doors: ",round(platewd),"/",round(sd_doorwd),"x",htotal, "x",boxpanelthk," mm"),
    str("Base plate: ",round(basedp)," x ",round(basewd)," x ",basethk," mm"),
    str("Mid&top plate: ",midpaneldp," x ",round(basewd)," x ",basethk," mm"),
    str("Threaded rods: ",botrodlg, "/",toprodlg," mm"),
    str("Reference base: ",round(reference_l()), " mm")
    ],
    stext,
    "Machine licence: CERN OHL V1.2" 
   );

$bCar=true; // allow the program to use below module instead of standard carriage
// $ variable does not give warning when not defined
module buildCar () { // modify to allow excentrate articulation (lowered) ??
  if ($isAngle) buildCarAngle();
  else {  // rod carriage
    dcar = 15+6; // 15 is bearing diam LM8UU = d15x24 - LM10UU d19x29 - LM12UU d21x30
   * color(moving_color)
    tsl (0,0,-car_vert_dist) {
      hull () 
        dmirrorx()
          cylz (-dcar,hcar,  rod_space/2,0,car_vert_dist-hcar/2); // -x to decrease side size
      cubez (rod_space-rod_dia,20,-dia_ball*1.5,  0,10-car_hor_offset,dia_ball*1.5/2);
      cylx (-dia_ball*1.5,rod_space-rod_dia,  0,-car_hor_offset); 
    }
    color(moving_color)
      mirrorz() carriage();
    color ("silver") if (rod_space) { // linear bearings LM8UU & LM8LUU
      cylz (-15,24, rod_space/2,0,-7.5);
      cylz (-15,45, -rod_space/2,0,-7.5-10.5);
    }
  }  
} 

$bSide = true; // setup the below side panel *in addition* to frame
module buildSides() {
  // motor support 
  rot120() tsl (0,beam_int_radius,htotal) {
    if (!$noTopSup)
      color(struct_color) 
        if ($isAngle)  {
          rotz(90) tslz(0.01+top_panelthk) { 
            angleSup(false);
            tsl (motor_offset_a) motorPlate(); 
          }  
          rotz(90) mirrorz() top_renf(); 
        }  
        else   
          tslz (motor_voffset) motor_support();
    tsl (0,posrod) // positioning rods
      rotz(30) {
        gray() { 
          cyly (4,-toprodlg,  // top rod       
            0,-posrodaxo+25,toprodht-htotal); 
          cyly (4,-botrodlg, // floor rod
            posrod_offset,-posrodaxo+20,botrodht-htotal); 
        }
        red()//measurement stick:176 for beam_int_radius 131
          cyly (3,-reference_l(),  5,-posrodaxo, toprodht-htotal);
      }  
  } 
  PS_shift = platewd/2-dpshift-40*0.5-58/2 -3; // 40 thk PS, 58 width PS
  yboard = -platewd/2 -boardwd*sin(30)-boxpanelthk*1.155 -10; 
  xboard = -splatedist+6 +boardwd/2;
  rotz(-90)  // before panels for transparency
    color ("black") // power supply form factor 40x58x200
      if  ($isAngle) 
        rotz (60)cubez (55, 115, 230, -platedist-45,35,300);
      else   
        rotz(60)cubez (40,58,200, -platedist-boxpanelthk-20, PS_shift, 30);
  color ("green") // board    
    if ($isAngle)     
      rotz (-30)     
        tsl (-platedist-boxpanelthk-20, -20, htotal-boardlg-20) 
          cubez (3, boardwd,boardlg);
  else 
    rotz(-90) 
      cubez (boardwd,3,boardlg, xboard, yboard, htotal-boardlg-20);    
  if ($boxed) // filter  - before panel -> transparency
    rotz (30) 
      tsl (platedist+boxpanelthk, 0, htotal-175)  
        black() if ($isAngle) cubex(15,230,330);
  color (panel_color) {
    for (i=[30, 120+30])
      rotz(i)  // structural front panels - 1 -
        tsl (-splatedist-panelthk/2) panel(1);
          
    rotz(-90) // structural back panel - 2 -
      tsl (-splatedist-panelthk/2) panel(2);
    if ($boxed) {  // if the printer is enclosed.
      
      rotz (-30) //closing side panel left - 3 -
        tsl (-platedist-boxpanelthk/2, -dpshift/2) //closing side panel left - 3 -
        panel(3);
      rotz (30) 
        tsl (platedist+boxpanelthk/2, -dpshift/2)  //closing side panel right with filtration holes -4 -
          panel(4);
    
      mirrorx()  // side doors left - 5 - right - 6 
        tsl ((basewd-30)/2+boxpanelthk/2, splatedist+panelthk- sd_doorwd/2)
          panel(5);
      tsl ((basewd-30)/2+boxpanelthk/2, splatedist+panelthk- sd_doorwd/2)
          panel(6);
      tsl (0,-platedist-panelthk/2-boxpanelthk/2) //front  door -6 -
        rotz(90) panel(7);
    } // boxed 
    if (htsub) {
      dmirrorx()   {
        cubey(panelthk,-midpaneldp+20,htsub, 
          basewd/2-100-panelthk/2,splatedist,-htsub/2-basethk);
        cubex(-80,panelthk,htsub, 
          basewd/2-20,splatedist-230-panelthk/2,-htsub/2-basethk);   
      }
      echo (str("Sub-base panel:",htsub,"x",midpaneldp-20," mm")); 
      echo (str("Sub-base panel:",htsub,"x","80 mm")); 
    }
  }
  if (!$noTop)  //top plate as last panel for transparency
    color (panel_color) tslz (htotal) panel(15);
  if (!$noCover && httop) 
    color (panel_color) tslz (htotal+top_panelthk+httop) panel(16); //top plate as last panel for transparency    
}

module panel (num){
  scrsp = ceil(basedp/4.3/5)*5; //bottom plate screw space
  scrsp2 = ceil(basewd/3.8/5)*5; 
  module botplatedrill() {
    dmirrorx() 
      duply (scrsp,3) 
        cylz  (-4,55, basewd/2-100-panelthk/2,-scrsp*1.5);
      dmirrorx() { // sub base bolting
        duplx (scrsp2,1) 
          cylz (-4,55, scrsp2*0.5, splatedist+panelthk/2);
        duplx (-50)
          cylz (-4,55, basewd/2-35,splatedist-230-panelthk/2);
      }  
  }
  module structdrill(top=false) {
    rot120(30) { // structural panels screws
      dmirrory() {
        cylz(-4,55, -splatedist-panelthk/2,splatewd/2-18);
        cylz(-4,55, -splatedist-panelthk/2, 30);
      }  
    }
    rot120(-30) {
      cylz ((top)?-20:-8,55, belt_axis+beam_int_radius);  //     tensioner /belt access   
      if (top) 
        if ($isAngle) 
          tsl (beam_int_radius) {
            diff() { // cut angle space
              rotz(45) cubez (angleSize, angleSize,55, -angleSize/2,angleSize/2,-20);
              cubex (-50,100,100, (-angleSize-angleThk)*0.707);
            }  
            rotz(-45) cylz(-6,55, carBBdia/2+4.5,-extSdFace+1.3);//switch rod    
          }  
        else  // rod based frame
          dmirrory() 
            cylz (-4,66, beam_int_radius+7.5,22);//top support screws 
    }
    if (!$isAngle) 
      rotz(90) dmirrory() // back panel
        cylz (-4, 66,  splatedist+panelthk/2, basewd/2-15-25); 
    cylz (-3, 66); // center
  }
  if (num==1) { 
    cubez (panelthk,splatewd, htotal); // struct front panel
    if (httop)
      cubez (panelthk, splatewd, httop, 
        0,0,htotal+top_panelthk); 
  }  
  else if (num==2) diff() {  // back panel  (rotated 90°)
    cubez (panelthk,basewd-30,backpanelht, 0,0,(htsub)?-htsub-basethk:0);
    if ($details) dmirrory() { 
      duplz (htotal+top_panelthk/2+basethk/2)
        duply (scrsp2-20,1) 
          cylx (-4,99, 0,scrsp2*0.5, -basethk/2);
      duplz (-150) cylx(-4,99, 0,basewd/2-100-panelthk/2,-35);
    }  
  }
  else if (num==3) cubez (boxpanelthk, platewd-dpshift, htotal); //left side panel
  else if (num==4) {
    hlspace = 78;
    diff() { //closing side panel right with filtration holes -4 -
      cubez (boxpanelthk, platewd-dpshift, htotal);
      //:::::::::::::::::::::::::::::::::::::
      if ($details) tslz (htotal-55) {
        ffanht = ($isAngle)?-335:-257; 
        if ($isAngle) {
          hlspace = 78;
          duplz (-hlspace,3) dmirrory() { // filter holes
            cylx (-68, 55, 0,hlspace);
            cylx (-68, 55, 0,0);
          }  
          duplz (-2*hlspace) dmirrory()  
            cylx (-4, 55, 0,hlspace/2, -hlspace/2);
        }
        else {
          hlspace = 78;  
          duplz (-hlspace,2) dmirrory() 
            cylx (-68, 55, 0,hlspace/2);
          duplz (-hlspace)  
            cylx (-4, 55, 0,0, -hlspace/2);
        }
        tsl (0,25,ffanht) { // fan 
          cylx (-80, 55);
          dmirrory() dmirrorz() 
            cylx (-4, 55, 0, 71.5/2, 71.5/2);
        }
      } // holes
    }
  }  
  else if (num==5 || num==6)   //side doors         
    diff() {
      u() {
        cubez(boxpanelthk, sd_doorwd, htotal);
        if (httop) 
          cubez(boxpanelthk, sd_doorwd, httop, 0,0,htotal+top_panelthk);
      }  //::::::::::::::::::::::::::
      if (htsub)
        cubez(50,sd_doorwd+20,5,  0,0,260); // cut door in half
      htfan = (htsub)? htotal-190:50;
      if (num==5) // left door - board cooling fan
        tsl (0,15,htfan) {
          cylx (-80,55); 
          dmirrory() dmirrorz() 
            cylx (-4, 55, 0, 71.5/2, 71.5/2);
        }  
    }
  else if (num==7) {// front door
    diff() {
      cubez (boxpanelthk, front_doorwd, htotal); 
      //::::::::::::::::::::::
      duplz (450,0) tsl (0,0,windoorht/2+30) // glass hole
        hull() dmirrory() dmirrorz() 
          cylx(-20,55, 0,windoorwd/2-20,windoorht/2-20);
    } 
    if (httop)
      cubez (boxpanelthk, front_doorwd, httop, 
        0,0,htotal+top_panelthk); 
  }  
  else if (num==11) //base panel
    diff() {
      cubez (basewd,basedp,-basethk, 0,basedpoffset); 
      //::::::::::::::::::::::::::
      if ($details) 
        if (htsub)
          botplatedrill();
        else
          structdrill(); 
    }  
  else if (num==12) //mid panel
    diff() {
      cubey (basewd,-midpaneldp,basethk, 0,splatedist,basethk/2);
      //:::::::::::::::::::::::::::::::::
      if ($details) botplatedrill();
      if ($details) structdrill();
    }  
  else if (num==13) //separators
    dmirrorx() 
      diff() {
        cubey (basewd/2,-midpaneldp,boxpanelthk, -basewd/4,splatedist,basethk/2);
        rotz (-30) //closing side panel left - 3 -
          cubex (400,800,50, -platedist-boxpanelthk);
        tsl (-(basewd-30)/2)
          cubex (-50,500,50);
      } 
  else if (num==15) //top panel
    diff() {
      if (httop) // clear back panel
        cubey (basewd,-midpaneldp,top_panelthk,
          0,splatedist, top_panelthk/2);
      else // above back panel
        cubez (basewd,basedp,top_panelthk, 0,basedpoffset); 
      //:::::::::::::::::::::::::::::::::::::::  
      dmirrorx() 
        rotz(30)  // structural front panels cut
          tsl (-splatedist-panelthk) cubex (-200, 600, 50);
      rotz (-30)  // cooling hole   
        tsl (-platedist-boxpanelthk-20, -15) 
          hull() 
            dmirrory() cylz(-25,55, 0,25);
      structdrill(true);
    }  
  else if (num==16) //cover panel
    diff() {
      cubez (basewd,basedp,cover_panelthk,  basewoffset,basedpoffset); 
      dmirrorx() 
        rotz(30)  // structural front panels cut
          tsl (-splatedist-panelthk) cubex (-200, 600, 50);
      rot120(-30)
        cylz (-45, 30, beam_int_radius-60); 
    }  
} 

$bAllFrame=true;
module buildAllFrame() {
  color("lightgrey") {
    tslz ((htsub)?-htsub-basethk:0)  panel(11); // base plate
    if (htsub) tslz (-basethk) panel(12); // mid-plate -cut for back panel
    if ($isAngle) tslz (265) panel(13);  
  }
  if (htsub) { // if sub-base 
    mirrorx() //2nd spool at bottom 
      translate ($spool_tsl) rotate ($spool_rot) 
        spool("red");
  }  
  color(struct_color) {
    rot120() tsl (0,beam_int_radius,0) {
       if ($isAngle) 
         rotz(90) tslz(0.01) angleSup(); 
       else if ($wallsup) {
         foot2();
         tsl (0,0,$wallsup) wallsup();
       }
       else foot(); // foot for rods 
     }   
    rot120 (-30)  
      tsl (beam_int_radius,0,$ht_tens) {
        if ($isAngle) {
          tensionerAngle(); 
          tsl (belt_axis,0,-45) thumbwheelM4(); 
        }  
        else         {
          tensioner(); 
          tsl (belt_axis,0,-12) twheel();
        }  
      }  
  } 
  gray() { // rail 
    rot120 (-30) {
      if (!$noTopSup)
        rotz(30) 
          tsl (0,beam_int_radius+motor_offset,htotal+motor_voffset) // motor
            rot(-90) nema17(32);   
      if (rod_space)
        dmirrory()  //rods
          cylz (rod_dia,htotal-rod_base-27,   beam_int_radius,rod_space/2,rod_base); 
      else if ($isExtrusion) // V-Slot beams - not yet finished ???
          tsl (beam_int_radius+10)
            linear_extrude(height=htotal, center=false)
              rotz (90) import (file="Vslot_beam_cut.dxf",            layer="SECTION2");
      else if ($isAngle) 
        tsl (beam_int_radius,0,5.5)
          rotz(135) 
            profile_angle (angleSize, angleSize, angleThk, htotal+top_panelthk+32.5-5.5); 
    }       
  } 
  if (htsub) { // side extruder if spool in base
    dmirrorx() rotz(30) mirrory() 
      set_extruder (platedist+boxpanelthk,-50,200);
  }
  else { // face extruder - not very realistic
    tsl (22,38,htotal-120)
      rot (0,-55) {
        white() tore (4,240,  200,300);
        blue()  tore (10,240, 300,304);
        color ("yellow") tore (2,240,  -60,0);
      }   
    rotz (-90) 
      tsl (beam_int_radius-65,25,htotal-125) {
        rot (0,90) {
          nema17(32); // ??
          tsl (0,0,4) 
            red() mirror ([0,1,0]) rotz(-55) import ("extruder.stl");
        }  
      }
  }   
  *dimcheck(); 
}

module dimcheck () { // check dimensions
  rotz (120)
  color("red") {   
    cyly (-3,66, 0,beam_int_radius,15); // centering hole
    cyly (-3,66, 0,beam_int_radius,htotal-23+15); // centering hole
    echo ("motor center pin height:", htotal-23+15); // presently 447
  }  
}

module tensioner (flanged=false) { // build pulley tensioner
htTens=15; // flanged bearing needs a washer between flanges, so add width
intspace = (flanged)?9:8; // space between internal faces
axis_h = htTens/2+1;  
  difference() {
    tsl (belt_axis) {
      hull() {
        dmirrorx() dmirrory()
          cylz (5,htTens,  6, 8.5); 
        cylz  (rod_dia+5,htTens+4,  -belt_axis,-rod_space/2, -4);
        cylz (16,-1,  0,0, -3);
      }
      dmirrorx() 
        tsl (8.5,0,axis_h)
          rot(0,90) cylinder (d2=8, d1=17, h=3.8);
    }  //::: then whats removed :::
    tsl (belt_axis) 
      hull()  {
        dmirrorx() dmirrory()
          cylz (1.5,axis_h+4,  5, 8.3, htTens/2-3); // belt hole
        dmirrory() 
          cylx (-1,10, 0,4,0); 
        cylz (10.6,33,  0,0, -1.5); 
        cylz (rod_dia+1.5,33,  -belt_axis,-rod_space/2, -1.5); // rod guide
      } 
    cylx (-3,55,  0,0,axis_h); // bearing hole
    tsl (-11+belt_axis,0,axis_h)
      rot(0,-90) cylinder (d2=6.5, d1=3, h=1.4); 
    tsl (9.5+belt_axis,0,axis_h)  
      rot (30) cylx (diamNut3, 3.2, 0,0,0, 6);  
    cylz (-rod_dia,55,  0,-rod_space/2); // rod guide
    cylz (4.2,-30,  belt_axis); // hole for tensioner bolt
    cubez (100,100,10, 0,0,htTens); // Top cut - for bearing cones 
  }  
  difference() {
    tsl (belt_axis) 
      dmirrorx() 
        tsl (intspace/2,0,axis_h)
          rot(0,90) cylinder (d1=5.5, d2=13, h=2.3);
    cylx (-3,55,  0,0,axis_h); // bearing hole
  } 
  difference() {
    cylz (rod_dia+5,htTens+4,  0,-rod_space/2, -4);
    cylz (-rod_dia,55,           0,-rod_space/2); // rod guide
  }
  if (!flanged)
    tsl (belt_axis)
      dmirrorx() //belt side stops - if bearings not flanged - cut for flanged bearings
        difference() {
          hull() {
            cubez (3,14.5,-2, 3.5+1.5,0,htTens);
            cubez (2,14.5,-1, 6+1,0,htTens-5);
          }
          cubez (2,6,-5, 4.2-1,0,htTens+0.1);
        }  
  *gray() cylx (-3,25,  belt_axis,0,axis_h); // bearing hole 
}

//tsl (400) fan_guard();

$bEffector=true;
//$chimera =true;
module buildEffector () {
  color (moving_color) {
    import(Effector_STL);
    tsl (0,0,1)
      rot(180)  // return the support (as printable)
        import(Hotsup_STL);
  }  
   * tsl (0,0,25) {
      rotz (180) tsl (0,25,-2)   rot(-90) build_fan(30,6);
      rotz (60)  tsl (0,22.5,-2) rot(-80) build_fan(30,6);
      rotz (300) tsl (0,22.5,-2) rot(-80) build_fan(30,6);
    }
}

$bHotend=true;
module buildHotend () {
  topsup=12;
  topfin = 8;
  if ($isAngle)
    color("silver")  tslz(-23) import(Hotend_STL);
  else if ($wallsup)
    color("silver")   {
      tsl (0,0,topsup){
        cylz (17,-18, 0,0, -topfin-0.5);  
        cylz (19,-1.2, 0,0,-18-topfin-0.5);  
        cconez (4,1,-1, 16, 0,0, -18-topfin-0.5);  
        rotz (-75)
          cubez (16,14,8, 4.5,2.8, -30-topfin-0.5);
      }  
    }
  else {  
  * rotz (90) import("Hexagon-102.stl");
    tsl (0,0,-hotend_vert_dist)
        cone3z (1,4, 0.1,2,50);
    tsl (0,0,-hotend_vert_dist+20)    
      cylz (17,40, 0,0,0, 6);
  }  
}

module twheel () {
  difference() {
    union() {
      hull() {
        cylz (9.5,6);  
        cylz (14,2, 0,0,4);  
      }  
      for (i=[0:3])
        rotz (i*90) 
          hull() {
             cylz (8,5, 0,0,1);
             cylz (2.8,2, 9,0,4);
          }  
    }
    cylz (diamNut4, 5, 0,0,2.8, 6);
    hull () {  
      cylz (diamNut4, 5, 0,0,5.5, 6);
      cylz (12, 1, 0,0,10);
    }  
    cylz (-4, 22);
  }  
}

// Tests 
*rotz (120)  cylz (working_dia,30,-beam_int_radius+20); //check access through door
*color (moving_color) frame_int (frame_corner_radius,rod_space, beam_int_radius,18,80);
*cylz (325,10,0,0,0,150); // checking enveloping cylinder
*cylz (264,10,0,0,0,100); // checking internal cylinder

//== extract from library ================================================

module tore (dia, ldia, angstart, angend, qual=100) { // first diam is small diam
  sectorz(angstart,angend, -ldia*2)
    rotate_extrude($fn=qual)
      tsl (ldia/2)
         circle (dia/2);
}
//tore (10, 50, 220, 290);

module cylsectz (di, height, thickness, angstart,angend) { // cylindrical sector
  sectorz (angstart,angend)
    difference () {
      cylz (di+2*thickness, height,0,0,0,120);
      cylz (di, height+2,0,0,-1,120);
    }  
}

//cylsectz  (100,25,10,100,160);

module sectorz (angstart,angend, radius=-1000,depth=2000 ) { //cut a sector in any shape, z axis  
  // negative radius will equilibrate the depth on z axis
  // angstart could be negative, angend could not
mvz = radius<0?-abs(depth)/2:depth<0?depth:0;  
sectang =  angend-angstart;
cutang = 360-sectang; 
  module cutcube() { 
    tsl (-0.02,-abs(radius),mvz-0.1)  
      cube(size= [abs(radius),abs(radius),abs(depth)], center =false);
  }  
  module cutsect () {
    if (sectang >270) {
      difference () {
        cutcube();
        rotz (-cutang) 
          cutcube();
      }
    }  
    else {
      cutcube();
      rotz (-cutang+90) 
        cutcube();
      if (cutang > 180) 
        rotz(-90) 
          cutcube();
      if (cutang > 270)   
        rotz(-180) 
          cutcube();
    }
  } // cutsect
  difference () {
    children();
    rotz (angstart) 
      cutsect();
  }
}

module cut_rodface () { //cut rod support face - shall be same cut for top and bottom support to have same rod length
   rotz(30) // cut rod face 
     cubey (50,-10,50, 35,-25.45-2,-1);
}

module foot () {
  wall_space = 52;
  fix_space = 64;
  offsety = motor_offset+0.5;
  rod_hold = rod_dia+6.5;
  rodrd = rod_space/2+4;
  rodht = 4.25;
  dec = 12;
  rodextend = 4.5;
  htr = 18;
  scr = htr/2+rod_base;
  difference() { 
    union() {
      dmirrorx() {
        hull() { // rods ends
          cyly (8.5,14-offsety,     15,offsety,scr); // fix holes
          cubey(1,12-offsety,htr-6, rod_space/2-3.5,offsety+2,rod_base+htr/2+1);
          cylz (rod_hold,htr-2,     rod_space/2, 0,         rod_base+2);  
          cylz (1.6,1,              rod_space/2, 0,         rod_base-14);    
        } 
        hull() { // rods ends fins
          cylz (1.6,1, rod_space/2, 0,          rod_base-14);   
          cylz (1.6,1, rod_space/2-1.8,   6.6,          0);   
          cylz (1.6,rod_base+12, rod_space/2-3.5, -offsety+5, 0);       
        }  
        tsl (rodrd,7)
          hull() // triangle rods extension
            rotz(30) {
              cyly  (8.5,10.5+rodextend,   dec, 2-16.5-rodextend, rodht);  
              cubey (6,10.5+rodextend,2,  dec, 2-16.5-rodextend, 1); 
              cubey (6,rodextend,4,       dec-4,2-16.5-rodextend,2); 
            }
        hull() {
          cyly (2,1,     12,13,1);
          cylz (12,6,  fix_space/2,1);
          cubez (20, 2,2.5, 25,13);
          cubez (10, 2,6, 30,13);
        } 
        hull() {
          cconey(15,10, -3.5,1.6,  wall_space/2,14,10.5);
          cubey (15,-3.5,2.4,      wall_space/2,14,1.2); // bottom 
        }  
      } 
      difference() {
        hull() {
          cubez (37,1.6,rod_base+htr-2,  0,13.2,0); // top face
          cubez (60,1.6,1,  0,13.2,0); // top face
        }  
        cyly (100,8, 0,10,rod_base+64, 60);
      }  
      difference() {
        hull() {
          cubez (40, 1.6,htr-8,  0,-6.6,rod_base+4); // top face
          cubez (8,2.6,1,  0,-6.5,0); // top face
        }
        cyly (100,8, 0,-13.5,rod_base+61, 60);
      }
      cubey (79.6,-22.66,2.4,  0,14,1.2); // bottom
      cconez (15,11,2,4.5, 0,belt_axis);
    } //::: then whats removed :::

    dmirrorx()  {
      cylz (rod_dia,25, rod_space/2,0,rod_base);
      cyly (-4,66, 15,0,scr); //wall fix holes
      cone3y (9.4,4,-15,-2,8, wall_space/2,10.9,10.5);
      hull() { // cut rod supports
         cylx (1.5, -25, rod_space/2-1,0,rod_base-1.5);
         cylx (1.5, -25, rod_space/2-1,0,rod_base+25);
      }
      cylz (-4,66, fix_space/2,1,-1); // floor attach
      cconez (10,4, -2.5,-5,  fix_space/2,1, 6); 
      
      tsl (rodrd,7,rodht) // biased cut for triangle rods seats
        rotz(30) {
          cyly (-4,22,  dec, -12);
          tsl (dec)
            hull() {
              cylz (2,20,  8.5,-4,-10);
              cylz (2,20 , -4,-4,-10);
              cylz (2,10,  -4,-1.5  ,-10);
              cylz (1,10,  14,15  ,-10);
              cylz (2,1, 0,-4,8);
            }  
        }
      cut_rodface();  
    } 
    cylz (-4,33, 0,belt_axis); // tensioning nut hole
    cylz (diamNut4,3.5, 0,belt_axis,-0.1, 6);
    cubey (150,10,150, 0,14); // cut face
    duplz (35)
      cyly (-3,44, 0,10,15); // positioning hole
  }  
}

module foot2 () {
  htr = 10; // rod insertion height
  rod_hold = rod_dia+7;
  scr = (htr)/2+rod_base; // screw height
  offsety = motor_offset+0.5;
  rodrd = rod_space/2+4;
  rodht = 4.5;
  dec = 5;
  rodextend = 3;
  fix_space = rod_space+rod_dia+9;
  wall_space= rod_space-rod_dia-5;
  difference() { 
    union() {
      dmirrorx() {
        hull() { // rods ends
          cyly (9.5,14-offsety, wall_space/2,offsety,scr); // fix holes
          cubey(2,12-offsety,htr+rod_base,  
            rod_space/2-2,offsety+2,(htr+rod_base)/2);
          cylz (rod_hold,htr+rod_base,   rod_space/2);  
          cylz (10,htr+rod_base,  fix_space/2,0);
          cylz (2,6,   fix_space/2+6,-4);
        } 
        tsl (rodrd,7)
          hull() // triangle rods extension
            rotz(30) {
              cyly (8.5,16+rodextend,   dec,2-16.5-rodextend, rodht, 32,0);  
              cubey (9,16+rodextend,2,  dec-2,2-16.5-rodextend,1); 
              cubey (6,2,2,  dec-10,-10,1); 
            }
      } 
      cubez (rod_space-2,2,scr+5,  0,13,0); // top face
      cubez (rod_space-2,2,scr,   0,-6.5,0); // top face
      cubey (rod_space,12-offsety,2.5,  0,offsety,1.25); // bottom
      cconez (15,11,2,4.5, 0,belt_axis);
    } //::: then whats removed :::
    dmirrorx()  {
      cylz (rod_dia,25, rod_space/2,0,rod_base-0.02);
      cylz (rod_dia+1,-25, rod_space/2,0,rod_base);
    
      cyly (-4,66,      wall_space/2,0,scr); //wall fix holes
      hull() {
        cylz (1,25,   rod_space/2-1,0,-1);
        cylz (1,25,   rod_space/2-rod_dia/2-9,0,-1);
      }
      cylz (-4,66,            fix_space/2,0); // floor attach
    *  cconez (10,4, -2.5,-10, fix_space/2,0, 9); 
      tsl (rodrd,7,rodht) // biased cut for triangle rods seats
        rotz(30) {
          cyly (-4,22,  dec, -12);
          tsl (dec)
            hull() {
              cylz (2,20,   5,0,-10);
              cylz (2,20,  -3,0,-10);
              cylz (2,20,  -5, 10,-10);
            }  
        }  
       cut_rodface();  
    } 
    cylz (-4,33, 0,belt_axis);
    cylz (diamNut4,3.5, 0,belt_axis,-0.1, 6);
    cubey(100,10,100, 0,14); // cut face
    cyly (3,20, 0,10,6); // positioning hole
  }
  dmirrorx()  
    difference() { 
      union() {
        cylz (6,rod_base+0.01, rod_space/2);  
        cubez (2,rod_dia+2,rod_base, rod_space/2);
      }
      cylz (-2.5,66, rod_space/2);  
    }
}

module foot3 () {
  rod_base  = 0;
  htr = 10; // rod insertion height
  rod_hold = rod_dia+7;
  scr = (htr)/2+rod_base; // screw height
  offsety = motor_offset+0.5;
  rodrd = rod_space/2+4;
  rodht = 4.25;
  dec = 9;
  rodextend = 3;
  fix_space = rod_space+24;
  wall_space= rod_space-rod_dia-5;
  difference() { 
    union() {
      dmirrorx() {
        hull() { // rods ends
          cyly (9.5,14-offsety, wall_space/2,offsety,scr); // fix holes
          cubey(2,12-offsety,htr+rod_base,  
            rod_space/2-2,offsety+2,(htr+rod_base)/2);
          cylz (rod_hold,htr+rod_base,   rod_space/2);  
          cylz (12,8,  fix_space/2,0);
          cylz (2,6,   fix_space/2+6,-4);
        } 
        tsl (rodrd,7)
          hull() // triangle rods extension
            rotz(30) {
              cyly (8.5,13+rodextend,   dec,2-16.5-rodextend, rodht, 32,0);  
              cubey (6,13+rodextend,2,  dec,2-16.5-rodextend,1); 
              cubey (6,rodextend,4,  dec-4,2-16.5-rodextend,2); 
              cubey (6,2,4,  dec-4-7,2-16.5+2,2); 
            }
      } 
      cubez (rod_space-2,2,scr+5,  0,13,0); // top face
      cubez (rod_space-2,2,scr,   0,-6.5,0); // top face
      cubey (rod_space,12-offsety,2.5,  0,offsety,1.25); // bottom
      cconez (15,11,2,4.5, 0,belt_axis);
    } //::: then whats removed :::
    dmirrorx()  {
      cylz (rod_dia,25, rod_space/2,0,rod_base-0.02);
      cyly (-4,66,      wall_space/2,0,scr); //wall fix holes
      hull() {
        cylz (1,25,   rod_space/2-1,0,-1);
        cylz (1,25,   rod_space/2-rod_dia/2-9,0,-1);
      }
      cylz (-4,66,            fix_space/2,0); // floor attach
      cconez (10,4, -2.5,-10, fix_space/2,0, 9); 
      tsl (rodrd,7,rodht) // biased cut for triangle rods seats
        rotz(30) {
          cyly (-4,22,  dec, -12);
          tsl (dec)
            hull() {
              cylz (2,20,   5,-2,-10);
              cylz (2,20,  -3,-2,-10);
              cylz (2,20,  -5, 3,-10);
            }  
        }  
       cut_rodface();  
    } 
    cylz (-4,33, 0,belt_axis);
    cylz (diamNut4,3.5, 0,belt_axis,-0.1, 6);
    cubey(100,10,100, 0,14); // cut face
    cyly (3,20, 0,10,6); // positioning hole
  }  
}


module wallsup () {
  rod_base = 0;
  wall_space = rod_space-rod_dia-5;
  htr = 10; // rod insertion height
  scr = (htr-rod_base)/2+rod_base; // screw height
  offsety = motor_offset+0.5;
  rod_hold = rod_dia+8;
  difference() { 
    union() {
      dmirrorx() {
        hull() { // rods ends
          cyly (9.5,14-offsety,     wall_space/2,  offsety,  scr); // fix holes
          cubey(2,  12-offsety,htr, rod_space/2-2,offsety+4,htr/2);
          cylz (rod_hold,htr,       rod_space/2);  
          cylz (12,1,               rod_space/2);       
        } 
      } 
      cubez (rod_space,2,htr,  0,13,0);   // wall face
      cubez (rod_space,2,htr,  0,1-rod_hold/2,0); // reinf
      cubey (rod_space,14-offsety,2.5,  0,offsety,1.25); // bottom
    } //::: then whats removed :::
    dmirrorx()  {
      cylz (rod_dia,25, rod_space/2,0,-1);
      cyly (-4,66, wall_space/2,0,scr); //wall fix holes
      hull() {
        cylz (1, 25, rod_space/2-1,0,-1);
        cylz (1, 25, rod_space/2-rod_dia/2-9,0,-1);
      }
    } 
    hull() 
      tsl (0,belt_axis) 
        dmirrorx() dmirrory() 
          cylz (-3,33, 6,4,-10);
    cubey (100,10,100, 0,14); // cut face
    cyly (3,20, 0,10,6); // positioning hole
  }  
}

module motor_support () {
  offsety = motor_offset;
  rodrd = rod_space/2+4;
  rodht = -16.5;
  guide_ht = 16;
  rodextend = 2.5;
  dec=1;
  sfloor = -21;
  wallfix_ht = -12; // vs -12
  wall_space = rod_space/2-6.5;
  difference() { 
    union() {
      dmirrorx() {
        //dmirrorz() 
        hull() {
          cyly (8.5,4, 31/2,offsety,31/2); // motor holes
          cyly (1,1.5, 31/2+4.5,offsety,5); // motor holes
        }
        cyly  (8,7.5,    31/2,offsety,-31/2); // motor holes
        cubey (8,7.5,6, 31/2,offsety,sfloor+3); // motor holes
        hull() { // Wall fixation
          cyly (9,14-offsety, wall_space,offsety,wallfix_ht);
          cyly (2,14-offsety, wall_space,offsety,sfloor+2);
        }  
        cyly (12,7.5, wall_space,offsety,wallfix_ht);// Wall fixation nut holder
        
        cubey (2,14-offsety,41,  20,offsety,41/2+sfloor); // sides
        cubey (2,6-offsety,42,   20,offsety+10,42/2+sfloor); // sides
        hull() { // rods ends
          cylz (rod_dia+7,guide_ht,   rod_space/2,0,sfloor, 32,0);         
          cubey (4,14-offsety,guide_ht,     16+5.5,offsety,guide_ht/2+sfloor);
        } 
        hull() { // rods ends chamfer
          cubey (4,14-offsety,guide_ht,     16+5.5,offsety,guide_ht/2+sfloor);
          cubey (1,14-offsety,guide_ht+4,     16+4,offsety,guide_ht/2+2+sfloor);
        }
        tsl(rodrd,7)
         hull() // triangle rods extension
            rotz(30) {
              cyly (8.5,16+rodextend,    dec,2-16.5-rodextend, rodht);  
              cubey (9,28+rodextend,1,  dec-2,2-16.5-rodextend,0.5+sfloor); 
              cubey (2,2,2,  dec-11,2-16.5+6.7,1+sfloor); 
              cylz (1,guide_ht,  -5.3,11,sfloor);
            }
      }      
      difference() {
        cubey (42,2,  44,  0,12,1); // wall face
        hull()  // central hole wall face
          dmirrorx() {
            cyly (1,22,  5,0, 12);    
            cyly (2,22,  9.5,0,2); 
            cyly (12,22, 4.5,0,-3);    
          } 
        
      } 
      difference() {  
        cubey (42,2.5,41,  0,-8,-0.5); // motor face
        hull()  // central hole motor face
          dmirrorx() {
            cyly (1,-22,  6.5,0, 12);    
            cyly (2,-22,  10.5,0,2);    
            cyly (12,-22, 5.5,0,-7);    
          }  
          
      }  
      hull() { // bottom
        cubey (42,14-offsety,2,  0,offsety,sfloor+1); 
        dmirrorx ()
          cylz (15,2,  rod_space/2,0   ,sfloor);
      }  
      dmirrorx() { // gussets
        tsl (4.5) {
          duply (-10)
            hull() {
              cubez (11,2.5,4,   20,13,19);
              cubez (1,2,3,   15,13,3);
            }  
          cubez (11,10,3.5,   20,6.75,19.5); // top fixations
        }  
      }  
    } //::: then whats removed :::
    cylz   (-4,66,        sw_offset, 9.5); // switch actuation
    cconez (5,4,  1.6,6,  sw_offset, 9.5, -27);
    dmirrorx()
        hull() {  
          cyly (6.6,20,   31/2,0,-31/2); // motor fix holes  
          cyly (0.5,20,   15.5+1.5,0,-12.4);
          cyly (0.5,20,   15.5-1.5,0,-12.4);
        }  
    dmirrorx() {// wall holes
      cyly (-4,33,        wall_space,3,         wallfix_ht); 
      cyly (diamNut4,5, wall_space, offsety-1,wallfix_ht, 6); 
    }  
    dmirrorx()  {
      cylz (-rod_dia,33, rod_space/2,0,-14);
      cylz (4,33,  25,8,0); // top holes
     *tsl (25,8,9.5)
        cylz (diamNut4,10,  0,0,0, 6); // top holes - check nut passage
      dmirrorz() 
        cyly (-3.6,22, 31/2,0,31/2); // motor fix holes
      
      hull() { //pinch cut
        cylz (1, guide_ht+5, rod_space/2-1,          0.1,-23);
        cylz (1, guide_ht+5, rod_space/2-rod_dia/2-9,0.1,-23);
      }
      tsl (rodrd,7,rodht) 
        rotz(30) tsl (dec) {
          cyly (-4,99); // rod hole
          hull() { // rod back nut place
            cconey (8,4, 6,5,  0,1);
            cyly   (8,6,       5,1,8);
            cyly   (10,6,      8,1,-6);
          }  
        }
      cut_rodface();
      rot (0.8) hull()  // incline the motor face 0.8°
        dmirrorx()
          cylz(-10,100, 29,-12.8,0, 50);  
    }  
    hull() // belt passage
      tsl (0.5,belt_axis) 
        dmirrorx() dmirrory() 
          cylz (-3,33, 6.5,4,-10);
    cyly (22.5, 3, 0,offsety); // central hole
    cubey (100,10,100, 0,14); // cut panel face
    cyly (-3,22, 0,10,18); // cut centering hole 5mm below top plate
  }  
}

module carriage () {
  //rod_space=42;
  lbearing_dia=15;
  belt_side = 5.5;
  carht = 16;
  offsety = -10;
  rodrd = rod_space/2+4;
  rodht = 5;
  dec = 10;
  rodextend = 6;
  pscrew = (rod_space>55)?rod_space/2-lbearing_dia/2-2:0;
  pcut = (rod_space>55)?7:rod_space/2-12;
  module cutx() {
    dmirrorx() {
      if (pscrew) 
        hull() 
          duplx (-lbearing_dia/2-7.5)
            cylz (-1.2,66, rod_space/2); 
      else {
        hull() {
          cylz (-1.2, 66, rod_space/2-lbearing_dia/2+2,0,0);   
          cylz (-1.2, 66, rod_space/2-lbearing_dia/2-5,-belt_dist-5.5,0);   
        }  
        hull() {
          cylz (-1.2, 66, rod_space/2-lbearing_dia/2-5,-belt_dist-5.5,0);   
          cylz (-1.2, 66, rod_space/2-lbearing_dia/2-5-pcut,-belt_dist-5.5,0);   
        }  
      }  
      cyly (-3,66, pscrew,0,carht/2); //pinch hole  
    }  
    cylz (-2,66, 9,belt_axis,carht/2); //hole to lock belt if needed    
  }
  difference() { 
    union() {
      dmirrorx() 
        cylz (lbearing_dia+8,carht,   rod_space/2,0,0, 60); 
      hull() {
        cylz (7,carht,     -sw_offset, 9.5); // switch actuation
        cubez (12,1,carht, -sw_offset, 8); // 
      }  
      *gray() cylz (-3,999, sw_offset, 9.5); // switch actuation      
      hull() {
        cubez (25,20,carht,  0,belt_axis-1,0); // top face
        dmirrorx() {
          if (!pscrew)
            cylz (rod_space/5.5,carht, 5,-12.5+belt_axis); 
          cylz (lbearing_dia+5,carht,   rod_space/2,0,0, 60); 
        }  
      } 
      hull() {  // rubber stop support
        cylz (8,carht, 6,-12.5+belt_axis); 
        cylz (12.5,carht, 6,-8.5+belt_axis); 
      }
      dmirrorx()
        cone3y (8,18, 0,-1.5,-3,  pscrew,-lbearing_dia/2+1,carht/2);
      if (!pscrew) hull() { // central pad
        cylz (11,4, 0,-12);
        cylz (6,3.5, 0,-18);
      }
      
    } //::: then whats removed :::
    cutx();
    cylz (-2,66, 0,-18.5); // central pad hole
    cconez (3.2,2.6, 5,20,  -sw_offset, 9.5,-1); // switch actuation
    cconez (2.5,3.2, -2,20, 6,-12.5+belt_axis,21.9); // stop fixation
    dmirrorx()  {
      cylz (lbearing_dia,22, rod_space/2,0,-0.1);
      cone3y (8,12.5, 0,1.5,3,  pscrew,9,carht/2);
    }  
    cone3z (9.5,10.5,  carht+0.2,0.8,1, -belt_side,belt_axis,-1);
    cone3z (10.5,9.5,  1,0.8,30, -belt_side,belt_axis,-1);
    tsl (0,belt_axis) { // belt anchoring hole
      hull() 
        dmirrory ()
          cylz (-2,33, belt_side,3.4,-0.1);
      hull() 
        dmirrory () {
          cylz (2,1, belt_side,3.4,carht/2+1);
          cylz (4,0.1, belt_side,3.4,carht);
        }
      hull() 
        dmirrory () {
          cylz (2.8,0.1, belt_side,3.4, -0.1);
          cylz (2,0.1, belt_side,3.4,0.5);
        }  
      }
      duplz (carht+10) // cut top/bottom (cone)
        cubez (100,100,-10);
  }  
 * cylz (15,-8, 6,-11); //rubber stop
  dmirrorx () 
    difference() {
       hull () {
          cylz (lbearing_dia+7.5,19.5-lbearing_dia/2, rod_space/2,0);
          cylz (11,5, arm_space/2,-car_hor_offset+1);
          cylz (6.5,5, wire_space/2,-car_hor_offset+1);
       }  
       tsl (arm_space/2,-car_hor_offset, car_vert_dist) {
         rot (35) {
           cubez (60,30,10, 0,0,ball_ext);  // ball plane cut
           cconez (2,5, 2,-20, wire_space/2-arm_space/2); 
         }  
         sphere(dia_ball/2+ballplay/2, $fn=40);    
       } 
       cylz (lbearing_dia,22, rod_space/2,0,-1); 
       cylz (-9.5,33, belt_side,belt_axis); // belt passage
       cutx();
       cone3y (8,12.5, 0,1.5,3,  pscrew,9,carht/2);
    }
    *cyly (3,25,pscrew,-15.3,carht/2); // bolt check
}

module oldmotor_support () { // other print orientation - abandoned yet
  offsety = motor_offset;
  rodrd = rod_space/2+4;
  rodht = -10;
  difference() { 
    union() {
      dmirrorx() {
        dmirrorz() cyly (7.5,13-offsety, 31/2,offsety,31/2); // motor holes
        cubey (3,13-offsety,38,  31/2,offsety,1.5); // sides
        tsl (rodrd,7,rodht)
          rotz(30) {
            hull() {
              cyly (12,-14,      0,2);
              cyly (12,-14,      0,2,5);
              cyly (12,-14,      0,2,-5);
            }  
          }  
        hull() { // rods ends
          cylz (15,-15,  rod_space/2,0   ,-2.5);         
          cubez (6,1,-15,         19,12.5,-2.5);
        } 
      } 
      hull() {
        cubey (46,3,3,  0,10,20+1.5); // top face
        cubey (34.5,3,4,  0,10,14);
      }  
      cubey (32,21,3,  0,offsety,-15.5);
      hull() {
        dmirrorx()
          cylz (10,3,   22,6   ,20); // top supports
        cubez (46,3,3,   0,11.5,20);
      }  
    } //::: then whats removed :::
    dmirrorx()  {
      cylz (-rod_dia,33, rod_space/2,0,-10);
      cylz (4,33,  22,6,0); // top holes
      cylz (9,10,  22,6,10); // top holes
      dmirrorz() cyly (-3,66, 31/2,0,31/2); // motor fix holes
      tsl (rodrd,7,rodht)
        rotz(30) {
          cyly (-5,99);
          hull() {
            cyly (12,15, 0,2);
            cubey (10,15,12, 5,2);
          }  
        }
    }  
    hull() 
      tsl (0,belt_axis) 
        dmirrorx() dmirrory() 
          cylz (-3,33, 6,4,-10);
    cyly (22.5, 2.5, 0,-10); // central hole
    cubey (100,10,100, 0,13); // cut face
  }  
  dmirrorx()
    difference() {
       cyly (13.5, -5, 24, 13,-10);
       cyly (11.5, -10, 24, 16,-10);
       cubey (10,-15,15,  20,16, -10);
       cubey (100,10,100, 0,13); // cut face
    } 
}

module arm_junction () { // arm connexion for M3 threaded rods
  difference() { 
    union() {
      hull() {
        cylx (-7,12);
        cylx (-6,35);
      }  
      cubez (35,5,6, 0,0,-3);
    }
    dmirrorz() 
      cubez (40,10,5, 0,0,-8);
    dmirrorx() 
      cconex (2.6,3, 1,15.5, 1.2);
  }  
}

module switchbase () {//end switch attach design to be finalized
  difference() {  
    union() {
      cylz (8,5,        sw_offset, 9.5);
      cubez (3,10,18,   -6.5, 19); 
      hull() { 
         cylz (8,3.5,  sw_offset, 9.5);
         cylz (7,3.5,   -4, 11); 
      }  
      hull() { 
        cylz (7,3.5,   -4, 11);
        cylz (10,3.5,    0, 15); //
        cubez (3,15,3.5, -6.5, 15.5); 
      }  
    } 
    cconez(3.5,5,-2,6,  sw_offset, 9.5, 7.9);  
    cconez (4,9, 2,1.8, 0,15,-0.1); 
    duplz (10)
      cylx (2, -20, 0,21,5);
  }
}

*tsl (0,0,25) 
   switchbase();

module ref_stick () { // reference for triangle assembly
  difference() {
    cubez (reference_l(), 8,6);
    cubez (reference_l()-6, 5,6, 0,0,1.5);
  }
}

module extruder_bracket () { // Lily F/S
  hta = 40;
  difference() {
    union() {
      rot(22.5) {
        cubez (19,2.8,hta, -9.5, 1.4);
        duplz (hta-12) 
          cyly (12,2.8, -19,0, 6);
      }  
      rotz(60)
        rot (0,-25.5) {
          cubez (11,2.5,hta-5,  5,1.25, 2.5); 
          duplz (hta-12)
            hull() 
              duplx (-5)
                cconey (12,8, 1.5,2.5,  7,0, 6);
        }  
    } //::: then whats removed :::
    rot (22.5) {
      duplz (hta-12) 
        //cconey (3.2,7, -2,-6, -19,1.9, 6);
        cyly (-3.2,66, -19,0, 6);
        
      hull() 
        duplx (-5) duplz (hta-38)
          cyly (-15,66, -18,0,19); 
      cubez (100,20,100, 6,-10, -10); 
    }  
    rotz(60)
      rot (0,-25.5) {
        duplz (hta-12)
          cconey (3.2,7, 1.5,2.7,  7,-0.1, 6);
        cubez (100,20,100, 6, -10); 
        hull() 
          duplz (hta-34)
            cyly (-19.5,66, 18,0, 17, 32); 
      }   
  }   
}

module boardsup (type=0,dist=115) { // control board support - Lily F/S
  offs = 9;
  voff = (type)?5:8;
  rota = (type)?60:0;
  thks = (type)?4:3.5;
  dmirrorx() {
    difference() {
      union() {
        cubez (dist/2+6,2.5,3,  dist/4+2,1.25);
        cylz (7,3.5, dist/2,offs);
        hull(){
          cylz (7,2, dist/2,offs);
          cubez (14,2.5,2, dist/2-2,1.25);
        }  
        rot(rota)         
          hull(){
            cyly (9,thks, dist/2,0,voff);
            cubez (13,3.5,0.1, dist/2-1.5,1.75);
          }
      }
      cylz (-3.2,22, dist/2,offs);
      rot(rota)         
        cone3y (3,6.2, thks,1.8,3, dist/2,-2,voff);
    }
    *gray() cylz (3,10, dist/2,offs,-3);
    *color("green")  rot (-30)   cubez (150,150,-1);
  }
}

module bowdlg () { // bowden extension - normally not needed
 difference() { 
    union() {
      hull() {
        cylx (-12,12);
        cylx (-6,26);
      }  
      cubez (26,6.5,8, 0,0,-4);
    }
    dmirrorz() 
      cubez (40,10,5, 0,0,-8.5);
    dmirrorx()  {
      cconex (4,4.5, 1,16,  0.5);
      hull() 
        duplz (15)
          cylx (diamNut4, 3.3, 2.5,0,0, 6); 
    } 
    cylx (-2,66); 
  }    
}

module Lily_signature (size=10, depth=3, x=0,y=0,z=0, nb) { // write Printer name
  mz=(size<0)?-depth/2:0;
  sz = abs(size);
  diam = sz/5;
  i = sz/7;
  small = sz*0.8;
  tn = sz*0.667;
  posi = 4.1*diam;
  posl = posi+2*diam;
  posy = posl+2.22*diam;
  mid = 2*diam-0.5*i;
  tsl (x,y,z+mz) {  
    segz (diam,depth,0,0,0,sz);
    segz (diam,depth,0,0,sz*0.45,0);
    tsl (posi) {
      segz (diam,depth,0,0,0,sz*0.40);
      cylz (diam, depth, 0,sz*0.70);
    }  
    tsl (posl) {
      segz (diam,depth,0,sz/8,0,sz);
      segz (diam,depth,0,sz/8,i,0);
    }
    tsl (posy) {
      difference() { 
         cylz (diam,depth, sz*0.215,sz*0.155);
         cylz (1.8,depth*3, sz*0.214,sz*0.281);
      }
      segz (diam,depth,sz*0.5, sz*0.45,0*sz,-sz*0.4);
      segz (diam,depth,-sz*0.08,sz*0.45,sz*0.2,sz*0);
    }
  } 
}

module Lily_plate () {
  difference() {
    plate ([""],"",60,38, 2, 3, 1.5);  
    tsl (-17,-6, -0.1) Lily_signature (16);
  } 
}

module hiding_plate () { // for Lily F and S
  difference() {
    hull()
      dmirrorx() dmirrory() 
        cylz (10, 2.2, 18,18); 
    //:::::::::::::::::::::::::::::::::
    hull()
      dmirrorx() dmirrory() 
        cylz (5, 2.2, 18,18, 0.8); 
    cone3z (6.4,3.2, 0.5,1.7,2.2,  0,0,-0.1);
  } 
  difference() {
    cylz (8,1.9);
    cone3z (6.4,3.2, 0.5,1.7,2.2,  0,0,-0.1);
  }
  difference() {
    hull () 
      dmirrorx () 
        cylz (15,5.5, 16, 40);
    //::::::::::::::::::::::::::::::::::::::::::
    hull() 
      dmirrorx () 
        cylz (11,5.5,           16,40,0.8);
    cone3z (6.4,3.2, 0.5,1.7,5,  0,40,-0.1);
  }
  difference() {
    cylz (8,5.2,                0,40);
    cone3z (6.4,3.2, 0.5,1.7,5, 0,40,-0.1);
  }
}

module PS_retainer () {
  ht=10;
  difference() {
    union() {
      cubez (72,50,ht); 
      tsl (-43,-5)
        rotz (30) 
          cubez (3.5,40,ht, 4.5,-42.5); 
      cubez (12,5,ht, 41,17);   
      hull() {
        tsl (-45,-5)
          rotz (30) 
            cubez (3,3.5,ht, 4.5,-51); 
        cylz(3.2,ht, 34.2,-23.4);
      }
    }  
    cubez (66,44,ht, 0,0,1.5); 
    cubez (62,40, 20,0,0,-1); 
    cubez (100,40,20,  0,20+19.5,-1);
    tsl (-5,-5)
      rotz(30) {
        cubez (55,45,ht+10, -18,22.5, -5); 
        cubez (20,100,ht+10, -40.1,0, -5); 
      }  
    cyly (-4,66, 41,0,ht/2); 
    rotz (30)
      cylx (-4,66, -46,-40,ht/2);  
  }
}

module door_pad (ht=20, thk=10) {
  difference() {
    union() {
      cubez (20.5,2.2,ht-5, 0,-1.1);
      cubez (19,2.2,ht, -6+3.5,-1.1);
      tsl (0,0,ht/2)
      hull ()
        dmirrorz() 
         cyly (10,-2.2, 7,0,ht/2-5, 24,0);
      cubez (7,2.2,ht, -2.1,thk+0.15+1.1);
      cubez (2.8,thk+2,ht, 0,thk/2);
    } //:::::::::::::::::::::::::::::::::::::
    duplz (ht-10)
      cone3x(3.2,6.3, -2,1.5,2, -0.5,thk/2,5);
  }
}

module ESD_shield (wd=32, dp=38, ht=46) {
  diff() {
    u() {
      cubey (wd+4.4, dp+2.2, ht);
      cubey (wd+4.4+20, 2.2, ht);
      dmirrorx() dmirrorz() 
        cone3y (9.8,6, 2.2,1.2,0 , wd/2+2.2+5, 0, ht/2-5);
    }
    cubey (wd, dp, ht, 0,-0.05,2);
    dmirrorx() dmirrorz() 
      cyly (-3,66, wd/2+2.2+5, 0, ht/2-5);
  }
}

module SSR_protect(height=38) {
  difference() { 
    union() {
      dmirrorx() {
        cubez (2, height, 15,  48,height/2);  
        cubez (10, 3, 15,  48+5, height-1.5);
        cylz (12,0.7, 53,height-1);  
      }
      cubez (98, 1.5, 15, 0,-0.75);  
    }
    dmirrorx() 
      cyly (-3.5,99, 53.5,0,7.5);
  }
}

module bed_cable_insul(leng=75) { // insulate bed power supply cables (important if Mains supply)
  diff() { 
    u() {
      cubez (leng,10,2);
      dmirrory() {
        hull() {
          cylz (2,15.5,  leng/2,4); 
          cylz (2,5,  -leng/2,4); 
        }
        
      }
      cylz (7,13.8, leng*0.36,6.5);
      cubez (7,3,13.8, leng*0.36,4.5);
      cylz (7,6.2, -leng*0.36,-6.5);
      cubez (7,3,6.2, -leng*0.36,-4.5);
    }
    cylz (-3,66, leng*0.36,6.5);
    cylz (-3,66, -leng*0.36,-6.5);
    hull() {
      cyly (-9,22, leng*0.36-9,0,12.5);
      cyly (-8,22, -leng*0.36+9,0,8.5);
    }
    hull() {
      cyly (-10,22, leng*0.36+9,0,14);
      cyly (-10,22, leng*0.52,0,14);
    }
  }
}

module cablestop(ht=1.5) {
  diff() { 
    u() {
    cubez (7,12,2);
    cubez (7,2,2+ht, 0,-5);
    cylz (7.5,2+ht,0,5);
    }
    cone3z (6,3, 0,1,15, 0,5,-0.1);
  }  
}

//duplx (10,5) cablestop();