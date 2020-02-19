WALLS=3;
WIDTH=10;

linear_extrude(height=WIDTH, center=true, twist=0)
union() {
  square([40,WALLS]);
  translate([0, 0, 0])
    rotate([0, 0, 90])
    square([55,WALLS]);
  translate([-60, 55, 0])
    square([60,WALLS]);
  translate([-65.75, 49.27, 0])
    rotate([0, 0, 40])
      square([10,WALLS]);
  translate([-15.5, 55.5, 0])
    rotate([0, 0, -45])
      square([18,WALLS]);
}
