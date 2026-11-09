# Eufy E21 slanted two-piece wall mount — V8 staggered screws + cable channel

## What's new vs V7
- Wall-normal countersunk screw holes are now vertically staggered by 11.0 mm, while remaining 24.0 mm apart horizontally.
- Screw centers (assembled CAD coordinates, mm): LEFT = (178.986, 155.0); RIGHT = (202.986, 166.0).
- The 6.5 mm wide by 3.0 mm deep cable channel continues down the centerline on the wall-facing side between the screws.
- Alignment key locations moved to Y=134.0 mm and Y=145.0 mm to avoid the new screw-access bores.
- Original 25 degree sloped camera face and hook/retaining tab geometry are unchanged.
- The V5 slim 6 mm drop, wall-contact footprint, and center screwdriver notch are retained.

## Printing
Import E21_SLANTED_STAGGERED_CABLE_V8_PRINT_ALL.stl into Bambu Studio. The two halves are pre-oriented on their split faces with each original hook laid along the layer plane; two keys are also included.
Recommended starting parameters: PETG, 0.16 mm layers, 6 wall perimeters, 35-40% gyroid, 6-8 mm brim. Review supports/bridging in the slicer.

## Assembly and fit checks
The keyed halves form an alignment joint but each half uses its own wall screw. Check the wall-screw length and head fit (82 degree countersinks sized for nominal #8 flat-head wood screws). Use proper anchors for the wall material. Test screw-driver access, cable thickness and routing, hook slide-to-lock engagement, and resistance to pulling and twisting before actual installation.

This is a prototype, not tested or certified as a load-bearing mount. Never place camera or power cable where they could fall into a crib or be reached by a child.

## Editing and rebuilding
Keep `e21_split_staggered_v8.scad`, `original_mount.stl`, and `v5_slim_6mm_wedge.stl` together. In OpenSCAD, set `part` to left_print, right_print, keys_print, assembly, or exploded, render F6 and export STL.