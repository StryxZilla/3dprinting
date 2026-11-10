// Eufy E21 compact 90 degree inside-corner wedge V11.
// Conceptual printable PROTOTYPE: original E21 latching hooks and original V5 contact-surface shape are retained.
// Coordinate convention: x left/right, y wall vertical, z outward into the room.
// Wall planes: z=abs(x). Corner vertical line: x=0,z=0.
// Camera-facing plane: z = face_center_depth + tan(25)*y.
// Material: PETG; two side halves held together by two cross-clamping wall screws; NO alignment keys.
// Requires "original_mount.stl", "v5_slim_6mm_wedge.stl" in this directory.
$fn=96;
part="assembly";
legacy_center_x=190.986;
legacy_center_y=151.5927;
legacy_face_z=16.141; // original V5 6 mm lowered face reference (22.141-6)
face_angle=25;
face_center_depth=35.0; // 35 mm at center; minimum V-to-face material ~3mm near diagonal rim
plate_radius=28.65;
plate_y_radius=plate_radius*cos(face_angle);
cap_thickness=2.9; // original exact-mating face cap cut from V5; wedge supports from underneath
seam_clearance=0.12; // 0.24 mm total clearance across both halves

// Four wall screws total: two ordinary low anchors, two crossed upper anchors.
// Cross-screw shaft and countersink are continuous across the center split.
 // The cross screw heads seat in the OPPOSITE printed half. Head seats are ~24mm
 // from wall, so these require longer screws than the V10 original.
screw_shank_d=4.2;
screw_head_d=8.1;
screw_access_d=9.2;
screw_sink_angle=82;
head_other_half_x=7.2; // distance from split to a complete head seat in the opposite half
// Arrays below hold [vertical_y, distance_from_corner_on_wall].
left_direct=[-17.0,17.0];
right_direct=[-7.0,20.0];
left_cross=[10.0,10.0];
right_cross=[19.0,10.0];
screw_seat_dist=6.0;

// Center wire channel along the inside corner, open top and bottom.
wire_width=7.0;
wire_recess=7.0; // depth from the rear corner apex, >5mm wide cable relief

// No alignment pins, keyed sockets, or mechanical joints.
// The two cross-clamping wall screws register and fasten both halves after installation.

// Slicer part selections: left, right, left_print, right_print, print_all, assembly, exploded, core.

module legacy_hook_mesh(){
  // Existing full-strength cam-lock lips extracted from original user's angled STL.
  translate([-legacy_center_x,-legacy_center_y,face_center_depth-legacy_face_z])
    translate([0,0,-6])
      intersection(){
        import("original_mount.stl",convexity=15);
        union(){
          translate([163.5,140,0]) cube([12.8,16,60]);
          translate([205.8,140,0]) cube([12.8,16,60]);
        }
        translate([legacy_center_x,legacy_center_y,22.141]) rotate([face_angle,0,0])
          translate([-90,-90,-0.8]) cube([180,180,60]);
      }
}
module legacy_contact_cap(){
  // Exact original round mounting contact profile, NOT a guessed new clip interface.
  translate([-legacy_center_x,-legacy_center_y,face_center_depth-legacy_face_z])
    intersection(){
      import("v5_slim_6mm_wedge.stl",convexity=15);
      translate([legacy_center_x,legacy_center_y,legacy_face_z]) rotate([face_angle,0,0])
        translate([-80,-80,-cap_thickness]) cube([160,160,cap_thickness+0.03]);
    }
}
module circular_projected_prism(){
  translate([0,0,-0.01]) linear_extrude(height=72)
    scale([1,cos(face_angle),1]) circle(r=plate_radius);
}
module wall_v_support_region(){
  // Solid above (toward room) both planes of a 90-degree inside corner.
  rotate([90,0,0]) linear_extrude(height=80,center=true)
    polygon(points=[[-40,40],[0,0],[40,40],[40,70],[-40,70]]);
}
module below_angled_face(){
  translate([0,0,face_center_depth]) rotate([face_angle,0,0])
    translate([-75,-75,-80]) cube([150,150,80.05]);
}
module corner_wedge(){
  intersection(){
    circular_projected_prism();
    wall_v_support_region();
    below_angled_face();
  }
}
module cable_channel(){
  // Recessed along the apex of the 90-degree corner, from bottom to top.
  translate([-wire_width/2,-36,-0.1]) cube([wire_width,72,wire_recess+0.1]);
}
module wall_screw_cutter(side,ypos,wall_x,crosses_joint=false){
  // side -1 left wall, +1 right wall.
  // Axis inward normal to wall, which points toward the opposite printed half.
  p=[side*wall_x,ypos,wall_x];
  sink_depth=((screw_head_d-screw_shank_d)/2)/tan(screw_sink_angle/2);
  // For crossing screws seat the head 7.2 mm into the OTHER half.
  // For ordinary screws seat 6mm from the wall in the same half.
  seat_dist=crosses_joint ? sqrt(2)*(wall_x+head_other_half_x) : screw_seat_dist;
  translate(p) rotate([0,-side*45,0]){
    translate([0,0,-1.8]) cylinder(d=screw_shank_d,h=seat_dist+1.82);
    translate([0,0,seat_dist-0.02])
      cylinder(h=sink_depth+0.04,d1=screw_shank_d,d2=screw_head_d);
    translate([0,0,seat_dist+sink_depth])
      cylinder(d=screw_access_d,h=76);
  }
}
module full_model(){
  difference(){
    union(){corner_wedge(); legacy_contact_cap(); legacy_hook_mesh();}
    cable_channel();
    wall_screw_cutter(-1,left_direct[0],left_direct[1],false);
    wall_screw_cutter(1,right_direct[0],right_direct[1],false);
    wall_screw_cutter(-1,left_cross[0],left_cross[1],true);
    wall_screw_cutter(1,right_cross[0],right_cross[1],true);
  }
}
module half_model(is_left){
  intersection(){
    import("V11_full_master.stl",convexity=20);
    if(is_left) translate([-50,-42,-1]) cube([50-seam_clearance,84,75]);
    else translate([seam_clearance,-42,-1]) cube([50,84,75]);
  }
}
module left_print(){
  // rotation maps split plane to bed and entire left body to positive print Z
  translate([-55,0,-seam_clearance]) rotate([0,90,0]) half_model(true);
}
module right_print(){
  translate([55,0,-seam_clearance]) rotate([0,-90,0]) half_model(false);
}
module full_print(){left_print();right_print();}
module exploded(){
  color([0.2,0.64,0.85]) translate([-3.4,0,0]) half_model(true);
  color([0.95,0.70,0.26]) translate([3.4,0,0]) half_model(false);
}
if(part=="left") half_model(true);
else if(part=="right") half_model(false);
else if(part=="left_print") left_print();
else if(part=="right_print") right_print();
else if(part=="print_all") full_print();
else if(part=="full") full_model();
else if(part=="core") corner_wedge();
else if(part=="exploded") exploded();
else {
  color([0.2,0.64,0.85]) half_model(true);
  color([0.95,0.70,0.26]) half_model(false);
}