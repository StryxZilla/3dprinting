# Eufy E21 compact 90-degree corner wedge — V11 (screw-bridged)

## Changes from V10

- Eliminates the two loose alignment keys and their sockets.
- Two *cross-clamping* wall screws pass through both printed halves before entering their corresponding walls. Their flat heads seat within the opposite printed half, so they clamp the joint together when tightened.
- Retains two conventional short wall screws (one per wall), for four wall screws in total.
- Retains the original E21 slide-in retaining hook solids, 25° fixed camera-face tilt, 90° corner wedge, and central 7 mm cable relief.
- Two separately printable halves, each with one retaining hook. The STL is oriented on the split faces for better clip layer alignment.

## IMPORTANT limitations

The camera fit, mount strength, and screw engagement have NOT been physically tested. A watertight mesh is not proof of structural adequacy. Wall corners can be out of square; check wall anchors and actual screw head sizing. This model is a *prototype* and is not suitable for placing a camera where it could fall into a crib or within reach of a child until independently validated. Secure the power cable well outside a child's reach.

The two cross-clamping screws run approximately **24 mm through plastic**, compared with approximately **6 mm** for the two direct wall screws. Screws approximately **50–55 mm long** may be needed for the cross-clamping passages (depending on anchor embedment); this is only an estimate. The short passages may use approximately **30–40 mm** screws. The CAD shaft clearance is 4.2 mm, nominal countersunk head diameter 8.1 mm, 82° countersink; **measure your actual screws and anchors before selecting hardware**. A slim/long driver bit extension will be needed for the angled access bores. Do not let a screw bottom out in an anchor before clamping the parts.

**Assembly:** Temporarily hold the two halves in alignment; test that the camera fully pushes onto the hooks and slides to its locked position. Check the joint and screw passages with actual hardware before drilling the wall. Pre-drill/anchor both walls appropriately, install all four screws loosely, then tighten uniformly while ensuring the camera interface stays aligned. Confirm the mount cannot rock or separate before attaching the camera.

**Printing:** PETG recommended, about 0.16 mm layers, six walls, 35–40% gyroid infill, 6–8 mm brim. Print each half on its split face. Check any supports near retaining hooks/driver passages in the slicer.

## Files
- `E21_Corner_Wedge_V11_PRINT_ALL.stl` — print-ready two-part layout, each half on its flat cut face.
- `E21_Corner_Wedge_V11_LEFT.stl`, `E21_Corner_Wedge_V11_RIGHT.stl` — individual halves, assembled-space orientation.
- `E21_Corner_Wedge_V11.scad` — editable OpenSCAD model.
- `V11_full_master.stl` and original source meshes — geometry dependencies for regeneration.
- `E21_Corner_Wedge_V11_Preview.png` — four CAD views.

To regenerate, place the SCAD and three imported meshes in one folder. Use `openscad -o ... -D 'part="full"' E21_Corner_Wedge_V11.scad` to regenerate `V11_full_master.stl` before exporting the print parts.