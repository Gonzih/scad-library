$fn=50;
WALLS = 2;

minkowski() {
  difference(){
    cube([13+WALLS, 20+WALLS, 13+WALLS], true);
    translate([WALLS/2, 0, WALLS/2])
      cube([14, 21, 14], true);
  }
  sphere(1);
}
