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

subtest 'normal cases' => sub {
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
        {
            cls      => 'Phrase',
            args     => { foo => 'bar' },
            expected => q[(phrase field=foo 'bar')],
        },
        {
            cls      => 'Prefix',
            args     => { foo => 'bar', boost => 2 },
            expected => q[(prefix field=foo boost=2 'bar')],
        },
        {
            cls      => 'Term',
            args     => { foo => 'bar' },
            expected => q[(term field=foo 'bar')],
        },
        {
            cls      => 'Term',
            args     => { foo => q['bar' and <\> 'baz'] },
            expected => q[(term field=foo '\'bar\' and <\> \'baz\'')],
        },
        {
            cls      => 'Range',
            args     => { foo => { '>' => 10 } },
            expected => q/(range field=foo {10,})/,
        },
        {
            cls      => 'Range',
            args     => { foo => { '>=' => 10, '<' => 15 } },
            expected => q/(range field=foo [10,15})/,
        },
        {
            cls      => 'Range',
            args     => { foo => { '<=' => 100 } },
            expected => q/(range field=foo {,100])/,
        },
    );

    for my $test (@tests) {
        my $pkg = "AWS::CloudSearch::QueryBuilder::" . $test->{cls};
        my $obj = $pkg->new(%{ $test->{args} });
        isa_ok $obj, $pkg;
        is $obj->to_string, $test->{expected};
    }
};

subtest 'unexpected cases' => sub {
    my @tests = (
        {
            cls => 'Term',
            args => { foo => 'bar', distance => 5 },
            message => 'you can select field only one',
        },
        {
            cls => 'Term',
            args => { },
            message => 'you can select field only one',
        },
        {
            cls => 'Range',
            args => { hoge => { '>' => 'a', '<=', 100 } },
            message => 'range value allows only number',
        },
        {
            cls => 'Range',
            args => { hoge => { fuga => 'piyo' } },
            message => 'you must fill range value',
        },
    );
    for my $test (@tests) {
        my $pkg = "AWS::CloudSearch::QueryBuilder::" . $test->{cls};
        local $@;
        eval { $pkg->new(%{ $test->{args} }) };
        my $err = $test->{message};
        like $@, qr/^\[$pkg\] $err/;
    }
};

done_testing;
