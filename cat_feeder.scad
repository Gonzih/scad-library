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

module round_bar(thickness, width) {
  rotate([0, 90, 0])
    cylinder(r=thickness, h=width, center=true);
}

module spiral(z_step, compression, height, width, spiral_thickness, core_thickness) {
  union() {
    cylinder(r=core_thickness,h=height*2);
    for (i=[0 : z_step : height*2*compression]) {
      rotate(i*2)
        translate([0, 0, i/compression])
        round_bar(spiral_thickness, width);
    }
  }
}

difference() {
  union() {
    spiral(1, 1, 200, 100, 5, 5);
    cylinder(r=55,h=10);
  }
  translate([0,0,-10])
    cylinder(r=55,h=10);
}
