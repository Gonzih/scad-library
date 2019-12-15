$fn=100;

difference() {
  import("stl/CableHolder_FIX.STL");
  for( y=[7, 27] ) {
    translate([16, y, -1])
    # cylinder(h=10, r=2);
  }
}
