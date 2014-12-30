package CSS::Watcher;

use strict; 
use warnings;

use Carp;
use Data::Dumper;

use File::Basename qw/dirname basename/;
use File::Spec;
use File::Path qw/mkpath rmtree/;
use Log::Log4perl qw(:easy);
use File::Slurp qw/read_file write_file/;

use CSS::Watcher::Parser;
use CSS::Watcher::Monitor;

our $VERSION = '0.1'; # Don't forget to set version and release date in POD!

sub new {
    my $class= shift;
    my $options = shift;

    return bless ({
        parser => CSS::Watcher::Parser->new(),
    }, $class);
}

sub update {
    my $self = shift;
    my $obj = shift;

    # check what is the monobj. file? dir?
    if (-f $obj || -d $obj) {
        my $proj_dir = $self->get_project_dir ($obj);
        return unless (defined $proj_dir);

        INFO "Update project: $proj_dir";

        my $prj = $self->_get_project ($proj_dir);

        # scan new or changed files, cache them
        my $changes = 0;
        $prj->{monitor}->scan (
            sub {
                my $file = shift;
                if ($file =~ m/.css$/) {
                    INFO " (Re)parse css: $file";
                    $changes++;
                    my $data = read_file ($file);
                    my ($classes, $ids) = $self->{parser}->parse_css ($data);
                    $prj->{parsed}{$file} = {CLASSES => $classes,
                                             IDS => $ids};
                }
            });

        # # have changes? dump all classes and id completion.
        if ($changes) {
            # build unique tag - class,id
            my (%classes, %ids);
            while ( my ( $file, $completions ) = each %{$prj->{parsed}} ) {
                while ( my ( $tag, $classes ) = each %{$completions->{CLASSES}} ) {
                    foreach (@{$classes}) {
                        $classes{$tag}{$_} .= 'Defined in ' . File::Spec->abs2rel ($file, $proj_dir) . '\n';
                    }
                }
            }
            while ( my ( $file, $completions ) = each %{$prj->{parsed}} ) {
                while ( my ( $tag, $ids ) = each %{$completions->{IDS}} ) {
                    foreach (@{$ids}) {
                        $ids{$tag}{$_} .= 'Defined in ' . File::Spec->abs2rel ($file, $proj_dir) . '\n';
                    }
                }
            }
            INFO "Total classes: " . scalar (keys %classes) . ", ids: " . scalar (keys %classes);
            return ($proj_dir, \%classes, \%ids);
        }
        return $proj_dir;
    }
    return;
}

sub _get_project {
    my $self = shift;
    my $dir = shift;
    return unless defined $dir;

    unless (exists $self->{PROJECTS}{$dir}) {
        $self->{PROJECTS}{$dir} = 
            bless ( {monitor => CSS::Watcher::Monitor->new({dir => $dir})}, 'CSS::Watcher::Project' );
    }
    return $self->{PROJECTS}{$dir};
}

# Lookup for project dir similar to projectile.el
sub get_project_dir {
    my $self = shift;
    my $obj = shift;
    
    my $pdir = ! defined ($obj) ? undef:
               (-f $obj) ? dirname ($obj) :
               (-d $obj) ? $obj : undef;
    return unless (defined $pdir);

    $pdir = File::Spec->rel2abs($pdir);

    foreach (qw/.projectile .watcher .git .hg .fslckout .bzr _darcs/) {
        if (-e File::Spec->catfile($pdir, $_)) {
            return $pdir;
        }
    }
    return if (dirname($pdir) eq $pdir);
    #parent dir
    return $self->get_project_dir (dirname($pdir));
}

1;

__END__

=head1 NAME

CSS::Watcher - class, id completion for ac-html

=head1 SYNOPSIS

   use CSS::Watcher;
   my $cw = CSS::Watcher->new ();
   my ($project_dir, $classes, $ids) = $cs->update('~/work/css/');
   if (!defined $project_dir) {
      print "oops, there no css files "
   }

=head1 DESCRIPTION

Watch for changes in css files, parse them and populate ac-html completion.

=head1 AUTHOR

Olexandr Sydorchuk (olexandr.syd@gmail.com)

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Olexandr Sydorchuk

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
