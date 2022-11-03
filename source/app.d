import std.stdio: writeln, stderr;

void main(string[] args)
{
	import qrcode;
    import std.array: join;
    import std.algorithm: map;
    import std.conv: to;
    import std.file: write;

    if (args.length == 1) {
        import core.stdc.stdlib: exit;
        stderr.writeln("ERROR: Expecting a string to be passed in command line, did not happen so giving up ... ");
        exit(1);
    }

    string content = args[1..$].join(" ");
	
    auto qr_data = Encoder.encode(content, ErrorCorrectionLevel.H, "UTF-8");
    auto data = qr_data.matrix();

    string[] byte_matrix_rows;
    int[][] data_matrix = data.getArray();

    foreach (int[] rows; data_matrix) {
         byte_matrix_rows ~= "[" ~ rows.to!(string[]).join(",") ~ "]";
    }
    string byte_matrix_string = "[\n" ~ byte_matrix_rows.join(",\n") ~ "\n];";

    string byte_matrix_declaration = "qr_data = " ~ byte_matrix_string;
    string file_output = byte_matrix_declaration 
        ~  `
// Render stand 
translate([-2,-2,0]) cube([len(qr_data) + 4, len(qr_data) + 4, 0.48]);

// following openscad code taken from here: https://github.com/ridercz/OpenSCAD-QR, was licensed under MIT license
// Render QR code with default settings (module 1x1x1)
qr_render(qr_data);

// QR code rendering method
module qr_render(data, module_size = 1, height = 0.48) {
    maxmod = len(data) - 1;
    union() {
        for(r = [0 : maxmod]) {
            for(c = [0 : maxmod]) {
                if(data[r][c] == 1){
                    xo = c * module_size;
                    yo = (maxmod - r) * module_size;
                    translate([xo, yo, 0]) cube([module_size, module_size, height + 0.24]);
                }
            }
        }
    }
}
`;
    writeln(file_output);
}



