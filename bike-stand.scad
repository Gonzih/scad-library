MM_IN_INCH = 25.4;
BEAM_WIDTH = 2*MM_IN_INCH;
BEAM_THICKNESS = 4*MM_IN_INCH;
WALL_HEIGHT = 2250;


module w2x4(length) {
  cube([BEAM_WIDTH, BEAM_THICKNESS, length], true);
}


module stand(height, stand_width, sep_distance) {
  union() {
    w2x4(height);
    translate([0, sep_distance , 0])
      w2x4(height);
    for (pos = [0, height/2-BEAM_THICKNESS/2]) {
      translate([0, sep_distance/2, pos])
        rotate([90, 0, 0])
          w2x4(sep_distance);
    }
  }
}

module wall_stand(height, stand_width, sep_distance) {
  union() {
    stand(height, stand_width, sep_distance);
    translate([0, sep_distance/2 , -height/2])
      rotate([90, 90, 0])
      w2x4(stand_width);
  }
}

module corner_stand(height, stand_width, sep_distance) {
  union() {
    stand(height, stand_width, sep_distance);
    translate([0, stand_width/2-BEAM_WIDTH , -height/2])
      rotate([90, 90, 0])
      w2x4(stand_width);
    # translate([stand_width/2-BEAM_WIDTH, 0 , -height/2])
      rotate([0, 90, 0])
      w2x4(stand_width);
  }
}

corner_stand(WALL_HEIGHT, 600, 2 * BEAM_THICKNESS);

translate([0, 1000, 0])
  wall_stand(WALL_HEIGHT, 700, 2 * BEAM_THICKNESS);
