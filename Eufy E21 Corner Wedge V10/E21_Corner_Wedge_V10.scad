// Eufy E21 compact 90 degree inside-corner wedge V10.
// Conceptual printable PROTOTYPE: original E21 latching hooks and original V5 contact-surface shape are retained.
// Coordinate convention: x left/right, y wall vertical, z outward into the room.
// Wall planes: z=abs(x). Corner vertical line: x=0,z=0.
// Camera-facing plane: z = face_center_depth + tan(25)*y.
// Material: PETG; assembled from two side halves on their split faces and separate locating keys.
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
seam_clearance=0.20; // total 0.40mm clearance across both halves

// Four screws, 2 per wall, normal to its wall (45 degrees to the camera direction).
// #6 / small #8 flat head screw dimensions are provisional; measure selected screws.
// Each hole may have a different distance from the inside corner, to avoid
// overlapping tool access pockets in the 56.6mm camera interface.
screw_shank_d=4.2;
screw_head_d=8.1;
screw_access_d=9.2;
screw_seat_dist=6.0; // distance from wall surface into the mount
screw_sink_angle=82;
// lower/upper pair on each wall, slightly staggered (left vs right) for clearance
left_holes=[[-17.0,17.0],[2.0,22.0]];    // [vertical y, wall anchor |x|]
right_holes=[[-7.0,20.0],[12.0,22.0]];

// Center wire channel along the inside corner, open top and bottom.
wire_width=7.0;
wire_recess=7.0; // depth from the rear corner apex, >5mm wide cable relief

// Printable keys: seats on each side of center seam beyond cable channel.
key_nominal=3.8;
key_socket=4.25;
key_length=16.4;
key_socket_depth=8.6;
key_locations=[[-12.0,14.0],[11.0,15.5]]; // [y,z] in assembly coordinates

// Slicer part selections: left, right, key, keys_print, left_print, right_print, print_all, assembly, exploded, core.

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
module wall_screw_cutter(side,ypos,wall_x){
  // side -1 left wall, +1 right wall. inward wall normal toward room: (-side,0,+1)/sqrt(2)
  // Wall contact point x=+-19,z=19; shaft axis normal to wall.
  n=[-side/sqrt(2),0,1/sqrt(2)];
  p=[side*wall_x,ypos,wall_x];
  sink_depth=((screw_head_d-screw_shank_d)/2)/tan(screw_sink_angle/2);
  // rotation maps local +Z onto n
  translate(p) rotate([0,-side*45,0]){
    // shaft through to the wall
    translate([0,0,-1.8]) cylinder(d=screw_shank_d,h=screw_seat_dist+1.81);
    // countersunk head cone with 82 degree included angle
    translate([0,0,screw_seat_dist-0.03])
      cylinder(h=sink_depth+0.06,d1=screw_shank_d,d2=screw_head_d);
    // recess all the way to the camera-facing surface for bit extension access
    translate([0,0,screw_seat_dist+sink_depth])
      cylinder(d=screw_access_d,h=75);
  }
}
module full_model(){
  difference(){
    union(){corner_wedge(); legacy_contact_cap(); legacy_hook_mesh();}
    cable_channel();
    for(yx=left_holes) wall_screw_cutter(-1,yx[0],yx[1]);
    for(yx=right_holes) wall_screw_cutter(1,yx[0],yx[1]);
  }
}
module socket(y,z,is_left){
  translate([is_left ? -key_socket_depth-0.015 : -0.015, y-key_socket/2,z-key_socket/2])
    cube([key_socket_depth+0.03,key_socket,key_socket]);
}
module half_model(is_left){
  difference(){
    intersection(){
      import("V10_full_master.stl",convexity=20);
      if(is_left) translate([-50,-42,-1]) cube([50-seam_clearance,84,75]);
      else translate([seam_clearance,-42,-1]) cube([50,84,75]);
    }
    for(yz=key_locations) socket(yz[0],yz[1],is_left);
  }
}
module alignment_key(){
  cube([key_length,key_nominal,key_nominal],center=true);
}
module keys_assy(){
  for(yz=key_locations) translate([0,yz[0],yz[1]]) alignment_key();
}
module left_print(){
  // rotation maps split plane to bed and entire left body to positive print Z
  translate([-55,0,-seam_clearance]) rotate([0,90,0]) half_model(true);
}
module right_print(){
  translate([55,0,-seam_clearance]) rotate([0,-90,0]) half_model(false);
}
module keys_print(){
  for(i=[0:len(key_locations)-1])
    translate([0,-39+i*78,key_nominal/2]) alignment_key();
}
module full_print(){left_print();right_print();keys_print();}
module exploded(){
  color([0.23,0.67,0.88]) translate([-3.4,0,0]) half_model(true);
  color([0.98,0.72,0.27]) translate([3.4,0,0]) half_model(false);
  color([0.35,0.83,0.55]) keys_assy();
}
if(part=="left") half_model(true);
else if(part=="right") half_model(false);
else if(part=="left_print") left_print();
else if(part=="right_print") right_print();
else if(part=="keys_print") keys_print();
else if(part=="keys_assembled") keys_assy();
else if(part=="print_all") full_print();
else if(part=="full") full_model();
else if(part=="core") corner_wedge();
else if(part=="exploded") exploded();
else {
  color([0.23,0.67,0.88]) half_model(true);
  color([0.98,0.72,0.27]) half_model(false);
  color([0.35,0.83,0.55]) keys_assy();
}