package AWS::CloudSearch::QueryBuilder::Not;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (not boost=N EXPRESSION)

sub new {
    my ($class, %args) = @_;

    return bless \%args, $class;
}

sub to_string {
    my $self = shift;

    my @fields = ('not');
    if (defined $args->{boost}) {
        push @fields, 'boost=' . $args->{boost};
    }
    push @fields, $self->{expression}->to_string;

    return q[(] . join(' ', @fields) . q[)];
}

1;
