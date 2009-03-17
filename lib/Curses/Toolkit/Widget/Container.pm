package Curses::Toolkit::Widget::Container;

use warnings;
use strict;

use parent qw(Curses::Toolkit::Widget);

use Params::Validate qw(:all);

=head1 NAME

Curses::Toolkit::Widget::Container - a container widget

=head1 DESCRIPTION

This widget can contain 0 or more other widgets.

=head1 CONSTRUCTOR

=head2 new

  input : none
  output : a Curses::Toolkit::Widget::Container

=cut

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(@_);
	$self->{children} = [];
	return $self;
}

=head1 METHODS

=head2 render

Default rendering method for the widget. Any rendre method should call draw

  input  : curses_handler
  output : the widget

=cut

sub render {
	my ($self) = @_;
	foreach my $child ($self->get_children()) {
		$child->render();
	}
	$self->draw();
    return;
}

=head2 get_children

Returns the list of children of the widget

  input : none
  output : ARRAY of Curses::Toolkit::Widget

=cut

sub get_children {
	my ($self) = @_;
	return @{$self->{children}};
}

sub _add_child {
	my ($self, $child_widget) = @_;
	push @{$self->{children}}, $child_widget;
	return $self;
}

# overload Widget's method : after setting relatives coordinates, needs to
# propagate to the children.
sub _set_relatives_coordinates {
	my $self = shift;
	$self->SUPER::_set_relatives_coordinates(@_);
	return $self;
}

# Returns the relative rectangle that a child widget can occupy.
# This is the default method, returns the whole widget space.
#
# input : none
# output : a Curses::Toolkit::Object::Coordinates object

sub _get_available_space {
	my ($self) = @_;
	my $rc = $self->get_relatives_coordinates();
	use Curses::Toolkit::Object::Coordinates;
	return Curses::Toolkit::Object::Coordinates->new(
		x1 => 0, y1 => 0,
        x2 => $rc->width(), y2 => $rc->height(),
	);
}

1;