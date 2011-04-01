#
# This file is part of Dist-Zilla-Plugin-MinimumPerl
#
# This software is copyright (c) 2011 by Apocalypse.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use strict; use warnings;
package Dist::Zilla::Plugin::MinimumPerl;
BEGIN {
  $Dist::Zilla::Plugin::MinimumPerl::VERSION = '1.002';
}
BEGIN {
  $Dist::Zilla::Plugin::MinimumPerl::AUTHORITY = 'cpan:APOCAL';
}

# ABSTRACT: Detects the minimum version of Perl required for your dist

use Moose 1.03;
use Perl::MinimumVersion 1.26;
use MooseX::Types::Perl 0.101340 qw( LaxVersionStr );

with(
	'Dist::Zilla::Role::PrereqSource' => { -version => '4.102345' },
	'Dist::Zilla::Role::FileFinderUser' => {
		-version => '4.102345',
		default_finders => [ ':InstallModules', ':ExecFiles', ':TestFiles' ]
	},
);


{
	use Moose::Util::TypeConstraints 1.01;

	has perl => (
		is => 'ro',
		isa => subtype( 'Str'
			=> where { LaxVersionStr->check( $_ ) }
			=> message { "Perl must be in a valid version format - see version.pm" }
		),
		predicate => '_has_perl',
	);

	no Moose::Util::TypeConstraints;
}

sub register_prereqs {
	my ($self) = @_;

	# TODO should we check to see if it was already set in the metadata?

	# Okay, did the user set a perl version explicitly?
	if ( $self->_has_perl ) {
		# Add it to prereqs!
		$self->zilla->register_prereqs(
			{ phase => 'runtime' },
			'perl' => $self->perl,
		);
	} else {
		# TODO should we split up the prereq into test / runtime ?
		# see http://rt.cpan.org/Public/Bug/Display.html?id=61028

		# Use Perl::MinimumVersion to scan all files
		my $minver;
		foreach my $file ( @{ $self->found_files } ) {
			my $pmv = Perl::MinimumVersion->new( \$file->content );
			if ( ! defined $pmv ) {
				$self->log_fatal( "Unable to parse '" . $file->name . "'" );
			}
			my $ver = $pmv->minimum_version;
			if ( ! defined $ver ) {
				$self->log_fatal( "Unable to extract MinimumPerl from '" . $file->name . "'" );
			}
			if ( ! defined $minver or $ver > $minver ) {
				$minver = $ver;
			}
		}

		# Write out the minimum perl found
		if ( defined $minver ) {
			$self->log_debug( 'Determined that the MinimumPerl required is v' . $minver->stringify );
			$self->zilla->register_prereqs(
				{ phase => 'runtime' },
				'perl' => $minver->stringify,
			);
		} else {
			$self->log_fatal( 'Found no perl files, check your dist?' );
		}
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;


__END__
=pod

=for :stopwords Apocalypse cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee
diff irc mailto metadata placeholders dist prereqs

=encoding utf-8

=for Pod::Coverage register_prereqs

=head1 NAME

Dist::Zilla::Plugin::MinimumPerl - Detects the minimum version of Perl required for your dist

=head1 VERSION

  This document describes v1.002 of Dist::Zilla::Plugin::MinimumPerl - released March 31, 2011 as part of Dist-Zilla-Plugin-MinimumPerl.

=head1 DESCRIPTION

This plugin uses L<Perl::MinimumVersion> to automatically find the minimum version of Perl required
for your dist and adds it to the prereqs.

	# In your dist.ini:
	[MinimumPerl]

=head1 ATTRIBUTES

=head2 perl

Specify a version of perl required for the dist. Please specify it in a format that Build.PL/Makefile.PL understands!
If this is specified, this module will not attempt to automatically detect the minimum version of Perl.

The default is: undefined ( automatically detect it )

Example: 5.008008

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla|Dist::Zilla>

=back

=head1 SUPPORT

=head2 Perldoc

You can find documentation for this module with the perldoc command.

  perldoc Dist::Zilla::Plugin::MinimumPerl

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-Plugin-MinimumPerl>

=item *

RT: CPAN's Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-Plugin-MinimumPerl>

=item *

AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-Plugin-MinimumPerl>

=item *

CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-Plugin-MinimumPerl>

=item *

CPAN Forum

L<http://cpanforum.com/dist/Dist-Zilla-Plugin-MinimumPerl>

=item *

CPANTS Kwalitee

L<http://cpants.perl.org/dist/overview/Dist-Zilla-Plugin-MinimumPerl>

=item *

CPAN Testers Results

L<http://cpantesters.org/distro/D/Dist-Zilla-Plugin-MinimumPerl.html>

=item *

CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Dist-Zilla-Plugin-MinimumPerl>

=back

=head2 Email

You can email the author of this module at C<APOCAL at cpan.org> asking for help with any problems you have.

=head2 Internet Relay Chat

You can get live help by using IRC ( Internet Relay Chat ). If you don't know what IRC is,
please read this excellent guide: L<http://en.wikipedia.org/wiki/Internet_Relay_Chat>. Please
be courteous and patient when talking to us, as we might be busy or sleeping! You can join
those networks/channels and get help:

=over 4

=item *

irc.perl.org

You can connect to the server at 'irc.perl.org' and join this channel: #perl-help then talk to this person for help: Apocalypse.

=item *

irc.freenode.net

You can connect to the server at 'irc.freenode.net' and join this channel: #perl then talk to this person for help: Apocal.

=item *

irc.efnet.org

You can connect to the server at 'irc.efnet.org' and join this channel: #perl then talk to this person for help: Ap0cal.

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-dist-zilla-plugin-minimumperl at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Dist-Zilla-Plugin-MinimumPerl>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<http://github.com/apocalypse/perl-dist-zilla-plugin-minimumperl>

  git clone git://github.com/apocalypse/perl-dist-zilla-plugin-minimumperl.git

=head1 AUTHOR

Apocalypse <APOCAL@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Apocalypse.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

The full text of the license can be found in the LICENSE file included with this distribution.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT
WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER
PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE
SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME
THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE LIABLE
TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE
SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES.

=cut

