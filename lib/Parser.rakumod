unit module Parser;

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

our sub parse-line(Str $line) is export {

    my @rsrv-tokens := ('@','+','due:','rec:');

    grammar G {
        token TOP { [<completed>]?
                    [<priority>]?
                    [<completion>]?
                    [<creation>]?                   
                    [<context>]?
                    [<project>]?
                    [<due>]?
                    <description>
        }
        #[<tags>]?<whspc>
        #

        rule completed    { x\s* }
        rule priority     { \(<[A..Z]>\)s* }
        token completion  { <year> '-' <month> '-' <day>\s* }
        token creation    { <year> '-' <month> '-' <day>\s* }
        rule context      { '@' \w+\s* }
        rule project      { '+' \w+\s* }
        token description  { <( .* )> <?before any(@rsrv-tokens) | <( .*? )> $ > }
        token due         { due:\w+\s* }
        token year        { \d**4 }
        token month       { \d**2 }
        token day         { \d**2 }
        #token tags        { \+w+ }
        token whspc { \s* }
    }

    my $m = G.parse($line);
    return $m
    #say $/.Str

    # Config task
    #my %ltask = %task;
    #%ltask['priority'] = m<priority>;
    #return %ltask;
}

# TO-DO: move tests, reorganized structure
#my $line := "Task with description only";
#my $line = "x (Z) Completed task with priority";
#my $line = "x 2025-12-31 Completed task with completion date";
#my $line := "x 2025-12-31 2025-12-01 Completed task with completion and start date";
my $line := "x Completed task with context and project @Phone +Health";
say parse-line($line);
