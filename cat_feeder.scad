// 1 unit == 1mm

FN=100;

WALL_THICKNESS=7;
SPIRAL_THICKNESS=5;
SPIRAL_R=25;
SPIRAL_LENGTH=150;
SPIRAL_MARGIN=2;

CONTAINER_WIDTH=80;
CONE_LOWER_WIDTH=30;
CONE_HEIGHT=60;

SERVO_HEAD_R=10;
SERVO_HEAD_THICKNESS=1;


module spiral(z_step, compression, height, width, spiral_thickness, core_thickness) {/*{{{*/
  union() {
    cylinder(r=core_thickness,h=height);
    translate([0,0,core_thickness-1])
    linear_extrude(height=height-core_thickness, convexity=1000, twist=360, $fn=FN)
    square([spiral_thickness, width], true);
  }
}/*}}}*/

module spinny_thing() {/*{{{*/
  difference() {
    union() {
      spiral(1, 1, SPIRAL_LENGTH, SPIRAL_R*2, SPIRAL_THICKNESS, WALL_THICKNESS);
      cylinder(r=SPIRAL_R,h=WALL_THICKNESS);
    }
    translate([0,0,0])
      cylinder(r=SERVO_HEAD_R,h=SERVO_HEAD_THICKNESS);
    translate([0,0,0])
      cylinder(r=3,h=2);
  }
}/*}}}*/

module funnel(upper_width, walls) {
  inner_r_l = CONE_LOWER_WIDTH;
  inner_r_u = upper_width;

  outer_r_l = CONE_LOWER_WIDTH + walls;
  outer_r_u = upper_width + walls;
  difference() {
    union() {
      cylinder(r1=outer_r_l,r2=outer_r_u,h=CONE_HEIGHT);
      translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
        cylinder(r=SPIRAL_R+walls*2, h=SPIRAL_LENGTH, center=true);
    }
    translate([0, 0, -walls])
      cylinder(r1=inner_r_l,r2=inner_r_u,h=CONE_HEIGHT+walls*2);
    translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
      cylinder(r=SPIRAL_R+SPIRAL_MARGIN, h=SPIRAL_LENGTH+20, center=true);
  }
}

translate([0, 0, SPIRAL_R])
  funnel(CONTAINER_WIDTH, WALL_THICKNESS);
translate([-SPIRAL_LENGTH/2, 0, 0])
  rotate([0, 90, 0]) spinny_thing();
