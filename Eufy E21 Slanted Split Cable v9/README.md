# Eufy E21 slanted two-piece wall mount — V9 lower screw

V9 is based on the user's V8 two-piece Eufy E21 angled mount with a centered wall-side cable channel. It relocates the **lower/left wall screw 6 mm lower and 4 mm toward the center** to protect the retaining hook from being cut by the screwdriver access bore. The upper/right screw remains where it was.

## Screw centers (assembled CAD XY coordinates in millimeters)

| | V8 | V9 |
|---|---|---|
| Lower/left | (178.986, 155.0) | **(182.986, 149.0)** |
| Upper/right | (202.986, 166.0) | **(202.986, 166.0)** |
| Vertical separation | 11 mm | **17 mm** |
| Horizontal separation | 24 mm | **20 mm** |
| Center-to-center distance | 26.4 mm | **26.2 mm** |

The lower hole was moved inward as well as downward because shifting it down at the original X coordinate would cut into the original left retaining hook. An OpenSCAD solid intersection check verified no overlap between either V9 screw bore and the original hook geometry, alignment key sockets, or cable-channel cut.

## Features retained

- Original retaining-hook geometry; 25° angled camera-contact surface; V5 6 mm slimmed-down wedge.
- Split between the hooks, so each half can be printed on its straight split face.
- One wall-normal screw hole per half with nominal 4.6 mm shank clearance and 82° countersunk seat, plus driver access bores.
- 6.5 mm wide x 3.0 mm deep recessed wall-side cable channel centered between the two screws. Check the actual cable size.
- Two printed alignment keys. For V9 the second socket is at Y=158 mm to clear the relocated lower bore.

## Printing and assembly

Import `E21_SLANTED_SPLIT_CABLE_V9_PRINT_ALL.stl` into Bambu Studio. The four solids (left half, right half, two keys) are pre-oriented with split faces down. Starting settings: PETG, 0.16 mm layers, six walls, 35–40% gyroid infill, 6–8 mm brim. Check support requirements and thin walls in the slicer.

Install the keys, join the halves, and fasten both with appropriately sized countersunk screws and wall anchors. Before use, confirm screw head fit, driver access, cable clearance, the full E21 push-and-slide locking motion, and retention under pulling and twisting. This is an untested prototype, not load-rated. Keep the camera and cable outside the crib and out of the child's reach.

## Editable source

The OpenSCAD file `e21_split_staggered_v9.scad` imports `original_mount.stl` and `v5_slim_6mm_wedge.stl`. These files must remain together. Set the `part` selector in the SCAD to `left_print`, `right_print`, `keys_print`, `assembly`, or `exploded`, render, and export the STLs. `build.py` validates and packs the pieces after OpenSCAD exports.