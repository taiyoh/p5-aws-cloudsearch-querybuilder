use strict;
use warnings;
use utf8;

use Test::More;

BEGIN {
    use_ok 'AWS::CloudSearch::QueryBuilder::And';
    use_ok 'AWS::CloudSearch::QueryBuilder::Or';
    use_ok 'AWS::CloudSearch::QueryBuilder::Not';
    use_ok 'AWS::CloudSearch::QueryBuilder::Term';
}

my $t1 = AWS::CloudSearch::QueryBuilder::Term->new(
    field => { foo => 'bar' }
);
my $t2 = AWS::CloudSearch::QueryBuilder::Term->new(
    field => { hoge => 'fuga' }
);

{
    package T::Foo;

    sub new { bless {}, $_[0] }
}

subtest 'normal case' => sub {
    my @tests = (
        {
            cls => 'And',
            args => [$t1, $t2, { boost => 2 }],
            expected => q[(and boost=2 (term field=foo 'bar') (term field=hoge 'fuga'))],
        },
        {
            cls => 'Or',
            args => [$t1, $t2, { boost => 2 }],
            expected => q[(or boost=2 (term field=foo 'bar') (term field=hoge 'fuga'))],
        },
        {
            cls => 'Not',
            args => [$t1, $t2, { boost => 2 }],
            expected => q[(not boost=2 (term field=foo 'bar'))],
        },
    );
    for my $test (@tests) {
        my $pkg = 'AWS::CloudSearch::QueryBuilder::' . $test->{cls};
        my $expr = $pkg->new(@{ $test->{args} });
        is $expr->to_string, $test->{expected};
    }
};

subtest 'unexpected case' => sub {
    my @tests = (
        {
            cls => 'And',
            args => [ $t1, T::Foo->new, { foo => 'bar' }, { hoge => 'fuga' } ],
            message => 'args allows expression only',
        },
        {
            cls => 'Or',
            args => [ $t1, T::Foo->new, { foo => 'bar' }, { hoge => 'fuga' } ],
            message => 'args allows expression only',
        },
        {
            cls => 'Not',
            args => [ $t1, T::Foo->new, { foo => 'bar' }, { hoge => 'fuga' } ],
            message => 'args allows expression only',
        },
    );
    for my $test (@tests) {
        my $pkg = 'AWS::CloudSearch::QueryBuilder::' . $test->{cls};
        local $@;
        eval { $pkg->new(@{ $test->{args} }) };
        my $msg = $test->{message};
        like $@, qr/^\[$pkg\] $msg/;
    }
};


done_testing;
