
use <util.scad>;
use <microswitch_obstruction.scad>;

$fn=100;  // number of face for circle
geo=0.1;  // geometrical/graphical error to let the surface correctly appear melted together
tol=0.235; // mechanical tollerance to let pieces git togethe

module arcade_key_switch(

  switch_distance = 33.2, //31.7,
  wall_thick = 4,
  base_thick = 4,

  gate_square = 17.5, //17.1
  gate_round = 17.5, //17.1
  gate_inclination = 10,//0,

  gate_border = 2.5,//2,
  gate_max_tick = 0.9,
  gate_plate_thick = 3,

  add_housing = true,
  add_gate = true,
  key_extend = false,
){

  gate_size = max(gate_square, gate_round);

  ff = switch_distance -2 * wall_thick;
  fff = 35.2 -2 * wall_thick;
  
  xxx = 10.9 + tol;//10.9=actuator diameter at gate
  xxm = max(0, (gate_round -xxx) / 2);
  xxmm = xxm*( 1 -sin( gate_inclination));

  cci = 0.95; 
  ccwf = 1.2;

  scwl = 20;
      
  h = 14 +tol;
  b = 2;
  g = 0.9 +tol;
  m = 14.4 +0.9;
  
  j = base_thick +m;
  
  aa = 7.3;
  d = 14.4;
  e = 3;
  p = 7;
  r = 2;
  ppp = 6.8;
  sss = 9;

  module four_side(){
    children();
    translate([wall_thick+fff,-wall_thick,0]) rotate([0,0,90]) children();
    translate([wall_thick+fff+wall_thick,fff,0]) rotate([0,0,180]) children();
    translate([wall_thick,fff+wall_thick,0]) rotate([0,0,270]) children();
  }

  module frame(){
    rail_hole(50, [0,0,1], tol){
      cube(size=[wall_thick,ff,j]);
      translate([wall_thick/2,ff/2,j/2+1.6])
        rotate([0,-90,180])
          microswitch_obstruction();
    }
  }

  module extended_frame(){
    translate([-(ff-fff)/2,-(ff-fff)/2,0]){
      translate([0,-wall_thick,0])cube(size=[wall_thick,wall_thick,j]);
      frame();
      uuu=5;
      translate([wall_thick,0,0])rotate([0,0,45])translate([-uuu/2,-uuu/2,0])cube(size=[uuu,uuu,j]);
    }
  }

  module gate_bevel(){
    slice(thick=100,direction=[gate_border,0,ccwf*gate_max_tick],start=[ccwf*gate_max_tick,0,0])
    slice(thick=100,direction=[-gate_border,0,ccwf*gate_max_tick],start=[gate_size+gate_max_tick*2-ccwf*gate_max_tick,0,0])
    slice(thick=100,direction=[0,gate_border,ccwf*gate_max_tick],start=[0,ccwf*gate_max_tick,0])
    slice(thick=100,direction=[0,-gate_border,ccwf*gate_max_tick],start=[0,gate_size+gate_max_tick*2-ccwf*gate_max_tick,0])
      children();
  }
  
  module gate_diamond_profile(){
    resize(newsize=[gate_square, gate_square, 0]) rotate([0,0,45]) intersection(){
      rotate([0,0,gate_inclination]) circle($fn=4);
      rotate([0,0,-gate_inclination]) circle($fn=4);
    }
  }

  module gate_round_profile(){
    translate([xxm,0,0]) circle(d=xxx,$fn=100);
    translate([-xxm,0,0]) circle(d=xxx,$fn=100);
    translate([0,xxm,0]) circle(d=xxx,$fn=100);
    translate([0,-xxm,0]) circle(d=xxx,$fn=100);
    translate([xxmm,xxmm,0]) circle(d=xxx,$fn=100);
    translate([-xxmm,xxmm,0]) circle(d=xxx,$fn=100);
    translate([xxmm,-xxmm,0]) circle(d=xxx,$fn=100);
    translate([-xxmm,-xxmm,0]) circle(d=xxx,$fn=100);
  }
 
  module gate_hole(){
    translate([0,0,gate_border+gate_plate_thick+2*geo]) rotate([180,0,0])
      linear_extrude(height=gate_border+gate_plate_thick+2*geo, scale=cci) 
        union() {
          if (gate_round > 0) gate_round_profile();
          gate_diamond_profile();
        }
  }

  module gate(){
    translate([0,-wall_thick,0]) translate([(fff-ff)/2,(fff-ff)/2,j]) difference(){
      union(){ 
        cube(size=[ff+2*wall_thick,ff+2*wall_thick,gate_plate_thick]);
        translate([-gate_size/2+ff/2+wall_thick-gate_max_tick,-gate_size/2+ff/2+wall_thick-gate_max_tick,-gate_border]) gate_bevel() cube(size=[gate_size+gate_max_tick*2,gate_size+gate_max_tick*2,gate_plate_thick+gate_border]);
      }
      translate([(ff+2*wall_thick)/2,(ff+2*wall_thick)/2,-gate_border-geo]) gate_hole();
    }
  }

  /* 
  ls56_gl=53; 
  ls56_gh=5;
  ls56_br=21/2;
  module ls56_original_gate(){
    translate([-(ls56_gl-ff-2*wall_thick)/2,-(ls56_gl-ff-2*wall_thick)/2,0])difference(){
      cube(size=[ls56_gl, ls56_gl, ls56_gh]);
      translate([ls56_gl/2,ls56_gl/2,-geo])cylinder(ls56_gh+2*geo,gate_size/2,1.1*gate_size/2,$fn=8);
      translate([0,0,-geo])cylinder(ls56_gh+2*geo,ls56_br,ls56_br);
      translate([0,ls56_gl,-geo])cylinder(ls56_gh+2*geo,ls56_br,ls56_br);
      translate([ls56_gl,ls56_gl,-geo])cylinder(ls56_gh+2*geo,ls56_br,ls56_br);
      translate([ls56_gl,0,-geo])cylinder(ls56_gh+2*geo,ls56_br,ls56_br);
    }
  }
  */

  module bevel_hole(hole_size = 3, bevel_size = 6, full_height = 1, bevel_height = 0.5){
    translate([0, 0, -full_height]) cylinder(full_height, hole_size/2, hole_size/2);
    translate([0, 0, -bevel_height]) cylinder(bevel_height, bevel_size/2, bevel_size/2);
  }

  module base(){
    difference(){
      union(){
        translate([0,-wall_thick+(fff-ff)/2,0])cube(size=[(fff-ff)/2,ff+2*wall_thick+(fff-ff)/2,base_thick-geo]);
        translate([-ppp,0,0])cube(size=[ppp,wall_thick+fff+p-d,base_thick]);
      }
      translate([wall_thick-e/2-aa, wall_thick+fff+p-d+e/2-sss, base_thick+geo]) bevel_hole(full_height = base_thick+2*geo, bevel_height = r, hole_size = e);
    }
  }

  module ls56_groove(){
    grh=1.6+tol;
    grw=3;
    grp=5.5;
    grq=21.5;
    translate([grp,grq,0])
      translate([-(grw)/2,-(grw)/2,-geo])
        cube(size=[grh,grw,grh+geo]);
  }

  module key_extension(){
    w = 5.1;
    h = 6.6;
    we = 4.6 - tol;
    he = 6.15 - tol;
    wt = 1.3 + tol;
    ht = 1.1 + tol;
    ex = 0.4;
    hd = 3.5;
    at = (we-ht)/2;
    bt = (he-wt)/2;
    dx = ht/2 + at/2;
    dy = wt/2 + bt/2;
    translate([0, 0, ex + hd/2]) difference(){
      union() {
        translate([0, 0, -ex/2 -hd/2]) cube(center=true, [w, h, ex]);
        translate([+dx, +dy, 0]) cube(center=true, [at, bt, hd]);
        translate([+dx, -dy, 0]) cube(center=true, [at, bt, hd]);
        translate([-dx, -dy, 0]) cube(center=true, [at, bt, hd]);
        translate([-dx, +dy, 0]) cube(center=true, [at, bt, hd]);
      }
      translate([0, 0, 1.4*hd]) rotate([0,45,0]) cube(center=true, [he,he,he]);
      translate([0, 0, 1.4*hd]) rotate([45,0,0]) cube(center=true, [he,he,he]);
    }
  }

  module full(){
    difference(){
      union(){
        if (add_housing){
          translate([0,wall_thick,0]) color([1,1,0])four_side()extended_frame();
          translate([0,wall_thick,0]) color([0,1,0])four_side()base();
        }
        if (add_gate){
          translate([0,wall_thick,0]) color([0,0,1])gate();
        }
      }
      translate([0,wall_thick,0]) color([1,1,0])four_side()ls56_groove();
      translate([0,wall_thick,0])four_side()translate([(fff-ff)/2,-wall_thick+(fff-ff)/2,0])translate([wall_thick/2+wall_thick*sqrt(2)/4,wall_thick/2+wall_thick*sqrt(2)/4,(j+gate_plate_thick)-scwl-tol-geo]) cylinder(scwl+tol+2*geo,1.5,1.5);
    }
    if (key_extend){
      translate([-15,0,0]) key_extension();
      translate([-25,0,0]) key_extension();
      translate([-15,15,0]) key_extension();
      translate([-25,15,0]) key_extension();
    }
  }

  full();
}

