use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok 'AWS::CloudSearch::QueryBuilder::Near';
    use_ok 'AWS::CloudSearch::QueryBuilder::Phrase';
    use_ok 'AWS::CloudSearch::QueryBuilder::Prefix';
    use_ok 'AWS::CloudSearch::QueryBuilder::Range';
    use_ok 'AWS::CloudSearch::QueryBuilder::Term';
}

my @tests = (
    {
        cls      => 'Near',
        args     => { foo => 'bar' },
        expected => q[(near field=foo 'bar')],
    },
    {
        cls      => 'Near',
        args     => { foo => 'bar', boost => 2, distance => 5 },
        expected => q[(near field=foo distance=5 boost=2 'bar')],
    },
);

for my $test (@tests) {
    my $pkg = "AWS::CloudSearch::QueryBuilder::" . $test->{cls};
    my $obj = $pkg->new(%{ $test->{args} });
    isa_ok $obj, $pkg;
    is $obj->to_string, $test->{expected};
}

done_testing;
