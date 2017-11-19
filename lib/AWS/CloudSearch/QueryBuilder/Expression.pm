package AWS::CloudSearch::QueryBuilder::Expression;

use 5.012;
use warnings;
use utf8;

use Carp qw/croak/;
use Scalar::Util qw/looks_like_number/;
use POSIX qw/floor/;

sub options { [qw/boost/] }

sub new {
    my ($class, %args) = @_;

    my $opt = {};
    for my $key (@{ $class->options }) {
        my $v = delete $args{$key};
        next unless defined $v;
        if (!looks_like_number($v) || $v < 0) {
            croak("[$class] invalid $key: $v");
        }
        $opt->{$key} = floor($v);
    }

    if (scalar(keys %args) > 1) {
        croak("[$class] args has ovesize keys");
    }

    my ($field, $val) = each %args;

    bless {
        opt   => $opt,
        field => $field,
        value => $val,
    }, $class;
}

sub to_val_string { return q['] . $_[0]->{value} . q['] }

sub to_opt_string {
    my $self = shift;

    my @fields;
    for my $key (@{ $self->options() }) {
        if (defined $self->{opt}{$key}) {
            push @fields, sprintf('%s=%s', $key, $self->{opt}{$key});
        }
    }
    return \@fields;
}

sub to_string {
    my $self = shift;

    my ($pkg) = reverse split '::', ref($self);
    my $op = lc $pkg;
    my @fields = ($op, 'field=' . $self->{field});
    push @fields, @{ $self->to_opt_string };
    push @fields, $self->to_val_string;

    return q[(] . join(' ', @fields) . q[)];
}

1;
