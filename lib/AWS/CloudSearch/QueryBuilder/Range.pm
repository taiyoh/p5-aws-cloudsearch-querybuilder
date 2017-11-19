package AWS::CloudSearch::QueryBuilder::Range;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

use Carp qw/croak/;
use Scalar::Util qw/looks_like_number/;

# (range field=FIELD boost=N RANGE)

sub new {
    my $class = shift;
    my $obj   = $class->SUPER::new(@_);

    my $value = delete $obj->{value};
    my ($pre_op, $pre_val, $post_op, $post_val) = map { "" } 1 .. 4;
    if ($value->{'>='}) {
        $pre_op  = '[';
        $pre_val = $value->{'>='};
    } elsif ($value->{'>'}) {
        $pre_op  = '{';
        $pre_val = $value->{'>'};
    } else {
        $pre_op = '{';
    }
    if ($value->{'<='}) {
        $post_op  = ']';
        $post_val = $value->{'<='};
    } elsif ($value->{'<'}) {
        $post_op  = '}';
        $post_val = $value->{'<'};
    } else {
        $post_op = '}';
    }

    if ($pre_val ne '' && !looks_like_number($pre_val)) {
        croak("[$class] range value allows only number");
    }
    if ($post_val ne '' && !looks_like_number($post_val)) {
        croak("[$class] range value allows only number");
    }
    if ($pre_val eq '' && $post_val eq '') {
        croak("[$class] you must fill range value");
    }

    $obj->{value} = {
        pre  => { op => $pre_op, val => $pre_val },
        post => { op => $post_op, val => $post_val },
    };

    return $obj;
}

sub to_val_string {
    my $self = shift;
    my $pre  = $self->{value}{pre};
    my $post = $self->{value}{post};
    return sprintf('%s%s,%s%s', $pre->{op}, $pre->{val}, $post->{val}, $post->{op});
}

1;
