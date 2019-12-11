WALL_THICKNESS=10;
OUTER_R_U=60;
OUTER_R_L=30;
INNER_R_U=OUTER_R_U-WALL_THICKNESS;
INNER_R_L=OUTER_R_L-WALL_THICKNESS;
HEIGHT=60;

* difference() {
  cylinder(r1=OUTER_R_L,r2=OUTER_R_U,h=HEIGHT);
  translate([0, 0, -5])
    cylinder(r1=INNER_R_L,r2=INNER_R_U,h=HEIGHT+10);
}


module spiral(step, height, width, spiral_thickness, core_thickness) {
  union() {
    cylinder(r=core_thickness,h=height*2);
    for (i=[0 : step : height*2]) {
      rotate(i*2)
        translate([0, 0, i])
        cube([spiral_thickness, width, spiral_thickness], true);
    }
  }
}

/* resize([0.5, 0.5, 0.5]) */
spiral(0.1, 200, 100, 5, 5);
