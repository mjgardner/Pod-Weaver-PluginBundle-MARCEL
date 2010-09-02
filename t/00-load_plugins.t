#!perl

use English '-no_match_vars';
use Pod::Weaver;
use Pod::Weaver::Config::Assembler;
use Test::Most tests => 2;
use Readonly;

Readonly my @PLUGINS => (
    qw(
      Availability
      BugsAndLimitations
      )
);

my $assembler = Pod::Weaver::Config::Assembler->new();
$assembler->sequence->add_section(
    $assembler->section_class->new( { name => '_' } ) );
for my $plugin (@PLUGINS) {
    $assembler->change_section($plugin);
    $assembler->end_section();
}
$assembler->finalize();

my $weaver = Pod::Weaver->new_from_config_sequence( $assembler->sequence() );

for my $plugin (@PLUGINS) {
    ok(
        (
            grep { $ARG->plugin_name() eq $plugin }
              @{ $weaver->plugins_with('-Section') }
        ),
        "load $plugin",
    );
}
