package AWS::CloudSearch::QueryBuilder;

use 5.012;
use warnings;
use utf8;

use Exporter 'import';

our @EXPORT = qw/cs_and cs_or cs_not cs_range cs_near cs_prefix cs_phrase cs_term/;

use AWS::CloudSearch::QueryBuilder::And;
use AWS::CloudSearch::QueryBuilder::Or;
use AWS::CloudSearch::QueryBuilder::Not;

use AWS::CloudSearch::QueryBuilder::Range;
use AWS::CloudSearch::QueryBuilder::Near;
use AWS::CloudSearch::QueryBuilder::Prefix;
use AWS::CloudSearch::QueryBuilder::Phrase;
use AWS::CloudSearch::QueryBuilder::Term;


sub cs_and {
    my @args = @_;
    my $boost;
    if (!ref $args[0]) {
        (undef, my $val) = splice @args, 0, 2;
        $boost = $val;
    }
    die "require expression" if grep { !$_->isa('AWS::CloudSearch::QueryBuilder::Expression') } @args;

    return AWS::CloudSearch::QueryBuilder::And->new(
        boost       => $boost,
        expressions => \@args,
    );
}

sub cs_or {
    my @args = @_;
    my $boost;
    if (!ref $args[0]) {
        (undef, my $val) = splice @args, 0, 2;
        $boost = $val;
    }
    die "require expression" if grep { !$_->isa('AWS::CloudSearch::QueryBuilder::Expression') } @args;

    return AWS::CloudSearch::QueryBuilder::Or->new(
        boost       => $boost,
        expressions => \@args,
    );
}

sub cs_not {
    my @args = @_;
    my $boost;
    if (!ref $args[0]) {
        (undef, my $val) = splice @args, 0, 2;
        $boost = $val;
    }
    die "require expression" if grep { !$_->isa('AWS::CloudSearch::QueryBuilder::Expression') } @args;

    return AWS::CloudSearch::QueryBuilder::Not->new(
        boost      => $boost,
        expression => $args[0],
    );
}

sub cs_range {
    return AWS::CloudSearch::QueryBuilder::Range->new(@_);
}

sub cs_term {
    return AWS::CloudSearch::QueryBuilder::Term->new(@_);
}

sub cs_phrase {
    return AWS::CloudSearch::QueryBuilder::Phrase->new(@_);
}

sub cs_prefix {
    return AWS::CloudSearch::QueryBuilder::Prefix->new(@_);
}

sub cs_near {
    return AWS::CloudSearch::QueryBuilder::Near->new(@_);
}

1;
