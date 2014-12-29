#!/usr/bin/perl -I..lib -Ilib
use strict;
use Test::More tests => 6;

BEGIN { use_ok("CSS::Watcher::Parser"); }

my $parser =  CSS::Watcher::Parser->new();

subtest "Comments" => sub {
    my ($classes, $ids) = $parser->parse_css(<<CSS)
/* .class1 {foo: bar; zzz: xxx} */
CSS
        ;
    is_deeply($classes, {}, "no classes");
    is_deeply($classes, {}, "no ids");
};

subtest "Simple css, class" => sub {
    my ($classes) = $parser->parse_css(<<CSS)
.class1
 {foo: bar;
  zzz: xxx}
CSS
        ;
    my $expect = {"global" => ["class1"]};
    is_deeply($classes, $expect, "class selector");
    
};

subtest "Simple css, Ids" => sub {
    my ($_, $ids) = $parser->parse_css(<<CSS)
#id1 {foo: bar; zzz: xxx} */
CSS
        ;
    my $expect = {"global" => ["id1"]};
    is_deeply($ids, $expect, "id selector");
    
};

subtest "Complex css" => sub {
    my ($classes, $ids) = $parser->parse_css(<<CSS)
div.container {color: red}
#abc, div.col {}
/* div.container2 {color: red} */
/* minifi */
p#abc{color:green}a.small,.big{}
CSS
        ;
    my $expect_classes = {global => [qw/big/],
                          div => [qw/container col/],
                          a => [qw/small/]};
    my $expect_ids = {global => ["abc"],
                      p => ["abc"]};
    is_deeply($classes, $expect_classes, "Classes list");
    is_deeply($ids, $expect_ids, "Ids list");
};

subtest '@media nested classes and ids' => sub {
    my ($classes, $ids) = $parser->parse_css(<<CSS)
\@media (min-width: 768px) {
  div.container {color: red}
  #abc, div.col {}
/* div.container2 {color: red} */
/* minifi */
p#abc{color:red}a.small,.big{}
}
CSS
        ;
    my $expect_classes = {global => [qw/big/],
                          div => [qw/container col/],
                          a => [qw/small/]};
    my $expect_ids = {global => ["abc"],
                      p => ["abc"]};
    is_deeply($classes, $expect_classes, "Classes list");
    is_deeply($ids, $expect_ids, "Ids list");
}










