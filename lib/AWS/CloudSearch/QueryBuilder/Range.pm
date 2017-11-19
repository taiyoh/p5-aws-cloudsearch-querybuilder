package AWS::CloudSearch::QueryBuilder::Range;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (range field=FIELD boost=N RANGE)

sub new {
    my $obj = shift->SUPER::new(@_);
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
