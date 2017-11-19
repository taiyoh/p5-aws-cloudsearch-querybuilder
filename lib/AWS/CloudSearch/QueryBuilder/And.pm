package AWS::CloudSearch::QueryBuilder::And;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (and boost=N EXPRESSION EXPRESSION … EXPRESSIONn)

sub new {
    my ($class, %args) = @_;

    return bless \%args, $class;
}

sub to_string {
    my $self = shift;

    my @fields = ('and');
    if (defined $args->{boost}) {
        push @fields, 'boost=' . $args->{boost};
    }
    push @fields, $_->to_string for @{ $self->{expressions} };

    return q[(] . join(' ', @fields) . q[)];
}

1;
