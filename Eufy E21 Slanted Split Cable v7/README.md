Eufy E21 slanted split wall mount - V7 CABLE CHANNEL - TEST FIT FIRST

Design change from V6:
- Added 6.5 mm wide x 3.0 mm deep full-length wall-facing cable channel
  along the centerline between left and right wall screws.
- Moved the two seam alignment sockets upwards inside the wedge, to
  prevent the cable channel from intersecting the socket/keys.
- Retained the two original latching hooks, the 25-degree face angle,
  the 6mm-slimmed wedge, per-half wall-normal countersunk screws,
  and upper screwdriver access notch.
- Each half has one screw and is independently secured to wall.

Print:
- Use E21_SLANTED_SPLIT_CABLE_ALL.stl to print both halves and both keys.
- All pieces are pre-oriented, each half resting on its flat cut face.
- PETG, 0.16-0.2 mm layer, 5-6 perimeters, ~35-40% infill, 6-8 mm brim.
- Inspect brim/supports and check both hooks for proper locking motion.

Assembly:
- Test fit keys in relocated sockets, assemble both halves on a flat surface.
- Route the cable in the wall-side groove between the two screws.
- Use both wall screws, countersunk heads flush/below the access seats.
- A 3.0 mm deep groove only fully hides cables with thickness <= 3 mm.
  Measure your cable and increase cable_channel_depth in SCAD if needed,
  taking care not to penetrate the thin end of the angled face.
- Mount away from the crib and ensure camera/cable remain out of child's reach.
  No mechanical retention, heat, or strength validation has been performed.

Edit:
- Open e21_split_cable_v7.scad with OpenSCAD.
- Its imports must remain alongside original_mount.stl and
  v5_slim_6mm_wedge.stl in the same directory.
- Set part='left_print'/'right_print'/'keys_print' or other selector;
  render with F6 then export STL.