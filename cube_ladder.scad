wall_thickness = 3;
INIT_SIZE=35;

module cube_edges(size, rotation) {
  d1 = size - wall_thickness*2;
  d2 = size + wall_thickness;

  rotate([0,0,rotation])
  difference() {
    cube([size, size, size], true);
    cube([d2, d1, d1], true);
    cube([d1, d2, d1], true);
    cube([d1, d1, d2], true);
  }
}


union()
for (i = [0: 5: INIT_SIZE]) {
  cube_edges(INIT_SIZE - i/2+1, i);
}
