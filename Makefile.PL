use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => "CSS Watcher",
    VERSION_FROM => "lib/CSS/Watcher.pm",
    AUTHOR => 'Olexandr Sydorchuk',
    EXE_FILES => [ 'csswatcher' ],

    PREREQ_PM => {
        'Carp'              => '0',
        'CSS::Selector::Parser ' => '0',
        'File::Copy::Recursive' => '0.38',
        'File::Spec' => 0,
        'File::Path' => 0,
        'File::Basename' => 0,
        },
);
