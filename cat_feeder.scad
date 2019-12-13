// 1 unit == 1mm

FN=100;

WALL_THICKNESS=7;
SPIRAL_THICKNESS=5;
SPIRAL_R=25;
SPIRAL_LENGTH=150;
SPIRAL_MARGIN=2;

CONTAINER_WIDTH=80;
CONE_LOWER_WIDTH=10;
CONE_HEIGHT=150;

SERVO_HEAD_R=16;
SERVO_HEAD_THICKNESS=4;
SERVO_MOUNT_LENGHT=20;
SERVO_MOUNT_THICKNESS=12;
SERVO_WIDTH=24;
SERVO_OFFSET=5.5;

module 9g_motor(){/*{{{*/
  difference(){
    union(){
      color("steelblue") cube([23,12.5,22], center=true);
      color("steelblue") translate([0,0,5]) cube([32,12,2], center=true);
      color("steelblue") translate([5.5,0,2.75]) cylinder(r=6, h=25.75, $fn=20, center=true);
      color("steelblue") translate([-.5,0,2.75]) cylinder(r=1, h=25.75, $fn=20, center=true);
      color("steelblue") translate([-1,0,2.75]) cube([5,5.6,24.5], center=true);
      color("white") translate([5.5,0,3.65]) cylinder(r=2.35, h=29.25, $fn=20, center=true);
    }
    translate([10,0,-11]) rotate([0,-30,0]) cube([8,13,4], center=true);
    for ( hole = [14,-14] ){
      translate([hole,0,5]) cylinder(r=2.2, h=4, $fn=20, center=true);
    }
  }
}/*}}}*/

module spiral(height, width, spiral_thickness, core_thickness) {/*{{{*/
  union() {
    cylinder(r=core_thickness,h=height);
    translate([0,0,core_thickness-1])
    linear_extrude(height=height-core_thickness, convexity=1000, twist=360, $fn=FN)
    square([spiral_thickness, width], true);
  }
}/*}}}*/

module spiral_assembly() {/*{{{*/
  /* color("ForestGreen") */
  difference() {
    union() {
      spiral(SPIRAL_LENGTH, SPIRAL_R*2, SPIRAL_THICKNESS, WALL_THICKNESS);
      cylinder(r=SPIRAL_R,h=WALL_THICKNESS);
    }
    // servo attachment cut off
    translate([0,0,0])
      cylinder(r=SERVO_HEAD_R,h=SERVO_HEAD_THICKNESS);
    // servo screw cut off
    translate([0,0,0])
      cylinder(r=3,h=5);
  }
}/*}}}*/

module funnel() {
  upper_width = CONTAINER_WIDTH;
  walls = WALL_THICKNESS;

  inner_r_l = CONE_LOWER_WIDTH;
  inner_r_u = upper_width;

  outer_r_l = CONE_LOWER_WIDTH + walls;
  outer_r_u = upper_width + walls;

  cone_height = CONE_HEIGHT*0.6;
  cone_offset = CONE_HEIGHT*0.2;

  mount_offset = -SPIRAL_LENGTH/2;
  platform_offset = -SPIRAL_R*4;
  color("NavajoWhite")
  difference() {
    union() {
      // cone outer shell
      translate([0,0,-cone_offset])
        cylinder(r1=outer_r_l,r2=outer_r_u,h=cone_height);
      // spiral housing
      translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
        cylinder(r=SPIRAL_R+walls*2, h=SPIRAL_LENGTH, center=true);
      // servo mount
      translate([mount_offset,0,-SPIRAL_R])
        difference() {
          cube([SERVO_MOUNT_LENGHT, (SPIRAL_R+walls)*2.3, SERVO_MOUNT_THICKNESS], true);
          // servo mount cut off
          translate([0, -SERVO_OFFSET, 0])
            cube([SERVO_MOUNT_LENGHT, SERVO_WIDTH, SERVO_MOUNT_THICKNESS+2], true);
          // servo mounting holes
          for ( hole = [14,-14] ){
            translate([-6,hole-5.5,0]) rotate([0, 90, 0]) cylinder(r=1, h=SERVO_MOUNT_THICKNESS*1.1, $fn=20, center=true);
          };
        };
      // bottom platform
      translate([0,0, platform_offset])
        cube([SPIRAL_LENGTH, (SPIRAL_R+walls)*5, walls], true);
      // stands
      for (stand = [SPIRAL_LENGTH/2-walls, -SPIRAL_LENGTH/2+walls]) {
        translate([stand, 0, platform_offset*0.75])
          cube([walls, SPIRAL_R*2, SPIRAL_R*2], true);
      }

    }
    // cone cut off
    translate([0, 0, -cone_offset])
      cylinder(r1=inner_r_l,r2=inner_r_u,h=cone_height+2);
    // spiral housing cut off
    translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
      cylinder(r=SPIRAL_R+SPIRAL_MARGIN, h=SPIRAL_LENGTH+1, center=true);
  }
}

translate([0, 0, SPIRAL_R])
  funnel();
translate([-SPIRAL_LENGTH/2, 0, 0])
  rotate([0, 90, 0]) spiral_assembly();

translate([-SPIRAL_LENGTH/2-16, -5.5, 0])
rotate([90, 0, 0])
rotate([0, 90, 0])
  9g_motor();
