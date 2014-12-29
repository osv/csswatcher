#!/usr/bin/perl -I..lib -Ilib
use strict;
use Test::More tests => 3;
use File::Copy::Recursive qw(dircopy);
use File::Path qw/mkpath rmtree/;
use File::Spec;
use Digest::MD5 qw/md5_hex/;

BEGIN { use_ok("CSS::Watcher"); }

subtest "Projectile dir" => sub {
    is (CSS::Watcher->get_project_dir("t/fixtures/prj1/css/simple.css"),
        File::Spec->rel2abs("t/fixtures/prj1"),
        "Search for \".watcher\" file");
};

my $home_dir = File::Spec->rel2abs('t/monitoring/ac-html/');

my $watcher = CSS::Watcher->new({home => $home_dir});

rmtree "t/monitoring/";
mkpath "t/monitoring/";
dircopy "t/fixtures/prj1/", "t/monitoring/prj1";

subtest "Dirs of projects" => sub {
    is ($watcher->update("t/monitoring/NOPROJECT/css"), undef,
        "\$watcher->update return undef if bad project path");

    my ($project_dir, $classes, $ids) = $watcher->update("t/monitoring/prj1/css");
    is ($project_dir, File::Spec->rel2abs('t/monitoring/prj1/'), 'Check project directory');
    ok ($classes->{global}{container} =~ m/override\.css/, ".container must be present in override.css");
    ok ($classes->{global}{container} =~ m/simple\.css/, ".container must be present in simple.css");
    ok ($ids->{global}{myid} =~ m/simple\.css/, "#myid must be present in simple.css");
};




