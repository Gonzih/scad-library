DEBUG=false;

$fn = DEBUG ? 30 : 100;

WALL_THICKNESS = 3;
EXTERNAL_RADIUS = 50;
DECOY_HOLE_RADIUS=4.5;
HOLES_STEP_X=30;
HOLES_STEP_Z=30;
MAIN_HOLE_RADIUS=8;
LIP_HEIGHT=20;
LIP_INNER_HEIGHT=10;

module main_sphere() {
  difference() {
    sphere(r=EXTERNAL_RADIUS);
    sphere(r=EXTERNAL_RADIUS-WALL_THICKNESS);
    for ( rotation_x = [0 : HOLES_STEP_X : 360],
          rotation_z = [0 : HOLES_STEP_Z : 360] ){
        rotate([rotation_x, rotation_z, 0])
          translate([0, 0, -EXTERNAL_RADIUS])
           cylinder(r=DECOY_HOLE_RADIUS, h=EXTERNAL_RADIUS*2);
    }
  }
}

module lip_hole() {
  cylinder(r=MAIN_HOLE_RADIUS, h=LIP_HEIGHT);
}

module lip() {
  difference() {
    cylinder(r2=MAIN_HOLE_RADIUS+WALL_THICKNESS, r1=MAIN_HOLE_RADIUS*3+WALL_THICKNESS, h=LIP_HEIGHT);
    lip_hole();
  }
}

difference() {
  union() {
    main_sphere();
    translate([0,0,-(LIP_HEIGHT-LIP_INNER_HEIGHT+EXTERNAL_RADIUS)]) lip();
  }
  translate([0,0,-(LIP_HEIGHT-LIP_INNER_HEIGHT+EXTERNAL_RADIUS)]) lip_hole();
  difference() {
    sphere(r=EXTERNAL_RADIUS*3);
    sphere(r=EXTERNAL_RADIUS);
  }
  if (DEBUG)
    translate([EXTERNAL_RADIUS, 0, 0])
      cube([EXTERNAL_RADIUS*2, EXTERNAL_RADIUS*2, EXTERNAL_RADIUS*2], center=true);
}
