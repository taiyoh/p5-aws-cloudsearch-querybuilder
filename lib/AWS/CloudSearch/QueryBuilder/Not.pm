package AWS::CloudSearch::QueryBuilder::Not;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

use Carp qw/croak/;
use Scalar::Util qw/blessed/;

# (not boost=N EXPRESSION)

sub new {
    my ($class, @args) = @_;

    my $opt = {};
    if (ref($args[-1]) eq 'HASH') {
        $opt = pop @args;
    }

    if (grep { !blessed($_) || !$_->isa('AWS::CloudSearch::QueryBuilder::Expression') } @args) {
        croak("[$class] args allows expression only");
    }

    return bless {
        opt => $opt,
        expression => $args[0],
    }, $class;
}

sub to_val_string {
    my $self = shift;
    return $self->{expression}->to_string;
}

1;
