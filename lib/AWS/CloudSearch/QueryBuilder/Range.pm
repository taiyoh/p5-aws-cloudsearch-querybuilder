package AWS::CloudSearch::QueryBuilder::Range;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (range field=FIELD boost=N RANGE)

sub to_val_string {
    my $self = shift;

    my ($val_pre, $val_post);
    if ($self->{range}{'>='}) {
        $val_pre = '[' . $self->{range}{'>='};
    } elsif ($self->{range}{'>'}) {
        $val_pre = '{' . $self->{range}{'>'};
    } else {
        $val_pre = '{';
    }
    if ($self->{range}{'<='}) {
        $val_post = $self->{range}{'<='} . ']';
    } elsif ($self->{range}{'<='}) {
        $val_post = $self->{range}{'>'} . '}';
    } else {
        $val_post = '}';
    }
    return sprintf('%s,%s', $val_pre, $val_post);
}

1;
