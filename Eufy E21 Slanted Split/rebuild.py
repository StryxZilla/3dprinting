"""Rebuild the Eufy E21 V6 slanted split mount STL from compact mesh data.

Only Python standard library needed. Model vertices are stored to 0.01 mm
precision, so reconstructed coordinates deviate less than ~0.005 mm.
"""
from pathlib import Path
import base64
import hashlib
import lzma
import math
import struct

ROOT = Path(__file__).resolve().parent
EXPECTED_RAW_SHA256 = '44eb630f40a4faa1f898acb483014888044a9f55264b155795390a449de00880'


def write_stl(path, triangles, vertices):
    with path.open('wb') as f:
        f.write(b'Eufy E21 slanted 25-degree split V6'.ljust(80, b' '))
        f.write(struct.pack('<I', len(triangles)))
        for i, j, k in triangles:
            a, b, c = vertices[i], vertices[j], vertices[k]
            ab = tuple(b[t] - a[t] for t in range(3))
            ac = tuple(c[t] - a[t] for t in range(3))
            normal = (ab[1]*ac[2]-ab[2]*ac[1],
                      ab[2]*ac[0]-ab[0]*ac[2],
                      ab[0]*ac[1]-ab[1]*ac[0])
            length = math.sqrt(sum(q*q for q in normal)) or 1.0
            normal = tuple(q / length for q in normal)
            f.write(struct.pack('<12fH', *(normal + a + b + c), 0))
    print(f'{path.name}: {len(triangles)} triangles, {path.stat().st_size:,} bytes')


def main():
    parts = sorted((ROOT / 'mesh').glob('part_*.txt'))
    assert len(parts) == 6, 'Expected six packed mesh text parts'
    encoded = ''.join(p.read_text().strip() for p in parts)
    assert len(encoded) == 22088, 'Packed text size mismatch'
    raw = lzma.decompress(base64.b64decode(encoded, validate=True))
    assert hashlib.sha256(raw).hexdigest() == EXPECTED_RAW_SHA256, 'Mesh checksum mismatch'
    nv, nf, x0, y0, z0 = struct.unpack_from('<II3f', raw, 0)
    assert len(raw) == 20 + nv*6 + nf*6
    vertices = [tuple(v / 100.0 + o for v, o in zip(vals, (x0, y0, z0)))
                for vals in struct.iter_unpack('<3H', raw[20:20 + nv*6])]
    triangles = list(struct.iter_unpack('<3H', raw[20+nv*6:]))
    write_stl(ROOT / 'E21_SLANTED_SPLIT_ALL.stl', triangles, vertices)

    vertex_to_tri = [[] for _ in vertices]
    for tid, face in enumerate(triangles):
        for vi in face:
            vertex_to_tri[vi].append(tid)
    remaining = set(range(len(triangles)))
    components = []
    while remaining:
        seed = remaining.pop()
        group = [seed]
        stack = [seed]
        while stack:
            t = stack.pop()
            for vi in triangles[t]:
                for neighbor in vertex_to_tri[vi]:
                    if neighbor in remaining:
                        remaining.remove(neighbor)
                        group.append(neighbor)
                        stack.append(neighbor)
        components.append(group)
    assert len(components) == 4, f'Expected 4 mesh parts, got {len(components)}'
    components.sort(key=len, reverse=True)
    main_halves = components[:2]
    main_halves.sort(key=lambda group: sum(vertices[triangles[i][0]][0] for i in group)/len(group))
    for name, group in zip(('LEFT', 'RIGHT'), main_halves):
        write_stl(ROOT / f'E21_SLANTED_{name}.stl', [triangles[i] for i in group], vertices)
    for index, group in enumerate(components[2:], start=1):
        write_stl(ROOT / f'E21_ALIGNMENT_KEY_{index}.stl', [triangles[i] for i in group], vertices)
    print('Verified mesh checksum and all four component exports.')


if __name__ == '__main__':
    main()
