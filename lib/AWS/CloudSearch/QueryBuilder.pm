package AWS::CloudSearch::QueryBuilder;

use 5.012;
use warnings;
use utf8;

our $VERSION = '0.1.0';

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

sub cs_and    { AWS::CloudSearch::QueryBuilder::And->new(@_)    }
sub cs_or     { AWS::CloudSearch::QueryBuilder::Or->new(@_)     }
sub cs_not    { AWS::CloudSearch::QueryBuilder::Not->new(@_)    }
sub cs_range  { AWS::CloudSearch::QueryBuilder::Range->new(@_)  }
sub cs_term   { AWS::CloudSearch::QueryBuilder::Term->new(@_)   }
sub cs_phrase { AWS::CloudSearch::QueryBuilder::Phrase->new(@_) }
sub cs_prefix { AWS::CloudSearch::QueryBuilder::Prefix->new(@_) }
sub cs_near   { AWS::CloudSearch::QueryBuilder::Near->new(@_)   }

1;
