use strict;
use warnings;
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
my $min_tpc = 1.08;
eval "use Test::Pod::Coverage $min_tpc";
plan skip_all => "Test::Pod::Coverage $min_tpc required for testing POD coverage"
    if $@;

# Test::Pod::Coverage doesn't require a minimum Pod::Coverage version,
# but older versions don't recognize some common documentation styles
my $min_pc = 0.18;
eval "use Pod::Coverage $min_pc";
plan skip_all => "Pod::Coverage $min_pc required for testing POD coverage"
    if $@;
my $trustme = [qr/^(?:BUILD|category|name|is_(?:floating|olson|utc)|
has_dst_changes|(?:is_dst|offset|short_name)_for(?:_local)?_datetime)$/x];

#       BUILD
#       category
#       has_dst_changes
#       is_dst_for_datetime
#       is_floating
#       is_olson
#       is_utc
#       name
#       offset_for_datetime
#       offset_for_local_datetime
#       short_name_for_datetime


all_pod_coverage_ok({ trustme => $trustme });
