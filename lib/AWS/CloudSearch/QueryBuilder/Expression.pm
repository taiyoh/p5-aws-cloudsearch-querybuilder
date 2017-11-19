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

    if (!exists $args{field}) {
        croak("[$class] require field key");
    }
    my ($field, $val) = each %{ $args{field} };

    bless {
        opt   => $opt,
        field => $field,
        value => $val,
    }, $class;
}

sub to_val_string {
    (my $ret = $_[0]->{value}) =~ s{'}{\\'}g;
    return q['] . $ret . q['];
}

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
    my @fields = ($op);
    push @fields, 'field=' . $self->{field} if $self->{field};
    push @fields, @{ $self->to_opt_string };
    push @fields, $self->to_val_string;

    return q[(] . join(' ', @fields) . q[)];
}

1;
