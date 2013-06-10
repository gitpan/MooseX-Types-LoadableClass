use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Class::Load 'is_class_loaded';

{
    package MyClass;
    use Moose;
    use MooseX::Types::LoadableClass qw/LoadableClass LoadableRole/;

    has foobar_class => (
        is     => 'ro',
        isa    => LoadableClass,
        coerce => 1,
    );

    has foobar_role => (
        is     => 'ro',
        isa    => LoadableRole,
        coerce => 1,
    );
}

ok !is_class_loaded('FooBarTestClass');
ok eval { MyClass->new(foobar_class => 'FooBarTestClass') };
ok is_class_loaded('FooBarTestClass');

ok !eval { MyClass->new(foobar_class => 'FooBarTestClassDoesNotExist') };
ok $@;

ok !is_class_loaded('FooBarTestRole');
ok eval { MyClass->new(foobar_role => 'FooBarTestRole') };
ok is_class_loaded('FooBarTestRole');

ok !eval { MyClass->new(foobar_role => 'FooBarTestClass') };
ok $@;

ok !eval { MyClass->new(foobar_role => 'FooBarTestRoleDoesNotExist') };
ok $@;

done_testing;
