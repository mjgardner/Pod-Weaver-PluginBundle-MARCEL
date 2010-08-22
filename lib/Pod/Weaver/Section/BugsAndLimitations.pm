use 5.008;
use strict;
use warnings;

package Pod::Weaver::Section::BugsAndLimitations;

# ABSTRACT: Add a BUGS AND LIMITATIONS pod section
use Moose;
with 'Pod::Weaver::Role::Section';
use namespace::autoclean;
use Moose::Autobox;

sub weave_section {
    my ($self, $document, $input) = @_;
    my $bugtracker = $input->{zilla}->distmeta->{resources}{bugtracker}{url}
      || 'http://rt.cpan.org';
    $document->children->push(
        Pod::Elemental::Element::Nested->new(
            {   command  => 'head1',
                content  => 'BUGS AND LIMITATIONS',
                children => [
                    Pod::Elemental::Element::Pod5::Ordinary->new(
                        {   content => <<EOPOD,
No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<$bugtracker>.
EOPOD
                        }
                    ),
                ],
            }
        ),
    );
}
1;

=begin :prelude

=for test_synopsis
1;
__END__

=end :prelude

=head1 SYNOPSIS

In C<weaver.ini>:

    [BugsAndLimitations]

=head1 OVERVIEW

This section plugin will produce a hunk of Pod that lists known bugs and
refers to the bugtracker URL. The plugin is automatically used by the
C<@MARCEL> weaver bundle.

=function weave_section

adds the C<BUGS AND LIMITATIONS> section.
