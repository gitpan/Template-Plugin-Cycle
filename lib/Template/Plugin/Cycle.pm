package Template::Plugin::Cycle;

=pod

=head1 NAME

Template::Plugin::Cycle - Cyclically insert from a sequence of values

=head1 SYNOPSIS

  use Template::Plugin::Cycle;
  
  # Create a Cycle object and set some values
  my $Cycle = Template::Plugin::Cycle->new;
  $Cycle->init('normalrow', 'alternaterow');
  
  # Bind the Cycle object into the Template
  $Template->process( 'tablepage.html', class => $Cycle );
  
  
  
  
  
  #######################################################
  # Later that night in a Template
  
  <table border="1">
    <tr class="[% class %]">
      <td>First row</td>
    </tr>
    <tr class="[% class %]">
      <td>Second row</td>
    </tr>
    <tr class="[% class %]">
      <td>Third row</td>
    </tr>
  </table>
  
  [% class.reset %]
  <table border="1">
    <tr class="[% class %]">
      <td>Another first row</td>
    </tr>
  </table>




  
  #######################################################
  # Which of course produces
  
  <table border="1">
    <tr class="normalrow">
      <td>First row</td>
    </tr>
    <tr class="alternaterow">
      <td>Second row</td>
    </tr>
    <tr class="normalrow">
      <td>Third row</td>
    </tr>
  </table>
  
  <table border="1">
    <tr class="normalrow">
      <td>Another first row</td>
    </tr>
  </table>

=head1 DESCRIPTION

Sometime, admittedly mostly when doing alternating table row backgrounds, :)
when you need to dump an alternating, cycling, set of values into a template.

Template::Plugin::Cycle is a small, simple, DWIM solution to these sorts of
tasks. And it's pretty darn easy to use.

Simple create a new Cycle object as normal, passing it the values to cycle
between, and then just use it in the appropriate places. Each time it is
evaluated, a different value will be inserted into the template.

=head1 METHODS

=cut

use strict;
use UNIVERSAL 'isa';
use overload 'bool' => sub () { 1 };
use overload '""'   => 'next';

use vars qw{$VERSION};
BEGIN {
	$VERSION = '0.01';
}





#####################################################################
# Constructor

=pod

=head2 new [ @list ]

The C<new> constructor creates and returns a new C<Template::Plugin::Cycle>
object. It can be optionally passed an initial set of values to cycle
through.

=cut

sub new {
	my $self = bless [ 0, () ], shift;
	$self->init( @_ ) if @_;
	$self;
}

=pod

=head2 init @list

If you need to set the values for a new empty object, of change the values
to cycle through for an existing object, they can be passed to the C<init>
method.

The method always returns the C<''> null string, to avoid inserting
anything into the template.

=cut

sub init {
	my $self = ref $_[0] ? shift : return undef;
	@$self = ( 0, @_ );
	'';
}





#####################################################################
# Main Methods

=pod

=head2 elements

The C<elements> method returns the number of items currently set for the
C<Template::Plugin::Cycle> object.

=cut

sub elements {
	my $self = ref $_[0] ? shift : return undef;
	$#$self;
}

=pod

=head2 list

The C<list> method returns the current list of values for the
C<Template::Plugin::Cycle> object.

This is also the prefered method for getting access to a value at a
particular position within the list of items being cycled to.

  [%# Access a variety of things from the list %]
  The first item in the Cycle object is [% cycle.list.first %].
  The second item in the Cycle object is [% cycle.list.[1] %].
  The last item in the Cycle object is [% cycle.list.last %].

=cut

sub list {
	my $self = ref $_[0] ? shift : return undef;
	$self->elements ? @$self[ 1 .. $#$self ] : ();
}

=pod

=head2 next

The C<next> method returns the next value from the Cycle. If the end of
the list of valuese is reached, it will "cycle" back the first object again.

This method is also the one called when the object is stringified. That is,
when it appears on it's own in a template. Thus, you can do something like
the following.

  <!-- An example of alternate row classes in a table-->
  <table border="1">
    <!-- Explicitly access the next class in the cycle -->
    <tr class="[% rowclass.next %]">
      <td>First row</td>
    </tr>
    <!-- This has the same effect -->
    <tr class="[% rowclass %]">
      <td>Second row</td>
    </tr>
  </table>

=cut

sub next {
	my $self = ref $_[0] ? shift : return undef;
	return '' unless $#$self;
	$self->[0] = 1 if ++$self->[0] > $#$self;
	$self->[$self->[0]];
}

=pod

=head2 value

The C<value> method is an analogy for the C<next> method.

=cut

BEGIN {
	*value = *next{CODE};
}

=pod

=head2 reset

If a single C<Template::Plugin::Cycle> object is to be used it multiple
places within a template, and it is important that the same value be first
every time, then the C<reset> method can be used.

The C<reset> method resets the Cycle, so that the next value returned will
be the first value in the Cycle object.

=cut

sub reset {
	my $self = ref $_[0] ? shift : return undef;
	$self->[0] = 0;
	'';
}

1;

=pod

=head1 SUPPORT

Bugs should be submitted via the CPAN bug tracker, located at

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Template%3A%3APlugin%3A%3ACycle>

For other issues, contact the author.

=head1 AUTHOR

    Adam Kennedy (Maintainer)
    cpan@ali.as
    http://ali.as/

=head1 COPYRIGHT

Copyright (c) 2004 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut
