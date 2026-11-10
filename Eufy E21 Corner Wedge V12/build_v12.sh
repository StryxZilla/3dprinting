name: Build Eufy E21 Corner Wedge V12

on:
  push:
    paths:
      - 'Eufy E21 Corner Wedge V12/E21_Corner_Wedge_V12.scad'
      - '.github/workflows/build-e21-corner-v12.yml'
  workflow_dispatch:

permissions:
  contents: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          persist-credentials: true
      - name: Install OpenSCAD
        run: |
          sudo apt-get update -qq
          sudo apt-get install -y --no-install-recommends openscad unzip zip
      - name: Build V12 binary STL files
        shell: bash
        run: |
          set -euo pipefail
          BASE='Eufy E21 Corner Wedge V12'
          V11='Eufy E21 Corner Wedge V11/E21_Corner_Wedge_V11_Package.zip'
          unzip -oq -j "$V11" original_mount.stl v5_slim_6mm_wedge.stl -d "$BASE"
          cd "$BASE"
          openscad -q --export-format binstl -o V12_full_master.stl -D 'part="full"' E21_Corner_Wedge_V12.scad
          for p in left right print_all; do
            case "$p" in left) suffix=LEFT;; right) suffix=RIGHT;; print_all) suffix=PRINT_ALL;; esac
            openscad -q --export-format binstl -o "E21_Corner_Wedge_V12_${suffix}.stl" -D "part=\"$p\"" E21_Corner_Wedge_V12.scad
          done
          test -s E21_Corner_Wedge_V12_PRINT_ALL.stl
          zip -q -9 E21_Corner_Wedge_V12_Package.zip E21_Corner_Wedge_V12_PRINT_ALL.stl E21_Corner_Wedge_V12_LEFT.stl E21_Corner_Wedge_V12_RIGHT.stl E21_Corner_Wedge_V12.scad V12_full_master.stl original_mount.stl v5_slim_6mm_wedge.stl README.md
      - name: Commit STL files
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
          git add 'Eufy E21 Corner Wedge V12/'*.stl 'Eufy E21 Corner Wedge V12/'*.zip
          if ! git diff --cached --quiet; then
            git commit -m 'Generate flat-face E21 corner wedge V12 STL files'
            git push
          fi
