#!/usr/bin/env raku
my %task = %{
	'completed' => False,
	'priority' => Nil,
	'completion' => Nil,
	'creation' => Nil,
	'description' => '',
	'tags' => Nil,
	'context' => Nil,
	'project' => Nil,
	'due' => Nil
}

sub parse-line(Str $line) {

    grammar G {
        token TOP { [<completed>]?<whspc>
                    [<priority>]?<whspc>
                    [<completion>]?<whspc>
                    [<creation>]?<whspc>
                    <description><whspc>
                    [<tags>]?<whspc>
                    [<context>]?<whspc>
                    [<project>]?<whspc>
                    [<due>]?<whspc>
        }
        token completed   { \w+ }
        token priority    { \\(<[A..Z]>) }
        token completion  { \w+ }
        token creation    { \w+ }
        token description { .* }
        token tags        { .* }
        token context     { .* }
        token project     { .* }
        token due         { .* }

        token whspc { \s* }
    }

    my %ltask = %task;

    my $m = G.parse($line);

    # test
    say $m;

    %ltask['priority'] = m<priority>;

    return %ltask;
}

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
