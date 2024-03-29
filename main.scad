
use <util.scad>;
use <arcade_key_switch.scad>;
use <microswitch_obstruction.scad>;

BUILD = "overview";

module main(){
  if (BUILD == "overview"){
    // Full default model for showcase purpose
    arcade_key_switch(key_extend = true, gate_round = 0, gate_inclination = 10);
  }
  if (BUILD == "housing"){
    arcade_key_switch(add_gate = false);
  }
  if (BUILD == "gate_round"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_square = 0, gate_inclination = 10);
  }
  if (BUILD == "gate_diamond"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_round = 0, gate_inclination = 10);
  }
  if (BUILD == "gate_square"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_round = 0, gate_inclination = 0);
  }
  if (BUILD == "gate_octogonal"){
    rotate([180,0,0]) arcade_key_switch(add_housing = false, gate_round = 0, gate_inclination = 22.5);
  }
  if (BUILD == "base_slice"){
    // This is useful to check if all the measurements are right
    slice(thick=0.2,start=[0,0,0]) arcade_key_switch();
  }
  if (BUILD == "key_switch"){
    microswitch_obstruction();
  }
}

// --------------------------------------------------------------------------------
main();

