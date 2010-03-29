use 5.008;
use strict;
use warnings;

package Pod::Weaver::PluginBundle::MARCEL;

# ABSTRACT: build POD documentation like MARCEL
use namespace::autoclean;
use Pod::Weaver::Config::Assembler;

# plugins used
use Pod::Weaver::Section::Installation;
use Pod::Weaver::Section::CollectWithAutoDoc;

sub _exp { Pod::Weaver::Config::Assembler->expand_package($_[0]) }

sub mvp_bundle_config {
    return (
        [ '@Default/CorePrep', _exp('@CorePrep'), {} ],
        [ '@Default/prelude', _exp('Region'),  { region_name => 'prelude' } ],
        [ '@Default/Name',    _exp('Name'),    {} ],
        [ '@Default/Version', _exp('Version'), {} ],
        [ 'SYNOPSIS',         _exp('Generic'), {} ],
        [ 'DESCRIPTION',      _exp('Generic'), {} ],
        [ 'OVERVIEW',         _exp('Generic'), {} ],
        [ 'ATTRIBUTES',       _exp('Collect'), { command     => 'attr' } ],
        [ 'METHODS',   _exp('CollectWithAutoDoc'), { command => 'method' } ],
        [ 'FUNCTIONS', _exp('Collect'),            { command => 'function' } ],
        [ '@Default/Leftovers', _exp('Leftovers'), {} ],
        [ '@Default/postlude', _exp('Region'), { region_name => 'postlude' } ],
        [ '@Default/Installation',       _exp('Installation'),       {} ],
        [ '@Default/BugsAndLimitations', _exp('BugsAndLimitations'), {} ],
        [ '@Default/Availability',       _exp('Availability'),       {} ],
        [ '@Default/Authors',            _exp('Authors'),            {} ],
        [ '@Default/Legal',              _exp('Legal'),              {} ],
    );
}
1;

=pod

=for test_synopsis
1;
__END__

=head1 SYNOPSIS

In C<weaver.ini>:

    [@MARCEL]

=head1 DESCRIPTION

This is the bundle used by default for my distributions. It is nearly
equivalent to the following:

    [@CorePrep]

    [Name]
    [Version]

    [Region  / prelude]

    [Generic / SYNOPSIS]
    [Generic / DESCRIPTION]
    [Generic / OVERVIEW]

    [Collect / ATTRIBUTES]
    command = attr

    [CollectWithAutoDoc / METHODS]
    command = method

    [Collect / FUNCTIONS]
    command = function

    [Leftovers]

    [Region  / postlude]

    [Installation]
    [BugsAndLimitations]
    [Availability]
    [Authors]
    [Legal]

=function mvp_bundle_config

Defines the bundle's contents.

