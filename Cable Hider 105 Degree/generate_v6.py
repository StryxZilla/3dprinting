#!/usr/bin/env python3
"""Generate V6: shorten the solid section of the right arm by 2 mm.

All vertices on the right-hand end move together, retaining the
17.8 mm cutout and the 105 degree bend.
"""
import math
import struct
from pathlib import Path

here = Path(__file__).resolve().parent
source = here / "bend_105_extended_arm_v5.stl"
target = here / "bend_105_extended_arm_v6.stl"
data = bytearray(source.read_bytes())
triangles = struct.unpack_from("<I", data, 80)[0]
assert len(data) == 84 + triangles * 50, "Expected binary STL"
changed = 0
for i in range(triangles):
    offset = 84 + 50 * i
    points = []
    for j in range(3):
        pos = offset + 12 + j * 12
        x, y, z = struct.unpack_from("<fff", data, pos)
        if y > 151.5:
            y -= 1.6
            z += 1.2
            changed += 1
        points.append((x, y, z))
        struct.pack_into("<fff", data, pos, x, y, z)
    a, b, c = points
    u = (b[0] - a[0], b[1] - a[1], b[2] - a[2])
    v = (c[0] - a[0], c[1] - a[1], c[2] - a[2])
    n = (u[1]*v[2]-u[2]*v[1],
         u[2]*v[0]-u[0]*v[2],
         u[0]*v[1]-u[1]*v[0])
    length = math.sqrt(sum(q*q for q in n)) or 1
    struct.pack_into("<fff", data, offset, *(q/length for q in n))
assert changed == 911, f"Unexpected count of shifted triangle corners: {changed}"
data[:80] = b"105 deg cable hider elbow V6 - shortened arm 2mm".ljust(80, b" ")
target.write_bytes(data)
print(f"Generated {target.name}: {triangles} triangles, {len(data)} bytes")
