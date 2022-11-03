# qrcode_generator

A small utility that generates an openscad file which can be edited or used with openscad to produce an stl of a qrcode.

# BUILD

dub

# USAGE

./qrcode_generator this is the string I want encoded > output.scad 
openscad -o output.stl output.scad

# CREDITS

The OpenSCAD code was taken from https://github.com/ridercz/OpenSCAD-QR .

