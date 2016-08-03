/*
Effector with kinematic positioning, also used as level sensor (see D-Box documentation). Designed to use a grooved hotend.
This effector is part of the Lily big boxed delta printer design.
(c) Pierre ROUZEAU June 2016
files in : https://github.com/PRouzeau/Lily-Delta-Printer
* Part licence : CERN OHL V1.2
* Program license GPL2 & 3
* Documentation licence : CC BY-SA
* Recommended filament : ABS, to resist heat. PLA or PETG is not recommended. PETG may be used for parts without mechanical loads 

Part 1 : Assembly, only for information
Printing without support, some bridging
Part 2 : effector base, print in 0.3mm layers, fill-in honeycomb 75%
Part 4 & 5 : hotend support, print in 0.3mm layer, fill-in honeycomb 75%
Part 6 : magnet holders (top and bottom), layer 0.2mm fine mode
part 8, 9, or 10, duct for Prometheus hotend, from 1 nut to three nuts , special printing profile.

Printing:
layer thickness 0.3
  3 walls and 3 layers on top/bottom
layer thickness 0.2  
  5 walls and 5 layers on top/bottom
On Slic3R, for infill, prefer using 3D honeycomb, which print faster than simple honeycomb 
 */ 
qpart=30;

dia_ball=8; //real ball diameter.  Ball hole programmed is 0.25mm over this diameter
ball_play = 0.25; // Increase of ball print diameter- independant from holeplay which apply only for cylinders
holeplay = 0.16;
hotdia = 15.8;
hotring = 11.8;
balldepth = 1.3; // ball 'buried' of this value (extension over ball mid plane)

nutspace=13;
nutdist=8;

//$E3DV6 = true; For e3DV6 use duct for Prometheus 2 nuts

*cubez (100,100,-1, 0,0,-25-efflow);

if (qpart) {
  if (qpart==1) rotz (60+120+90){
    rot120(30) posmag();
    effsq();
    tsl (0,0,1) {
      hotsup(); 
      hotend();
    }  
    acc();
  }  
  else if (qpart==30) effsq();  // effector base
  else if (qpart==31) { // for modelling: Assembly of hotend support
    rot(180) {
      hotsup1();    
      hotsup2();    
    }  
  }
  else if (qpart==32) {tsl (0,0,17) duplx (12,2) rot(180) maghold();
     tsl (0,25,-18) duplx (12,2) magholdtop();  
  } 
  else if (qpart==33) rot(180) duct2(1);  // 1 nut 
  else if (qpart==34) rot(180) duct2(2);  // 2 nuts  
  else if (qpart==35) rot(180) duct2(3);  // 3 nuts

  else if (qpart==36) rot(180) redress();  
  else if (qpart==37) rot(180) hotsup1();  // hotend support  - part 1  
  else if (qpart==38) rot(180) hotsup2();  // hotend support  - part 2  
  else if (qpart==39) rot (90) promduct(); // hotend Prometheus duct for 30mm fan
  else if (qpart==40) socket_test(); // to test that ball insert well
    else if (qpart==41) hotsup(); // hotend support monobloc (for checking and model)
  else if (qpart==42) rot(180) hotsup(); // hotend support monobloc (for checking and model) 
  
  else if (qpart==43) heatcolumn();    
}

include <Z_library.scad>
include <X_utils.scad>

xpart=0; // neutralise Xutils demo
// license : OHL V1.2

// new effector
function eff_hoffset() = 30; // 
arm_space=86; //84->  extend to 86 ?
wire_space=74; //68-> extend to 72 ?

diamNut3 = 6.1; // to get exact face space with hex nuts
effvoffset = 0; //effector vertical articulation (ball center) offset from bottom effector plane (positive->up) . not taken into account here where ref plane is ball center

ep_duct = 1.6; // duct thickness (not used everywhere)
//adapted for different hotend
//duct_ext=15; //low extension of the duct;

hotend_offset = 6;
hotend_dist = 17;
topsup = 36.3 ; //top of hotend support

$fn=34;

axis_pos =0;
thkx = 16; // effector thickness
ballOff = 42; //38-> 40 or 41 (check conflicts)
//ballVt =12.5;
ballVt =10.65;
balldist = 4.7; // for ball dia 8 mm
balldistv = 4.7; // for ball dia 8 mm

efflow = 13;
diapad = dia_ball+4.5;

magdia = 4.2;
maghold = 8;
magradius = ballOff-9;
magscrewsptop = 6.5;

pospfan = [0,23.5,topsup-23.5]; // part cooling fan position - shall also create a variable for angle ??
fanang = -30;

/*/ new set 
arm_space=86; //84->  extend to 86
wire_space=70;
ballOff = 41;
//adjust internal radius, offset of block */

module posmag() { // set mag holders in place
  tsl (ballOff-9) {
    maghold();
    magholdtop();
  }  
}

module socket_test() {
  diff () {
    cubez (20,20,6);
    tsl (0,0,6-balldepth)
      sphere((dia_ball+ball_play)/2);  
  }  
}

module heatcolumn () { // to be built aside effector support to let pillars cool
  cubez (8,8,17.2);
}

module rot120 (angstart=0){
  for(i=[0,120,240]) 
    rotate([0,0,i+angstart]) children();
}

module redress () {
  diff() {
    u() {
      hull() 
        dmirrorx() dmirrory() 
          cylz(6.5,-3, 12,12);
      cylz (31.2,-3 ,0,0,0, 64);
    }
     dmirrorx() dmirrory() 
       cylz(2.8,-3.5, 12,12,0.1);
     cone3z (27.2,28, 0.5,3,1  ,0,0,-3.5, 64,0);
  }
  module fin() {
    hull() {
      cubez (12,1.6,-0.1, 8.5);
      cubez (12,1.2,-0.1, 8.5,-0.25,-1.5);
    }
    hull() {
       cubez (12,1.2,-0.1, 8.5,-0.25,-1.5);
       rotz(-3)  
         cubez (1,1,-0.1, 13.65,0,-2.7);
       rotz(-20) 
         cubez (1,1,-0.1, 4,0,-7);
    }  
    //cubez (4,1,-3, 13,0);
  } 
  diff() {
    u() {
      hull() {
        cylz (15.5,-2);
        cylz (12,-12,0,2);
        cylz (1,-25,0,5);
      } 
      for (a=[0,240])
        rotz(a) fin();
      rotz(120) tsl(13) rotz(12.5) tsl(-13)fin();
    }
    hull() {
      cylz (13.5,-2, 0,0,0.1);
      cylz (10,-11.5,0,2);
      cylz (1,-23.5,0,5);
    }
  }  
}


module duct2 (ref=3) { // in fact, this is printed in spiral vase mode 
ht = 0;  
precis = 40;  
duct_thk= 1;  // this is the minimum to have wall taken into account 
cfr = 0.4; 
cut = (ref==3)?-41.5:(ref==2)?-37.5:-33.5; // cut plane distance for a given ref  
totht = (ref==3)?52:(ref==2)?49:46;
cx =  (ref==3)?1:(ref==2)?0.82:0.7; 

dsref = [  
 [28.5, 24,  20,  17, 13,  6,   5,   4, 1],// Diameter 
 [20,   16,  13,  11, 9.3,  8,   7, 6.5, 6],// Diameter ext 
 [0,    1,   3,   5,   8,   8,   6,   5, 3],//int. side offset   
 [0,   4.5,  8,  10.5, 12, 13.5,13.8,12.5,10],// external side offset
 [0,cx*2,cx*5,cx*7+1.5,cx*11,cx*12,cx*12,cx*11,cx*11],//radial offset-int
 [0,   0,   0,  3,  6,  9.5, 12, 13.5,  16.5], //radial off ext diff
 [0, 0.19*totht,0.35*totht, 0.5*totht, 0.63*totht,
    0.75*totht,  0.84*totht,  0.91*totht,  totht], // section height
 [0,   0,   0,    0,    2,    2,  2.5, 2.5,  1] // side width
];
  
dia   = 0;
diae  = 1;
sioff = 2; //int. side offset  
sxoff = 3;
rioff = 4; // radial offset - int
rxoff = 5;
hts   = 6; // section height
exwd  = 7; // widthening of sides

dx = dsref;

  module shape(reduc=0, dx) {
    dmirrorx()
      for (i=[0:7]) {
        d1 = dx[dia][i]-reduc;
        d2 = dx[dia][i+1]-reduc;
        d1e = dx[diae][i]-reduc;
        d2e = dx[diae][i+1]-reduc;
        wdext1 = dx[exwd][i]; 
        wdext2 = dx[exwd][i+1];
        dlt1 = (dx[sxoff][i]-dx[sioff][i])*0.75;
        dlt2 = (dx[sxoff][i+1]-dx[sioff][i+1])*0.75;
        hull() { // sides
          cylz (d1,-0.1, dx[sioff][i]+dlt1,dx[rioff][i]-cfr*dx[rxoff][i],         -dx[hts][i], precis);
          cylz (d1,-0.1, dx[sioff][i],dx[rioff][i],   -dx[hts][i], precis); 
          cylz (d2,-0.1, dx[sioff][i+1]+dlt2,dx[rioff][i+1]-cfr*dx[rxoff][i+1],    -dx[hts][i+1], precis);         
          cylz (d2,-0.1, dx[sioff][i+1],dx[rioff][i+1],  -dx[hts][i+1], precis);         
        } 
        hull() { // sides
          cylz (d1,-0.1, dx[sioff][i]+dlt1,dx[rioff][i]-cfr*dx[rxoff][i],         -dx[hts][i], precis); 
          duplx (wdext1)
            cylz (d1e,-0.1, dx[sxoff][i],dx[rioff][i]-dx[rxoff][i],-dx[hts][i], precis); 
          cylz (d2,-0.1, dx[sioff][i+1]+dlt2,dx[rioff][i+1]-cfr*dx[rxoff][i+1],    -dx[hts][i+1], precis);         
          duplx (wdext2)
            cylz (d2e,-0.1, dx[sxoff][i+1],dx[rioff][i+1]-dx[rxoff][i+1],-dx[hts][i+1], precis); 
        }
        hull() { // center part 
          dmirrorx() {
            cylz (d1,-0.1,  dx[sioff][i]  ,dx[rioff][i],  -dx[hts][i],   precis); 
            cylz (d2,-0.1,  dx[sioff][i+1],dx[rioff][i+1],-dx[hts][i+1], precis); 
          }
        } 
      }
  } 
  difference() { //part duct
    union() {
       // fan screw holder
      hull() 
        dmirrorx() dmirrory() 
          cylz(6,-2, 12,12, ht);
      cylz (30.7,-2, 0,0,0, 64);
      shape(0,dx);
    } //::: then whats removed :::
      dmirrorx() dmirrory() 
        cylz(2.8,-3.5, 12,12,ht+1);
     tsl (0,0,0.1) shape(duct_thk*2,dx);
     rot(-fanang)
       cubez (100,100,-35, 0,-20,cut); // cut the bottom of the duct
    }    
}  

module promduct () {
  //ypos = -15;
  ypos=-10;
  diff() {
    u() {
      hull() {
        dmirrorx() dmirrorz() 
          cyly(6.5,2.5, 12,ypos,12);
   //   cyly (31.2,2.5 ,0,ypos,0, 64);
      intersection() {  
        diff() {
          cylz (-32.5,31.5, 0,0,0.5, 96,0);
          dmirrory() 
            cubey (40,10,40, 0,8);
        }  
        tsl (0,0,-0.5) {
          diff() {
            sphere (16.25, $fn=48);
            cubez (40,40,-30);  
          }
          cylz (32.5,-32, 0,0,0.1, 96,0);
        }
      }
    }
    } //::::::::::::::::::::::::::
    hull() {
      intersection() {
        diff() {
          cylz (-30,28, 0,0, 0, 48);
          dmirrory() 
            cubey (40,10,40, 0,8.1);
        }
        tsl (0,0,-1) {
          diff() {
            sphere (15.1, $fn=48);
            cubez (40,40,-30);  
          }
          cylz (30.2,-32, 0,0,0.1, 96,0);
        }  
      }
      cone3y (27.2,28, 0.5,3,1  ,0,ypos-0.2,0, 64,0);
    }
    diff() {
      cylz (30,-20, 0,0,0, 48);
      dmirrory() 
        cubey (40,10,40, 0,8.1);
    }
    dmirrorx() 
      cyly(2.2,5, 12,ypos-0.1,12);
    cylz (-12.5, 99);
    cubey (11, 20, 99);
    hull() 
      duplz (-13.5)
        cylx (-12,66, 0,8,5);
    cubey (40,10,40, 0,4,-20);
  }
}

module effsq () {
  module cutcube(balldepth=1.3) {
    tsl (-arm_space/2, eff_hoffset())
      rotz(-45) //???
      rot(0,-35) 
          cubez (50,50,50,0,0,balldepth);
  }
  module pad() { // pads for 'V' support
    difference () {
      union() {
        hull() { 
          dmirrory() {
            cylz (6,1.5,  ballOff-8,9,ballVt-5);  // magnet attach screws  
            difference () {
               cylx (6,-6,   ballOff-5,balldist,ballVt-balldistv);  // standoff attach screws   
              cubez (10,10,10,ballOff-10,balldist,ballVt-balldistv);  
            }  
          }  
          cubez (1,15,1, ballOff-4,0,-efflow);   
          cubez (9,18.5,-4.7, ballOff-1,0,ballVt-balldist+1);   
        }
        hull() 
          dmirrory() 
            cylz (6,-4.5,  ballOff-8,9,ballVt-0.5);  // magnet attach screws   
      } // then whats removed
      dmirrory() {
        tsl (ballOff,balldist, ballVt-balldistv) {
          rot (15) cylx (-diamNut3,10, 0,0,0, 6);    
          cylx (-3,66);
        } 
        cylz (2.6,-10, ballOff-8,9,ballVt+2); // magnet screws         
        tsl (ballOff+4.5, 14)
          rotz(45) 
            cubez (10,10,10);
      }  
      cylx (-8,10, ballOff,0, ballVt-1);
    }
  } //module pad
  difference() {
    union() {
      rot120() {
        hull() { // 
        *  cubez (65,6,thkx, 0,eff_hoffset()+1,effvoffset-efflow);
          dmirrorx() 
            cubez (1,7,thkx, 42,eff_hoffset()+1.9,effvoffset-efflow);
        }  
        difference() {
          hull() {
            cubez (18,2,thkx, 0,-ballOff-12,effvoffset-efflow);  
            cubez (36,2,thkx, 0,-ballOff+7,effvoffset-efflow);  
          }  
     //  cubez (14,16,5, 0,-ballOff-1,effvoffset-efflow+11);  
        }  
        dmirrorx() {
          hull() {
            cylz(diapad,thkx, arm_space/2-0.5,eff_hoffset()-0.5,effvoffset-efflow+0.01);
            cylz(diapad+2.5,thkx-efflow+2.5, arm_space/2-0.5,eff_hoffset()-0.5,effvoffset+0.01-2.5);
            cylz(6,thkx-1, arm_space/2+5,eff_hoffset()-10,effvoffset-efflow+0.01);
          }
        }
      }
      difference() { // fan extent
        translate (pospfan) 
          rot (fanang) 
            hull() 
              dmirrorx() {
                tsl (0,18)
                  rot (-fanang) {
                    cylz (5,-13,  18,0,  12.2-efflow);
                    cylz (10,-19, 38,-8, 12.2-efflow);
                  }  
                cylz (24,-1, 12,16,-14);
              }  
        cubez (150,150,-15, 0,0,-efflow); // cut bottom
        cubez (150,20,15,   0,eff_hoffset()-14.5,-efflow-1); // cut face  
      }
      
    } //::: then whats removed :::
    hull() 
      rot120()  // internal removal
        dmirrorx() {
          cylz(10,thkx+5, arm_space/2-22.6+1.5,eff_hoffset()-6.5,effvoffset-efflow-1);
          cylz(10,1, arm_space/2-22.6+3.5,eff_hoffset()-6.5,effvoffset-efflow-2);
        }  
    for (a = [240,120]) 
      rotz (a)    
        hull() 
          dmirrorx() 
            tsl (arm_space/2-18,eff_hoffset()+8, -efflow+thkx/2) 
               sphere (4.5);   
        cylx (-9.5, 111,  0, eff_hoffset()+14.2, -efflow+thkx/2-0.5); 
    rot120() { // 
    // cubez (17,25,5, 0,-ballOff-4,effvoffset-efflow+11); 
      
      dmirrorx() {
        tsl (arm_space/2,eff_hoffset(), axis_pos) {
          sphere((dia_ball+ball_play)/2);
          tsl (0,1) { // wires are offset 1mm for clearance
            rot(-35)  // wire cones
              cone3z (2,20 ,-1.5,12,3, -arm_space/2+wire_space/2);
            cylz (2,-15, -arm_space/2+wire_space/2,-0.75,-1);
          }  
          tsl (-arm_space/2+wire_space/2,-0.75,-1)
            sphere (1);
          rot(-35) // ball biased face cut
            hull() { // add balldepth 
              cyly(-8,14, 7,1,4+balldepth);
              cyly(-8,14, -5,1,4+balldepth);
            }  
        }
      }  
    }
    cylz (2,10, 0,eff_hoffset()+6.5, -10); //hole for screw wire guide ??
    translate (pospfan)   // part fan opening
      rot (fanang) {
        hull() {
          cylz (30,-1, 0,0,0.1, 50);
          dmirrorx() {
            cylz (20,1,  16, 10,-20, 50);
            cylz (9,2,     13,10,  2, 50);
            cylz (3,-20,   28, 0, -6);
            cylz (3,-2,   27.2, 16, -26);
          }
        } 
      }  
  }
  rot120(30) pad();   
}  

module maghold () {
  difference() {
    union() {
      hull()  
        dmirrory() 
          cylz (5,7,  1,9,ballVt-0.4); //joining bar
      dmirrory() 
        cylz (8,7, 1,9,ballVt-0.4);  // screw cylinders
      cylz (10,7,  0,0,ballVt-0.4);  // magnet cylinder (diam 5 +3)
    } //::: then whats removed :::
    dmirrory() {  
      cylz (-3,66, 1,9); // magnet screws    
      cconez (6.5,3, -1.7,-1,  1,9,ballVt-0.4+6.5); // cone for screw heads
    }
    cylz (6.5,8-0.7, 0,0,ballVt-1.4);
    tsl (9,0,ballVt+0.6) sphere(5.2); 
  }
}

module magholdtop (vpos=ballVt+6.8) {
  dmag = 6;
  hmag = 6;
  difference() {
    union() {
      hull()  
        dmirrory() 
          cylz (4,hmag+1,  0,magscrewsptop,vpos);
      hull()  
        dmirrory() 
          cconez (8,6,3,hmag-2, 0,magscrewsptop,vpos);
      cylz (dmag+4,hmag+1,  0,0,vpos); 
    } //:::::::::::::::::::::::::::::::::::::::::::::
    dmirrory()  { 
      cylz (-3,66, 0,magscrewsptop); // magnet screws    
      cconez (6.5,3, 1.7,-1.2,  0,magscrewsptop,vpos+0.5);
    }  
    cylz (dmag+0.5,hmag+1, 0,0,vpos+0.6);
  }
}

module hotsup1 () { // large part of support
  difference() { 
    union() {
      difference() {
        hotsup();
        hull() { // hole
          cylz (hotdia,66);
          cylz (hotdia,66, 0,-5);
        }
      }
      ring(true);
    }
    cubez (100,100,100, 0,-50-2); 
  }
}

module hotsup2 () { // small part of support
  difference() {
    hotsup();
    cubez (100,100,100, 0,50-2); 
  } 
}

module hotsup () {
  hsup = 13;
  module sect() { 
    difference () {   
      union() {
        hull() {
          tsl (5,0,topsup)
            cylz (19,-hsup);  
          tsl (ballOff-3,0,topsup)
             cubez (3,6,-hsup); 
        } 
        cone3z (9.5,8.5, -6,-3,-10, ballOff,0,topsup);
        
        hull() { // magnet attach
          dmirrory()   
            cylz (6,-13.5, ballOff-9,magscrewsptop,topsup); // magnet screws    
          cylz (9,-13.5, ballOff-9,0,topsup); // magnet screws      
        }  
        hull() { // magnet attach
             
          cylz (6.5,-13.5, ballOff-3,0,topsup); // magnet screws    
          cylz (9,-13.5, ballOff-9,0,topsup); // magnet screws      
        }  
        
      } //::: then whats removed :::
      hull() {    
        tsl (5,0,topsup-1.5)
          cylz (16,-(hsup-4));
        tsl (32,0,topsup-1.5)
          cylz (3,-(hsup-3));
      } 
      cylz (1,10, 22.5,0,20);
      cylz (-4,99,  ballOff); // pylon holes
      dmirrory()   
        cylz (-2.6,99, ballOff-9,magscrewsptop); // magnet screws    
      cylz (10.3,-9,   ballOff-9,0,topsup-13.5); // magnet holders    
    }
  } // end sect()
  module fanplace() {
    translate (pospfan)  // fan attach holes
      rot (fanang) {
        dmirrorx() {
          cylz (-3,66, 12,-12,6);
          cylz (7,6, 12,-12,14.5);
        }
        hull() dmirrorx() dmirrory() {
          cylz (3.8,-15, 13.5,-13.5,11);
          cylz (3,-15, 18,-10,11);
        }  
      }   
  } 
  difference() { 
    union() {
      cylz (25, -hsup,  0,0,topsup, 60); 
      cubez (32,15, -hsup, 0,-1,topsup); 
      rot120(30) sect();
      dmirrorx() {// filleting (by manual tangenting...)
         difference() {
           cylz (4,-hsup, 4, 11.8, topsup); 
           cylz (-11,99,  3.6, 17.57); 
         }
         difference() {
           cylz (2.4,-hsup,  9.3,-9, topsup); 
           cylz (-3.4,99,  10.27, -10.19); 
         }
       }  
       difference() {
         cylz (9,-hsup, 0,-12.5, topsup); 
         cylz (-16,99, 0,-22,0, 50); 
       } 
       difference() { // fan support
         translate (pospfan) 
           rot (fanang) { 
             dmirrorx() 
               hull() {
                 cylz (9,4, 12,-12,11);
                 cubez (12,6,-16,  13.5,-22,19);
               }  
          }      
        cubez (150,150,15, 0,0,topsup);
      } 
      dmirrorx() 
        rotz(30)  // toolchange attach
          tsl (0,-1)
           dmirrory()
             hull() {  
               cylx (7,-1,     -18,14.5,topsup-hsup/2);
               cubex (-1,7,1,  -18,14.5,topsup-0.5);
               cylx (10,-6,     -10,14.5,topsup-hsup/2);
               cubex (-6,10,1,  -10,14.5,topsup-0.5);
             }
     } //::: then whats removed :::
     fanplace();
     dmirrorx()  
       rotz(30) // toolchange attach
         tsl (0,-1)
           dmirrory() {  
             cylx (-3.2,10, -16,14.5,topsup-hsup/2);
             hull() 
               duplz (10)
                 cylx (diamNut3,2.7, -15.5,14.5,topsup-hsup/2, 6);
          }  
     cylz (-16,99); 
     dmirrorx() {
       duplz (-(hsup-6)) 
         cyly (-3,28,  nutspace,-1, topsup-3);    
       cubez (5.4,2.7,66, nutspace,nutdist, 0); 
     }
     cylz (-2.5,99,0,-11.5); 
  } 
  difference()  {
    dmirrorx() { // add nut retainers
      difference() {
        union() {
          cubez (9,6.5,-12, nutspace, nutdist+0.5,topsup); 
          duplz (-(hsup-6)) 
            cyly (6,24, nutspace,-8.5, topsup-3);    
        } // then whats removed 
        cubez (5.4, 2.7,66, nutspace, nutdist, 0); // nut hole
        duplz (-(hsup-6)) 
          cyly (-3,28, nutspace,-1, topsup-3);    
        tsl (0,0,11) // fan space again
          hull()
            dmirrorx() 
              cyly (4,-11, 10.7,-8,10.7);
        fanplace();
      } 
    } //mirror
  } 
  ring();
}

module toolchange (xoffset=3) {
  nutspace=12.5;       
  thk = 3;
  plugdist = 31;
  
  module pad(dec=0) {
    difference() {
      union() {
        hull() {
           cubez (8,11,4, 24,dec,topsup);   
           cylz (12,4,    plugdist,0,topsup);   
        }
        if (!dec)  // magnet attach
          hull() {
            cylz (12,4,  plugdist,0,topsup);   
            dmirrory() 
              cylz (6,4, plugdist+6,4,topsup);   
          }  
      }
      dmirrory() 
        cylz (-2.5,33, plugdist+6,4,topsup);   
      cconez (7,11,-3,4, plugdist,0,topsup+5.5);   
    }
  }
  tsl (xoffset) {
    difference() {
      union() {
         dmirrory() {// assembly holes
           hull() 
             duplz (12.50) 
               cylx (6.5,thk, 20,nutspace, topsup-9);
           tsl (0,19,3) 
              pad(-6.5); 
           hull() {
             cubex (3,2.5,2,  20,8, topsup-8);  
             cubex (8,2.5,4,  20,8, topsup+5.5);  
           }  
           hull() {
             cubex (8,2.5,1,  20,8, topsup+7);  
             cubex (8,2,2,  20,6, topsup+29);  
           }  
         }
         tsl (0,0,topsup-9) 
            pad();         
      }//::: then whats removed :::
      dmirrory() // assembly holes
        duplz (6) 
          cylx (-3,99, 20-0.8,nutspace, topsup-9);
    }
    *dmirrory() 
      color ("grey") 
        cylz (-7,20, plugdist,19);
  }
}

module toolsup (xoffset=-3) {
  plugdist = 31;
  module pad(dec=0) {
    difference() {
      union() {
        hull() {
          cylz (10,4,    plugdist,   0,  topsup-4);   
          cubez (8,11,4, plugdist+10,dec,topsup-4);   
        }
        if (!dec)  // magnet attach
          hull() {
            cylz (12,4,  plugdist,0,topsup-4);   
            dmirrory() 
              cylz (6,4, plugdist+6,4,topsup-4);   
          }  
        cconez  (7,2,7,4,  plugdist,0,topsup);
      } //::: then whats removed :::
      if (!dec)
        dmirrory()  //magnet holder attach
          cylz (-3,33, plugdist+6,4,topsup);   
    }
  }
  tsl (xoffset+6) {
    difference() {
      union() {
        dmirrory() {// assembly holes
          tsl (0,19,3) 
            pad(-6.5);
        }
        tsl (0,0,topsup-9) 
          pad();    
      } //::: then whats removed :::
    }
   }      
}

module ring (prl=false) {
  ringext = ($E3DV6)?1.4:0;
  polygon = [[hotring/2,0],[hotring/2,4.5+ringext],[8.5,4.65+ringext],[8.5,-0.2]]; // ring larger than hole
  tsl (0,0,topsup-10.5) {
    difference() {
      rotate_extrude($fn=200) polygon(points=polygon);
      if (prl) //cut middle
        cubez (40,40,40, 0,-20,-10);
    }  
    if (prl)
      dmirrorx()
        rot (90) 
          linear_extrude(height=5) polygon(points=polygon); 
  }
}

module hotend () {
    tsl (0,0,0) rotz(-90) { //also  -22.5 
        if ($E3DV6) {
          color("silver")
            rotz(180)
              tsl (-2.18,0,topsup-64.2+1.5)
                import ("STL_Big/E3D-V6.stl");
          rotz (60){
            tsl (0,0,topsup-44) // hotend fan and duct
              rotz(180) rot (90)import ("STL_Big/V6.6_Duct.stl");
            tsl (15,0,topsup-28) // hotend fan
              rot(0,90) build_fan(30,10);
          }  
          rotz(90)
            translate (pospfan) {// part cooling fan
              rot(fanang) {
                tsl (0,0,2-3) duct2(2);
                tsl (0,0,2) redress();
              }  
            } 
        }  
        else  { 
          color("silver")
            tsl (0,0,topsup-68.4) // 6.6 mm between vertical positions
              import ("STL_Big/Prometheus3nuts.stl");
          tsl (10,0,topsup-31.3+2.7) // hotend fan
            rot(0,90) build_fan(30,10);
          tsl (0,0,7.7) rotz(90) promduct();
          rotz(90)
            translate (pospfan) {// part cooling fan
              rot(fanang) {
                tsl (0,0,2-3) duct2(3);
                tsl (0,0,2) redress();
              }  
            }  
        }  
    }
    color ("grey")
      dmirrorx() // assembly bolts
        duplz (-7) 
          cyly (3,-25, nutspace,10, topsup-3);
*  color("silver")
      tsl (2.8,0,23)
        rot(90,0,90) import ("Chimera4.stl");
}

module acc () {
   // accessories viewing
  module arm() {  cylz (4,80);  }
  module supp() { // support system
    tsl (ballOff, 0,ballVt) {  
      sphere(4); //kinematic positioner ball
      cylz (4,30);
    }  
    dmirrory()  // V made with standoffs
      tsl (ballOff,balldist, ballVt-balldistv)
        rot(15) cylx (-diamNut3,10, 0,0,0, 6);  //retaining standoffs (hex or round) 
  }  
  color("silver")
    rot120(30) supp();
  translate (pospfan) // part cooling fan
    rot(fanang) tsl (0,0,2) build_fan(30,10);
  *tsl (0,26,topsup+1)  // test for a fan above support ... not very conclusive
    rotz (0)build_fan(30,10);
  rot120() { // arms
    dmirrorx() {
      color("silver") 
        tsl (arm_space/2,eff_hoffset(), axis_pos) {
          sphere(4); // articulation ball
          rot (0,-15) arm();
          rot (0,15)  arm();
        } 
      color("white") // wires are offset 1mm for clearance
        tsl (wire_space/2,eff_hoffset()+1, axis_pos) {
          rot (0,-15) cylz (1,100);
          rot (0,15)  cylz (1,100);
        }  
    }   
  }
}    
