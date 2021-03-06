package Pod::Weaver::Section::Availability;

# ABSTRACT: Add an AVAILABILITY pod section

use Carp;
use English '-no_match_vars';
use Moose;
with 'Pod::Weaver::Role::Section';
## no critic (Modules::RequireExplicitInclusion)
use namespace::autoclean;
use Moose::Autobox;
use Regexp::DefaultFlags;

# add a set of attributes to hold the repo information
has zilla =>
    ( is => 'rw', isa => 'Dist::Zilla', handles => [ 'name', 'distmeta' ] );
has is_github => ( is => 'rw', isa => 'Bool', lazy_build => 1 );
has [qw(homepage_url cpan_url repo_type repo_url repo_web)] =>
    ( is => 'rw', isa => 'Str', lazy_build => 1 );

sub weave_section {
    my ( $self, $document, $input ) = @_;

    $self->zilla( $input->{zilla} );
    return $document->children->push(
        Pod::Elemental::Element::Nested->new(
            {   command  => 'head1',
                content  => 'AVAILABILITY',
                children => [
                    $self->_homepage_pod, $self->_cpan_pod,
                    $self->_development_pod,
                ],
            }
        ),
    );
}

sub _build_homepage_url {
    my $self = shift;

    return $self->distmeta->{resources}{homepage}
        || sprintf 'http://search.cpan.org/dist/%s/', $self->name;
}

sub _build_cpan_url {
    return sprintf 'http://search.cpan.org/dist/%s/', shift->name;
}

# if we don't know we default to git...
sub _build_repo_type {
    return shift->distmeta->{resources}{repository}{type} || 'git';
}

sub _build_repo_url { return ( shift->_build_repo_data )[0] }
sub _build_repo_web { return ( shift->_build_repo_data )[1] }

sub _build_is_github {

    # we do this by looking at the URL for githubbyness
    my $repourl = shift->distmeta->{resources}{repository}{url}
        or croak 'No repository URL set in distmeta';
    return scalar $repourl =~ m{/github [.] com/};
}

sub _build_repo_data {
    my $self = shift;

    my $repourl = $self->distmeta->{resources}{repository}{url}
        or croak 'No repository URL set in distmeta';
    my $repoweb;
    if ( $self->is_github ) {

        # strip the access method off - we can then add it as needed
        my $nomethod = $repourl;
        $nomethod =~ s{\A (http|git|git [@] github [.] com) :/* }{}i;
        $repourl = "git://$nomethod";
        $repoweb = "http://$nomethod";
    }
    return ( $repourl, $repoweb );
}

sub _homepage_pod {
    my $self = shift;

    # we suppress this if there is no homepage URL,
    # or the CPAN URL is same as the homepage URL
    return
        if !$self->homepage_url
            or ( $self->cpan_url eq $self->homepage_url );

    # otherwise return some boilerplate
    return Pod::Elemental::Element::Pod5::Ordinary->new(
        {   content =>
                "The project homepage is\nL<@{[ $self->homepage_url ]}>.",
        }
    );
}

sub _cpan_pod {
    my $self = shift;

    return Pod::Elemental::Element::Pod5::Ordinary->new(
        { content => <<"END_CPAN_TEXT" } );
The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see
L<@{[ $self->cpan_url ]}>.
END_CPAN_TEXT
}

sub _development_pod {
    my $self = shift;

    return Pod::Elemental::Element::Pod5::Ordinary->new(
        {   content => !$self->is_github
            ? "The development version lives in a @{[ $self->repo_type ]} "
                . "repository at\nL<@{[ $self->repo_web ]}>"
            : <<"END_GITHUB_TEXT"} );
The development version lives at
L<@{[ $self->repo_web ]}>
and may be cloned from
L<@{[ $self->repo_url ]}>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.
END_GITHUB_TEXT
}

1;

=begin :prelude

=for test_synopsis
1;
__END__

=end :prelude

=head1 SYNOPSIS

In C<weaver.ini>:

    [Availability]

=head1 OVERVIEW

This section plugin will produce a hunk of Pod that gives
information about the availability and development of the project
or module.

All information used to generate the pod text is taken from the
L<Dist::Zilla::Plugin::MetaConfig> C<distmeta> information, so this
will only work within a L<Dist::Zilla> environment.

At present 3 POD paragraphs may be generated within the section:-

=over 4

=item * Home page information - this is only generated if the home
page is defined within C<distmeta> and if that home page is
different to the CPAN page for the module.  The distmeta key
for this information is C<resources.homepage>

=item * CPAN generic information with a link to the module on CPAN.

=item * Development information, including the location of
development source control repositories. The repository type is
assumed to be git, although this can changed (distmeta key
C<resources.repository.type>).

If the repository is recognised to be a github repository the
boilerplate text is modified to reflect a more git/github mechanism
for co-operative development. 

=back

The plugin is automatically used by the C<@MARCEL> weaver bundle -
see L<Pod::Weaver::PluginBundle::MARCEL>.

=function weave_section

adds the C<AVAILABILITY> section.
