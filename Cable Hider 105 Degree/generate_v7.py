#!/usr/bin/env python3
"""Generate V7 from V6: increase the cable-hider profile depth by 2 mm.

Expand radially through the curved elbow and perpendicular to each straight
arm. This preserves the 105-degree angle, 18.1 mm X width, arm lengths,
and 17.8 mm rectangular opening.
"""
import math
import struct
from pathlib import Path

here = Path(__file__).resolve().parent
source = here / "bend_105_extended_arm_v6.stl"
target = here / "bend_105_depth_plus_2_v7.stl"

center_y, center_z = 144.249776, 12.296970
right_tangent = (0.793354, -0.608761)
left_tangent = (-0.793354, -0.608761)
right_normal = (-0.608761, -0.793354)
left_normal = (0.608761, -0.793354)
old_outer_depth = 8.944
factor = (old_outer_depth + 2.0) / old_outer_depth

data = bytearray(source.read_bytes())
count = struct.unpack_from("<I", data, 80)[0]
assert len(data) == 84 + 50 * count, "Expected binary STL"


def adjusted(y, z):
    dy, dz = y - center_y, z - center_z
    ql = dy * left_tangent[0] + dz * left_tangent[1]
    qr = dy * right_tangent[0] + dz * right_tangent[1]
    if ql > qr and ql > 0:
        n = left_normal
    elif qr > 0:
        n = right_normal
    else:
        return center_y + factor * dy, center_z + factor * dz
    perpendicular = dy * n[0] + dz * n[1]
    return (y + (factor - 1) * perpendicular * n[0],
            z + (factor - 1) * perpendicular * n[1])


for i in range(count):
    offset = 84 + 50 * i
    pts = []
    for j in range(3):
        po = offset + 12 + 12 * j
        x, y, z = struct.unpack_from("<fff", data, po)
        yy, zz = adjusted(y, z)
        pts.append((x, yy, zz))
        struct.pack_into("<fff", data, po, x, yy, zz)
    a, b, c = pts
    u = tuple(b[k] - a[k] for k in range(3))
    v = tuple(c[k] - a[k] for k in range(3))
    n = (u[1]*v[2]-u[2]*v[1], u[2]*v[0]-u[0]*v[2], u[0]*v[1]-u[1]*v[0])
    norm = math.sqrt(sum(t*t for t in n)) or 1
    struct.pack_into("<fff", data, offset, *(t/norm for t in n))

data[:80] = b"105 deg cable hider V7 - 2mm deeper profile".ljust(80, b" ")
target.write_bytes(data)
print(f"Generated {target.name}, {count} triangles, {len(data)} bytes")
