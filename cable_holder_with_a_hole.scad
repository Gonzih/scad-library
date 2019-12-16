$fn=100;

module bolt_hole() {
  union() {
    cylinder(h=6, r=2);
    translate([0, 0, 6])
      cylinder(h=2, r1=2, r2=3);
    translate([0, 0, 8])
      cylinder(h=3, r=3);
  }
}

difference() {
  import("stl/CableHolder_FIX.STL");
  for( y=[7, 27] ) {
    translate([16, y, -3])
    # bolt_hole();
  }
}
