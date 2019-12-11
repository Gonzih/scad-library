HEIGHT=30;
WALL_WIDTH=10;


module open_circle(radius, cube_width) {
  difference() {
    cylinder(r=radius+WALL_WIDTH, h=HEIGHT);
    translate([0,0, -HEIGHT/2])
    cylinder(r=radius, h=HEIGHT*2);
# translate([0, radius, HEIGHT/2])
    cube([cube_width, radius+WALL_WIDTH, HEIGHT*2], true);
  }
}

POLE_R=35;
CABLE_R=15;

union() {
  open_circle(POLE_R, POLE_R*1.5);
  translate([-(POLE_R+CABLE_R*1.7), 0, 0])
  rotate(180)
    open_circle(CABLE_R, CABLE_R);
}
