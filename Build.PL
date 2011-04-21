
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  'build_requires' => {
    'File::Find' => '0',
    'File::Temp' => '0',
    'Module::Build' => '0.3601',
    'Test::More' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.3601'
  },
  'dist_abstract' => 'Detects the minimum version of Perl required for your dist',
  'dist_author' => [
    'Apocalypse <APOCAL@cpan.org>'
  ],
  'dist_name' => 'Dist-Zilla-Plugin-MinimumPerl',
  'dist_version' => '1.003',
  'license' => 'perl',
  'module_name' => 'Dist::Zilla::Plugin::MinimumPerl',
  'recommends' => {},
  'recursive_test_files' => 1,
  'requires' => {
    'Dist::Zilla::Role::FileFinderUser' => '4.102345',
    'Dist::Zilla::Role::PrereqSource' => '4.102345',
    'Moose' => '1.03',
    'Moose::Util::TypeConstraints' => '1.01',
    'MooseX::Types::Perl' => '0.101340',
    'Perl::MinimumVersion' => '1.26',
    'perl' => '5.006'
  },
  'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
