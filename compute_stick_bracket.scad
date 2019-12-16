$fn=200;

THICKNESS=12;
WIDTH=38;
LENGTH=6;
WALLS=2;

difference(){
  union() {
    cube([THICKNESS+WALLS*2, WIDTH+WALLS*2, LENGTH+WALLS*2], true);
    translate([-THICKNESS/2-WALLS/2, 0, 0])
      cube([WALLS, WIDTH+24, LENGTH+WALLS*2], true);
  }
  translate([-WALLS/2, 0, 0])
    cube([THICKNESS+WALLS, WIDTH, LENGTH*2], true);
  for(y=[WIDTH/2+7, -WIDTH/2-7]) {
    translate([-THICKNESS, y, 0])
    rotate([0, 90, 0])
      # cylinder(h=10,r=2.5);
  }
}
