package DateTime::TimeZone::_ICal;

use parent 'DateTime::TimeZone';

# kill the DateTime::TimeZone constructor
sub new {
    bless {}, shift || __PACKAGE__
}

package DateTime::TimeZone::ICal;

use 5.010;
use strict;
use warnings FATAL => 'all';

use base 'DateTime::TimeZone::_ICal';

=head1 NAME

DateTime::TimeZone::ICal - iCal VTIMEZONE entry to DateTime::TimeZone

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use Data::ICal;
    use DateTime::Format::ICal;
    use DateTime::TimeZone::ICal;

    my $ical = Data::ICal->new(filename => 'foo.ics');

    # generate a table of time zones
    my (%tz, @events);
    for my $entry (@{$ical->entries}) {
        my $type = $entry->ical_entry_type;
        if ($type eq 'VTIMEZONE') {
            my $dtz = DateTime::TimeZone::ICal->from_ical_entry($entry);
            $tz{$dtz->name} = $dtz;
        }
        elsif ($type eq 'VEVENT') {
            push @events, $entry;
        }
        # ... handle other iCal objects ...
     }

     # now we can use this dictionary of time zones elsewhere:

     for my $event (@events) {
         # get a property that is a date
         my ($dtstart) = @{$event->property('dtstart')};

         # get the time zone key from the property parameters
         my $tzid = $dtstart->parameters->{TZID};

         # convert the date in the ordinary fashion
         my $dt = DateTime::Format::ICal->parse_datetime($dtstart->value);

         # the datetime will be 'floating', therefore unaffected
         $dt->set_time_zone($tz{$tzid}) if $tzid and $tz{$tzid};

         # ... do other processing ...
     }

=head1 DESCRIPTION

Conforming iCal documents (L<RFC
5545|https://tools.ietf.org/html/rfc5545>) have three ways to
represent C<DATE-TIME> values: UTC, local, and specified through the
C<TZID> mechanism. C<TZID> I<parameters> in relevant properties are
references to the same C<TZID> I<property> in one of a list of
C<VTIMEZONE> objects, where the information about UTC offsets and
their recurrence is embedded in the document.

In practice, many generators of iCal documents use, as C<TZID> keys,
valid labels from L<the Olson
database|http://www.iana.org/time-zones>, but others, notably
Microsoft Outlook, do not. RFC 5545 explicitly declines to specify a
naming convention, so it is sometimes necessary to construct the time
zone offsets and daylight savings changes from the C<VTIMEZONE> data
itself, rather than just inferring it from the name. That's where this
module comes in.

=head1 METHODS

The only differences in interface for this module are its constructor
and one method, L</from_ical_entry>. The rest of the interface should
work exactly the same way as L<DateTime::TimeZone>, so please consult
its documentation for other functionality.

=head2 new %PARAMS

The constructor has been modified to permit the assembly of a time
zone specification from piecemeal data. These are the following
initialization parameters:

=over 4

=item tzid

This is the C<TZID> of the object. Note that the accessor to retrieve
the value from an instantiated object is C<name>, for congruence with
L<DateTime::TimeZone>.

=item standard

This is an C<ARRAY> reference of L<DateTime::TimeZone::ICal::Spec>
instances, or otherwise of C<HASH> references congruent to that
module's constructor, which will be coerced into said objects. This
parameter is I<required>, and there must be L<at least> one member in
the C<ARRAY>.

=item daylight

Same deal but for Daylight Savings Time. This parameter is optional,
as is its contents.

=back

In practice you may not need to ever use this constructor directly,
but it may come in handy for instances where you need to compose
non-standard time zone behaviour from scratch.

=cut

sub BUILD {
}

=head2 from_ical_entry $ENTRY [, $USE_DATA ]

This class method converts a L<Data::ICal::Entry> object of type
C<VTIMEZONE> into a L<DateTime::TimeZone::ICal> object. It will
C<croak> if the input is malformed, so wrap it in an C<eval> or
equivalent if you expect that possibility.

This method attempts to check if an existing L<DateTime::TimeZone> can
be instantiated from the C<TZID>, thus skipping over any local
processing. This behaviour can be overridden with the C<$USE_DATA>
flag.

=cut

sub from_ical_entry {
}

=head1 AUTHOR

Dorian Taylor, C<< <dorian at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-datetime-timezone-ical at rt.cpan.org>, or through the web
interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTime-TimeZone-ICal>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTime::TimeZone::ICal


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTime-TimeZone-ICal>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTime-TimeZone-ICal>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTime-TimeZone-ICal>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTime-TimeZone-ICal/>

=back

=head1 SEE ALSO

=over 4

=item L<DateTime::TimeZone>

=item L<DateTime::Format::ICal>

=item L<Data::ICal>

=item L<RFC 5545|https://tools.ietf.org/html/rfc5545>

=item L<IANA Time Zones (Olson Database)|http://www.iana.org/time-zones>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2015 Dorian Taylor.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License.  You may
obtain a copy of the License at
L<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied.  See the License for the specific language governing
permissions and limitations under the License.

=cut

1; # End of DateTime::TimeZone::ICal
