
use strict;
use warnings;

BEGIN { require 5.006; }

use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Detects the minimum version of Perl required for your dist',
  'AUTHOR' => 'Apocalypse <APOCAL@cpan.org>',
  'BUILD_REQUIRES' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'ExtUtils::MakeMaker' => '6.31',
    'Test::More' => '0.88'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.31'
  },
  'DISTNAME' => 'Dist-Zilla-Plugin-MinimumPerl',
  'EXE_FILES' => [],
  'LICENSE' => 'perl',
  'NAME' => 'Dist::Zilla::Plugin::MinimumPerl',
  'PREREQ_PM' => {
    'Dist::Zilla::Role::FileFinderUser' => '4.102345',
    'Dist::Zilla::Role::PrereqSource' => '4.102345',
    'Moose' => '1.03',
    'Moose::Util::TypeConstraints' => '1.01',
    'MooseX::Types::Perl' => '0.101340',
    'Perl::MinimumVersion' => '1.26'
  },
  'VERSION' => '1.003',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



