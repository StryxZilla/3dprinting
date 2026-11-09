# Eufy E21 — 25° slanted wall mount, two-piece V6

This is the **angled** E21 camera wall mount, not the flat plate. The mounting wedge is split between its two original retaining hooks, with two alignment keys. Print halves with their split (cut) faces on the build plate to improve hook layer orientation.

## Files
- [E21_SLANTED_SPLIT_ALL.stl](E21_SLANTED_SPLIT_ALL.stl) — all 4 parts arranged for Bambu Studio
- [E21_SLANTED_LEFT.stl](E21_SLANTED_LEFT.stl) and [E21_SLANTED_RIGHT.stl](E21_SLANTED_RIGHT.stl) — separated halves
- E21_ALIGNMENT_KEY_1.stl and E21_ALIGNMENT_KEY_2.stl — keys
- rebuild.py and mesh/ — verified source used to rebuild the printable STLs

**If the STL files are not visible yet:** the [Build Eufy E21 Slanted Split STL workflow](../../actions/workflows/build-eufy-e21-split.yml) generates them from the mesh source. It can also be run manually using **Run workflow**.

## Printing and assembly
- PETG; 0.16–0.2 mm layers; 5–6 walls; 35–45% gyroid infill; 6–8 mm brim.
- Do not rotate the assembled camera-facing surface onto the bed. Print the halves standing on the straight split faces.
- Dry filament. Keep support material off the functional retaining-hook surfaces.
- Insert both keys, join the halves, test the E21's push-on then sideways slide-to-lock motion, and secure each half to the wall using its own wall-normal countersunk screw.
- Screw spacing: 24 mm horizontally, relocated from the original model. The screw size and countersink are approximations and must be checked against actual screws.

**Important:** This design has not been physically load tested. The center seam creates a new structural joint; printing on end may improve hook strength but does not guarantee overall strength. Do not install an untested camera mount over a crib or where the camera or cord could reach a child.

The mesh archive is lossily quantized to 0.01 mm (coordinate error less than approximately 0.005 mm) while preserving all 4 parts and 4,352 triangular facets.
