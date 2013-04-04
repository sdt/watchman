package App::Watchman::Schema::ColumnTypes;

use 5.12.0;
use warnings;

# ABSTRACT: Define schema column types
# VERSION

use DBICx::DataDictionary qw( add_type );

add_type PrimaryKey => {
    data_type => 'integer',
    is_nullable => 0,
    is_auto_increment => 1,
};

add_type ForeignKey => {
    data_type => 'integer',
    is_nullable => 0,
    is_foreign_key => 1,
};

add_type Text => {
    data_type => 'text',
    is_nullable => 0,
};

add_type Integer => {
    data_type => 'integer',
    is_nullable => 0,
};

add_type Boolean => {
    data_type => 'boolean',
    is_nullable => 0,
};


1;
