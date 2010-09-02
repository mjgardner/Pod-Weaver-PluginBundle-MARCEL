package Pod::Weaver::PluginBundle::MARCEL;

# ABSTRACT: Build POD documentation like MARCEL

use English '-no_match_vars';
use namespace::autoclean;
use Pod::Weaver::Config::Assembler;

# plugins used
use Pod::Weaver::Section::Installation;

sub _bundle_list {
    my ( $section, $package, $params_ref ) = @ARG;

    return [
        $section,
        Pod::Weaver::Config::Assembler->expand_package($package),
        ( $params_ref || {} )
    ];
}

sub mvp_bundle_config {    ## no critic (RequireInterpolationOfMetachars)
    return map { [ _bundle_list( @{$ARG} ) ] } (
        [ '@Default/CorePrep', '@CorePrep' ],
        [ '@Default/prelude',   'Region',  { region_name => 'prelude' } ],
        [ '@Default/Name',      'Name' ],
        [ '@Default/Version',   'Version' ],
        [ 'SYNOPSIS',           'Generic' ],
        [ 'DESCRIPTION',        'Generic' ],
        [ 'OVERVIEW',           'Generic' ],
        [ 'ATTRIBUTES',         'Collect', { command     => 'attr' } ],
        [ 'METHODS',            'Collect', { command     => 'method' } ],
        [ 'FUNCTIONS',          'Collect', { command     => 'function' } ],
        [ '@Default/Leftovers', 'Leftovers' ],
        [ '@Default/postlude',  'Region',  { region_name => 'postlude' } ],
        [ '@Default/Installation',       'Installation' ],
        [ '@Default/BugsAndLimitations', 'BugsAndLimitations' ],
        [ '@Default/Availability',       'Availability' ],
        [ '@Default/Authors',            'Authors' ],
        [ '@Default/Legal',              'Legal' ],

    );
}
1;

=begin :prelude

=for stopwords MARCEL

=for test_synopsis
1;
__END__

=end :prelude

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

