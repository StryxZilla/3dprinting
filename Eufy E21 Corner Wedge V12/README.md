# Eufy E21 corner wedge V12 — flat 0° camera-face tilt

A compact, static, two-piece, printable wedge for a 90° *inside wall corner*, with the Eufy E21 mount interface facing straight out from the corner. Unlike V11, the camera-facing surface has **0° built-in downward tilt**. The horizontal direction remains 45° relative to each wall.

## Preserved V11 features
- Two separately printable halves; no alignment pins.
- Original E21 slide-in hook interface (rigidly counter-rotated together with the original mating plate).
- Four wall-normal countersunk screw passages (two per wall); two pass through both halves to clamp the seam. Same positions as V11.
- Recessed center cable channel (approximately 7 mm wide).
- Approximately 57.3 mm circular front, 35 mm from inside corner apex to center of face.

## Hardware and printing
Nominal bore: 4.2 mm, countersink head 8.1 mm, 82°. Cross-clamping screw seats are approximately 24 mm from the wall; these require longer screws than the approximately 6 mm direct passages. Actual screw lengths, wall anchors, and driver-bit clearance require physical verification.

Suggested PETG, 0.16–0.20 mm layers, six walls, 35–40% gyroid infill, 6–8 mm brim. Print each half on its flat center-split face. Inspect supports around the latch hooks and driver passages.

## Files
- E21_Corner_Wedge_V12_PRINT_ALL.stl: both halves in printing orientation.
- E21_Corner_Wedge_V12_LEFT.stl / RIGHT.stl: individual halves in assembled coordinates.
- E21_Corner_Wedge_V12.scad: editable construction; imports donor meshes extracted from V11 archive.
- V12_full_master.stl: intermediate mesh used to make the halves.
- E21_Corner_Wedge_V12_Package.zip: complete set with donor STL meshes.

Regenerate master: `openscad -q --export-format binstl -o V12_full_master.stl -D 'part="full"' E21_Corner_Wedge_V12.scad`, then build separate parts with `part="left"`, `"right"`, or `"print_all"`.

**Safety:** This is an untested prototype. Watertight geometry is not a proof of structural strength, clip retention, or wall-mounting safety. Test fit, assembly, locking security, and anchors before use; keep the camera and cord out of a baby's reach and do not put the mount where it could fall into a crib.
