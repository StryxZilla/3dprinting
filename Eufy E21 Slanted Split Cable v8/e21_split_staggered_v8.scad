// Eufy E21 angled mount V8, staggered screw + cable-channel two-half keyed split for printing on the seam face.
// Units: mm. Based on user's original hooks and V5 (6mm) 25-degree wedge.
// Part selectors via openscad -D 'part="left_assembled"' / 'right_assembled'
//   'left_print', 'right_print', 'keys_print', 'assembly', 'exploded'.
// The camera contact surface and both hook solids remain at the V5 6mm location
// except the small unavoidable center split and relocated screw apertures.
// IMPORTANT: Prototype, not certified for mounting over a crib.
$fn=88;
part="assembly";
// Screw centers: x0-12 at y=155, x0+12 at y=166; 11 mm stagger.
// Camera face and original latching hooks remain unchanged.
x0=190.986;
y0=151.5927;
face_angle=25;
v5_drop=6;
front_plane_z=22.141;
seam_half_gap=0.12;  // 0.24mm print-to-print clearance at the seam

// US #8 flat head wood screw approximated; verify against actual hardware.
screw_x_offset=12.0;
screw_y_left=155.0;
screw_y_right=166.0; // 11 mm vertical stagger improves resistance to twisting
screw_seat_z=7.1;
screw_shank_d=4.6;
screw_head_d=8.7;
screw_access_d=10.6;
countersink_angle=82;

// Keys go across the split under the camera-facing face.
// 4.2 mm nominal key, 4.6 mm square pocket, 18.5 mm key length.
key_y1=134.0; // repositioned to clear the new lower screw access bore
key_z1=7.0;
key_y2=145.0; // maintain separation from staggered screw channels
key_z2=10.0;
key_s=4.2;
socket_s=4.65;
key_length=18.5;
socket_depth=9.65; // total capacity 19.3 minus seam gap

module original_retaining_hooks() {
  translate([0,0,-v5_drop]) intersection(){
    import("original_mount.stl",convexity=12);
    union(){
      translate([163.5,140,0]) cube([12.8,16,60]);
      translate([205.8,140,0]) cube([12.8,16,60]);
    }
    translate([x0,y0,front_plane_z]) rotate([face_angle,0,0])
      translate([-90,-90,-0.8]) cube([180,180,60]);
  }
}
module original_v5_body_without_screws(){
  union(){
    import("v5_slim_6mm_wedge.stl",convexity=12);
    original_retaining_hooks();
  }
}
module screw_hole(x,y){
  // The shank axis and countersink are perpendicular to the wall, along Z.
  shaft_r=screw_shank_d/2;
  head_r=screw_head_d/2;
  sink_depth=(head_r-shaft_r)/tan(countersink_angle/2);
  translate([x,y,0]){
    translate([0,0,-1]) cylinder(d=screw_shank_d,h=screw_seat_z-sink_depth+1.02);
    translate([0,0,screw_seat_z-sink_depth])
      cylinder(h=sink_depth,d1=screw_shank_d,d2=screw_head_d);
    // Pointed roof in the print-up direction: the 10.6 mm horizontal
    // driver bore prints with far fewer unsupported ceiling strands.
    // The roof is toward the outer (clip) edge of each half.
    translate([0,0,screw_seat_z-0.01])
      linear_extrude(height=45)
        union(){
          circle(d=screw_access_d);
          polygon(points=[
            [(x<x0 ? -1 : 1)*1.5,-4.5],
            [(x<x0 ? -1 : 1)*6.2,0],
            [(x<x0 ? -1 : 1)*1.5,4.5]
          ]);
        }
  }
}
module central_driver_notch(){
  // Preserve the V5 access relief at the high edge of the circular face.
  translate([x0-13/2,168.5,9.6]) cube([13,40,60]);
}
// Wall-facing recessed cable channel between the two wall screws.
// Full-length slot from the thin to the thick perimeter; no exposed cut
// through the original 25-degree camera contact face.
cable_channel_width=6.5;   // fits narrow ~3mm power lead; confirm actual diameter
cable_channel_depth=3.0;   // preserves >1mm skin at the thin edge
module wall_cable_channel(){
  translate([0,0,-0.05])
    linear_extrude(height=cable_channel_depth+0.05)
      hull(){
        translate([x0,124.2]) circle(d=cable_channel_width);
        translate([x0,179.2]) circle(d=cable_channel_width);
      }
}
module full_mount(){
  difference(){
    original_v5_body_without_screws();
    screw_hole(x0-screw_x_offset,screw_y_left);
    screw_hole(x0+screw_x_offset,screw_y_right);
    central_driver_notch();
    wall_cable_channel();
  }
}
module square_socket(y,z,is_left){
  // blind, straight socket from split face into each side; mates with a printed key
  translate([is_left ? x0-socket_depth : x0-0.03, y-socket_s/2,z-socket_s/2])
    cube([socket_depth+0.03,socket_s,socket_s]);
}
module sockets(is_left){
  square_socket(key_y1,key_z1,is_left);
  square_socket(key_y2,key_z2,is_left);
}
module left_assembled(){
  difference(){
    intersection(){
      full_mount();
      translate([x0-60,100,-1]) cube([60-seam_half_gap,105,55]);
    }
    sockets(true);
  }
}
module right_assembled(){
  difference(){
    intersection(){
      full_mount();
      translate([x0+seam_half_gap,100,-1]) cube([60,105,55]);
    }
    sockets(false);
  }
}
module key_shape(){
  // Two chamfered ends, no snagging and a flat side for printing.
  // Length along X, centered around zero.
  union(){
    cube([key_length-1.6,key_s,key_s],center=true);
    hull(){
      translate([key_length/2-0.8,0,0]) cube([0.02,key_s,key_s],center=true);
      translate([key_length/2-0.04,0,0]) cube([0.06,key_s-1.1,key_s-1.1],center=true);
    }
    hull(){
      translate([-key_length/2+0.8,0,0]) cube([0.02,key_s,key_s],center=true);
      translate([-key_length/2+0.04,0,0]) cube([0.06,key_s-1.1,key_s-1.1],center=true);
    }
  }
}
module keys_assembled(){
  translate([x0,key_y1,key_z1]) key_shape();
  translate([x0,key_y2,key_z2]) key_shape();
}
// Flip each half around the wall-normal/side axes such that its planar cut face is on the bed.
// Right: world X>center -> positive printing Z. Left: world X<center -> positive printing Z.
module left_print(){
  translate([38,0,x0-seam_half_gap]) rotate([0,90,0]) left_assembled(); // z'= -x + x0
}
module right_print(){
  translate([-38,0,-x0-seam_half_gap]) rotate([0,-90,0]) right_assembled(); // z'= +x - x0
}
module keys_print(){
  translate([0,137,key_s/2]) key_shape();
  translate([0,156,key_s/2]) key_shape();
}
module exploded(){
  color([0.2,0.65,0.9]) translate([-2.8,0,0]) left_assembled();
  color([0.94,0.72,0.25]) translate([2.8,0,0]) right_assembled();
  color([0.35,0.9,0.5]) keys_assembled();
}
if(part=="left_assembled") left_assembled();
else if(part=="right_assembled") right_assembled();
else if(part=="left_print") left_print();
else if(part=="right_print") right_print();
else if(part=="keys_print") keys_print();
else if(part=="keys_assembled") keys_assembled();
else if(part=="assembly"){
  color([0.2,0.65,0.9]) left_assembled();
  color([0.94,0.72,0.25]) right_assembled();
  color([0.35,0.9,0.5]) keys_assembled();
}
else if(part=="exploded") exploded();