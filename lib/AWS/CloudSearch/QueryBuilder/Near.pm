package AWS::CloudSearch::QueryBuilder::Near;

use 5.012;
use warnings;
use utf8;

use parent 'AWS::CloudSearch::QueryBuilder::Expression';

# (near field=FIELD distance=N boost=N ‘STRING’)

sub options { [qw/distance boost/] }

1;
