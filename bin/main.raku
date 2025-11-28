#!/usr/bin/env raku
use lib 'lib';
use Parser;

sub parse-file(Str $filepath) {

    my $txtfile = $filepath.IO;

    if !$txtfile.e {
        say "$filepath file not found.";
        return
    }

    my @processed_lines = hyper for $txtfile.lines(:!chomp) -> $line {
        # Perform operations on $line
        # For example, convert to uppercase:
        #$line.uc;
        parse-line($line);
    };

    # Test
    # .say for @processed_lines;
    return @processed_lines
}

sub create_tempfile($filecontent) {
    use File::Temp;

    my ($filename,$filehandle) = tempfile();
    say "Temporary file created at: $filename";

    # For file mutation
    # my $file = "todo.txt".IO.slurp;
    $filecontent.slurp(:bin).spurt($filename, :bin);

    $filehandle.spurt;
}

# TO-DO: copy first and process later
sub MAIN(Str $filepath = 'todo.txt') {
    say parse-file($filepath);
}
