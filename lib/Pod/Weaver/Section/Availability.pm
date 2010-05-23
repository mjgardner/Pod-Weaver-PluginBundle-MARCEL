use 5.008;
use strict;
use warnings;

package Pod::Weaver::Section::Availability;

# ABSTRACT: Add an AVAILABILITY pod section
use Moose;
with 'Pod::Weaver::Role::Section';
use namespace::autoclean;
use Moose::Autobox;

sub weave_section {
    my ($self, $document, $input) = @_;
    my $name = $input->{zilla}->name;
    $document->children->push(
        Pod::Elemental::Element::Nested->new(
            {   command  => 'head1',
                content  => 'AVAILABILITY',
                children => [
                    Pod::Elemental::Element::Pod5::Ordinary->new(
                        {   content => <<EOPOD,
The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<http://search.cpan.org/dist/$name/>.

The development version lives at
L<http://github.com/hanekomu/$name/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.
EOPOD
                        }
                    ),
                ],
            }
        ),
    );
}
1;

=pod

=for test_synopsis
1;
__END__

=head1 SYNOPSIS

In C<weaver.ini>:

    [Availability]

=head1 OVERVIEW

This section plugin will produce a hunk of Pod that lists known bugs and
refers to the bugtracker URL. The plugin is automatically used by the
C<@MARCEL> weaver bundle.

=function weave_section

adds the C<AVAILABILITY> section.
