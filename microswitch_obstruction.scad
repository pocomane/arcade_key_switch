use <util.scad>;

geo = 0.1;
$fn = 100;

module microswitch_obstruction(){

  fh = 1;
  fw = 15.6;
  fv = 2.55;
  fd = 15.6;

  th = 5.1;
  tw = 9.5;
  td = 11.8;
  to = 3.2;

  md = 13.80;
  mw = 14.35;

  bh = 5.7;
  bw = 14;
  bv = 13.5;
  bd = 13;
  bt = 2;
  bb = 0.4;

  ph = 3.1;
  pr = 3.8/2;

  ch = 3.6;
  cw = 0.4;
  cd = 1;

  as = 4.4;
  af = 2;
  bs = 3.2;
  bf = 4.4;
  hd = 7.6;
  hw = 0.9;
  hl = 2.7;

  sh = 4;
  sw = 5.6;
  sd = 7.2;

  xd = 1.025;
  xh = 1.25;
  xw = 3.2;
  xo = 4.65;

  module trap(thick){
    rotate([0, -90, 0]) linear_extrude(thick, center=true) polygon([
        [ 0, -mw/2],
        [ 0, mw/2],
        [ th, to-mw/2+tw],
        [ th, to-mw/2]
    ]);
  }

  difference(){
    translate([0,0,fh/2])union(){

      // top
      trap(td);
      intersection(){
        trap(td+2*xd);
        union(){
          translate([-td/2-xd, -xo+fw/2,0]) cube([td+2*xd, xo, xh]);
          translate([-td/2-xd, -fw/2, 0]) cube([td+2*xd, xo, xh]);
        }
      }

      // bottom
      translate([0,0,-bt/2]) cube([md,bw,bt], center=true);
      translate([0, 0, -bh]) linear_extrude(bh-bt, scale=[md/bd,bw/bv], slices=1) square([bd, bv], center = true);
      translate([0,0,-bh-bb/2])cube([bd,bv,bb],center=true);

      // button
      translate([0,0,sh]) cube([sd, sw, 2*th], center=true);

      // flange
      translate([-fd/2, -(fw-mw)/2-mw/2, -fh]) cube([fd, fv, fh]);
      translate([-fd/2, -fv+fw/2, -fh]) cube([fd, fv, fh]);

      // pcb mount
      translate([0, 0, -bh-bb-ph]) cylinder(ph, outer_radius(pr, $fn), outer_radius(pr, $fn));
      translate([-as+bd/2, -af+bw/2, -bh-bb-ch]) cube([cd,cw,ch]);
      translate([bs-cd-bd/2, -bf+bw/2, -bh-bb-ch]) cube([cd,cw,ch]);
    }
    union(){

      // hole
      translate([-hd/2, -mw/2+(to-hl)/2, -bh-bb-geo]) cube([hd, hl, bh-bb+2*geo]);
      translate([-hd/2, -mw/2+(to-hw)/2, -geo]) cube([hd, hw, th+2*geo]);
    }
  }

}

