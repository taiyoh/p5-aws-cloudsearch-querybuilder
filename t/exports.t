use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok 'AWS::CloudSearch::QueryBuilder';
}

my $expr = cs_or(
    cs_term(field => { foo => 'bar' }),
    cs_range(field => { hoge => { '<' => 10, '>=' => 3 } }),
    cs_not(
        cs_prefix(field => { foo => 'baz' })
    )
);

is $expr->to_string, q/(or (term field=foo 'bar') (range field=hoge [3,10}) (not (prefix field=foo 'baz')))/;

done_testing;
