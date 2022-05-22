
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
module slice(direction = [0, 0, 1], start = [0, 0, 0], thick = 10^6, debug = false){
  if (debug) {
    translate(start)sphere([1,1,1]);
  }
  intersection(){
    translate(start)
      inclinate(direction){
        translate([-10^6/2, -10^6/2, 0])
          if (debug) {
            #cube(size=[10^6, 10^6, thick]);
          } else {
            cube(size=[10^6, 10^6, thick]);
          }
    }
    children();
  }
}

