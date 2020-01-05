// 1 unit == 1mm

$fn=100;
SPIRAL_FN=50;

PLATFORM_SIZE_X=70;
PLATFORM_SIZE_Y=90;
PLATFORM_HEIGHT=75;

WALL_THICKNESS=3;
SPIRAL_THICKNESS=5;
SPIRAL_R=22;
SPIRAL_LENGTH=90;
SPIRAL_MARGIN=2;
SPIRAL_CORE_THICKNESS=5;

CONTAINER_WIDTH=80;
CONE_LOWER_WIDTH=30;
CONE_HEIGHT=100;

SERVO_HEAD_R=16;
SERVO_HEAD_THICKNESS=1;
SERVO_MOUNT_LENGHT=20;
SERVO_MOUNT_THICKNESS=12;
SERVO_WIDTH=25;
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
    translate([0,0, WALL_THICKNESS])
    linear_extrude(height=height-WALL_THICKNESS, convexity=1000, twist=360, $fn=SPIRAL_FN)
    square([spiral_thickness, width], true);
  }
}/*}}}*/

module spiral_assembly() {/*{{{*/
  color("pink")
  difference() {
    union() {
      spiral(SPIRAL_LENGTH, SPIRAL_R*2, SPIRAL_THICKNESS, SPIRAL_CORE_THICKNESS);
      cylinder(r=SPIRAL_R,h=WALL_THICKNESS);
    }
    // servo attachment cut off
    translate([0,0,0])
      cylinder(r=SERVO_HEAD_R,h=SERVO_HEAD_THICKNESS);
    // servo screw cut off
    translate([0,0,0])
      cylinder(r=3,h=4);
  }
}/*}}}*/

module bottom_platform(height) {/*{{{*/
  walls = WALL_THICKNESS;

  color("pink")
  difference() {
    union() {
      // bottom platform
      cube([PLATFORM_SIZE_X, PLATFORM_SIZE_Y, walls], true);
      // stands
      for (stand = [PLATFORM_SIZE_X/2-5, -PLATFORM_SIZE_X/2+2]) {
        echo(stand=stand);
        translate([stand, -SPIRAL_R, 0])
          cube([walls, SPIRAL_R*2, height]);
      }
    }

    // arduino placeholder cut off
    translate([-27,-34, 0.5])
      arduino_base();
    // switch hole
    translate([-PLATFORM_SIZE_X/2+4, -SPIRAL_R*0.8, 15])
    rotate([0, 90, 0])
      cylinder(r=3, h=WALL_THICKNESS*2, center=true);
    // cut off main housing
    translate([0, 0, height+10])
      spiral_housing_cylinder();
  }
}/*}}}*/

module spiral_housing_cylinder() {/*{{{*/
  // spiral housing
  walls = WALL_THICKNESS;
  translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
    cylinder(r=SPIRAL_R+walls*2, h=SPIRAL_LENGTH, center=true);
}/*}}}*/

module spiral_housing_cutoff_cylinder() {/*{{{*/
    translate([0,0, -SPIRAL_R]) rotate([0, 90, 0])
      cylinder(r=SPIRAL_R+SPIRAL_MARGIN, h=SPIRAL_LENGTH+1, center=true);
}/*}}}*/

module servo_mount_brackets() {/*{{{*/
  walls = WALL_THICKNESS;

  intersection() {
      difference() {
        union() {
          // cube([SERVO_MOUNT_LENGHT, (SPIRAL_R+walls)*2, SERVO_MOUNT_THICKNESS], true);
          translate([16, -SERVO_OFFSET, 0])
            scale([1, 2, 2])
            sphere(SPIRAL_R+walls*2);
        }
        // servo mount cut off
        translate([0, -SERVO_OFFSET, 0])
          cube([SERVO_MOUNT_LENGHT*10, SERVO_WIDTH, SERVO_MOUNT_THICKNESS*10], true);
        // servo mounting holes
        for ( hole = [14,-14] ){
          translate([-6,hole-5.5,0]) rotate([0, 90, 0]) cylinder(r=1, h=SERVO_MOUNT_THICKNESS*10, $fn=20, center=true);
        };
      };
    translate([0,0,SPIRAL_R])
     spiral_housing_cylinder();
  };
}/*}}}*/

module main_body() {/*{{{*/
  upper_width = CONTAINER_WIDTH/2;
  walls = WALL_THICKNESS;

  inner_r_l = CONE_LOWER_WIDTH/2;
  inner_r_u = upper_width;

  outer_r_l = CONE_LOWER_WIDTH/2 + walls;
  outer_r_u = upper_width + walls;

  cone_height = CONE_HEIGHT*0.6;
  cone_offset = CONE_HEIGHT*0.2;

  mount_offset = -SPIRAL_LENGTH/2;
  color("palegreen")
  difference() {
    union() {
      // cone outer shell
      translate([0,0,-cone_offset])
        cylinder(r1=outer_r_l,r2=outer_r_u,h=cone_height);
      // spiral housing
      spiral_housing_cylinder();
      // servo mount
      translate([mount_offset,0,-SPIRAL_R])
        servo_mount_brackets();
    }
    // cone cut off
    translate([0, 0, -cone_offset])
      cylinder(r1=inner_r_l,r2=inner_r_u,h=cone_height+2);
    // spiral housing cut off
    spiral_housing_cutoff_cylinder();
  }
}/*}}}*/

module funnel() {/*{{{*/
  length = SPIRAL_LENGTH*0.6;

  color("silver")
  difference() {
    translate([length, 0, 0]) rotate([0, 20, 0])
      difference() {
        spiral_housing_cylinder();
        spiral_housing_cutoff_cylinder();
        cube([SPIRAL_LENGTH+1, SPIRAL_R*3, SPIRAL_R*3], true);
      }

    spiral_housing_cylinder();
  }
}/*}}}*/

module arduino_base() {/*{{{*/
  w = 66.1;
  we = 66.8;
  h = 53.34;
  holes = [[  2.54, 15.24 ],
           [  17.78, 66.04 ],
           [  45.72, 66.04 ],
           [  50.8, 13.97 ]];
  linear_extrude(height=2, center=true)
    difference() {
      polygon(points=[[  0.0, 0.0 ],
                      [  53.5, 0.0 ],
                      [  53.5, 66.04 ],
                      [  50.8, 66.04 ],
                      [  48.26, 68.58 ],
                      [  15.24, 68.58 ],
                      [  12.7, 66.04 ],
                      [  1.27, 66.04 ],
                      [  0.0, 64.77 ]]);
      for (p=holes) translate(p) circle(d=2);
    }
}/*}}}*/

// DEMO
* union() {
  translate([0, 0, -PLATFORM_HEIGHT+12])
    bottom_platform(PLATFORM_HEIGHT);
  translate([0, 0, SPIRAL_R])
    main_body();
  translate([0, 0, SPIRAL_R-0.5])
    funnel();
  translate([-SPIRAL_LENGTH/2, 0, 0])
    rotate([0, 90, 0]) spiral_assembly();
  translate([-SPIRAL_LENGTH/2-16, -5.5, 0]) rotate([90, 0, 0]) rotate([0, 90, 0])
  9g_motor();
}


* bottom_platform(PLATFORM_HEIGHT);
main_body();
* servo_mount_brackets();
* rotate([0, 160, 0])
  funnel();
* spiral_assembly();
