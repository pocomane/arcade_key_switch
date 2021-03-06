
use <util.scad>;
use <arcade_key_switch.scad>;

BUILD = "overview";

module main(){
  if (BUILD == "overview"){
    // Full default model for showcase purpose
    arcade_key_switch();
  }
  if (BUILD == "housing"){
    arcade_key_switch(add_gate = false);
  }
  if (BUILD == "gate_round"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_is_round = true, gate_inclination = 10);
  }
  if (BUILD == "gate_diamond"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_is_round = false, gate_inclination = 10);
  }
  if (BUILD == "gate_square"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_is_round = false, gate_inclination = 0);
  }
  if (BUILD == "gate_octogonal"){
    // TODO : fix this. The octognonal hole should be rotated by 45 degree.
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_is_round = false, gate_inclination = 45);
  }
  if (BUILD == "base_slice"){
    // This is useful to check if all the measurements are right
    slice(thick=0.2,start=[0,0,0]) arcade_key_switch();
  }
}

// --------------------------------------------------------------------------------
main();

