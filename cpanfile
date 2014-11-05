requires "Dist::Zilla::Role::FileFinderUser" => "4.200006";
requires "Dist::Zilla::Role::PrereqSource" => "5.006";
requires "Moose" => "1.03";
requires "Moose::Util::TypeConstraints" => "1.01";
requires "MooseX::Types::Perl" => "0.101340";
requires "Perl::MinimumVersion" => "1.26";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.28";
};

on 'test' => sub {
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Test::More" => "0.88";
  requires "perl" => "5.006";
};

on 'configure' => sub {
  requires "Module::Build" => "0.28";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "version" => "0.9901";
};
