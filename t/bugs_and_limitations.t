#!perl

use English '-no_match_vars';
use Pod::Weaver;
use Pod::Weaver::Config::Assembler;
use Test::Most tests => 1;
use Readonly;

Readonly my $PLUGIN_NAME => 'BugsAndLimitations';

my $assembler = Pod::Weaver::Config::Assembler->new();
$assembler->sequence->add_section(
    $assembler->section_class->new( { name => '_' } ) );
$assembler->change_section($PLUGIN_NAME);
$assembler->end_section();
$assembler->finalize();

my $weaver = Pod::Weaver->new_from_config_sequence( $assembler->sequence() );

ok( (   grep { $ARG->plugin_name() eq $PLUGIN_NAME }
            @{ $weaver->plugins_with('-Section') }
    ),
    'load plugin'
);
