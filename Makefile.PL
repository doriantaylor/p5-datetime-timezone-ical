use inc::Module::Install;

name     'DateTime-TimeZone-ICal';
all_from 'lib/DateTime/TimeZone/ICal.pm';
author   q{Dorian Taylor <dorian@cpan.org>};
license  'apache';

build_requires 'Test::More';

auto_install;

WriteAll;

