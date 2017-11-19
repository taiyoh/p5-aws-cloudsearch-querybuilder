package AWS::CloudSearch::QueryBuilder::Or;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (or boost=N EXPRESSION EXPRESSION … EXPRESSIONn)

sub new {
    my ($class, %args) = @_;

    return bless \%args, $class;
}

sub to_string {
    my $self = shift;

    my @fields = ('or');
    if (defined $args->{boost}) {
        push @fields, 'boost=' . $args->{boost};
    }
    push @fields, $_->to_string for @{ $self->{expressions} };

    return q[(] . join(' ', @fields) . q[)];
}

1;
