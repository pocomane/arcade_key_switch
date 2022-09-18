
// In openscad arc are approximated with an inner polygon. This is
// good if you have, for example, to make a cylinder that must enter
// in a hole of a known radius. but if you have instead to make an
// hole that accomodates a rod of a known diameter, you need the
// outer polygon.
// For example an hole that accomodate a rod of 0.3 mm can be optained as
// follows:
//   difference(){
//     cube(size=[1,1,1]);
//     cylynder(1, outer_radius(0.3), outer_radius(0.3))
//   }
//
function outer_radius(radius, fn) = radius/cos(180/fn);

// This is similar to outer_radius, it is provided just for completeness
function middle_radius(radius, fn) = radius*(1+1/cos(180/fn))/2;

// Totate the children in a way that the Z axis will be along the provided
// directon; the other axis will be kept parallel to the original ones.
module inclinate(direction = [0, 0, 1]){
  a = norm([direction[0], direction[1], direction[2]]);
  b = acos(direction[2]/a);
  c = atan2(direction[1], direction[0]);
  rotate([0, b, c]) union() {
    children();
  }
}

// Make a slice of the children of a provided thickness. Anything starting from
// the "start" point and distant "thick" in the provided "direction" will be
// kept
module slice(direction = [0, 0, 1], start = [0, 0, 0], thick = 10000000, debug = false){
  if (debug) {
    translate(start)sphere([1,1,1]);
  }
  intersection(){
    translate(start)
      inclinate(direction){
        translate([-5000000, -5000000, 0])
          if (debug) {
            #cube(size=[10000000, 10000000, thick]);
          } else {
            cube(size=[10000000, 10000000, thick]);
          }
    }
    children();
  }
}

// Mainly an utility for rail_hole; it is a separete module just in case you want
// to insepct the rail
module rail_extrude(length, direction, tolerance = 1e-300){
  minkowski(){
    inclinate(direction)
     translate([-tolerance/2,-tolerance/2,-tolerance/2])
       cube([tolerance,tolerance,length+tolerance]);
     children();
  }
}

// Make an hole in an object to house another object. It will also make
// the rail to let the second object be inserted in the first one along
// the wanted "direction", for the wanted "length"
module rail_hole(length, direction, tolerance = 1e-300){
  difference(){
    children(0);
    rail_extrude(length, direction, tolerance){
      for (c=[1:$children-1])
        children(c);
    }
  }
}

