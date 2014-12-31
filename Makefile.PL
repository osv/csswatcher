use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME => "CSS_Watcher",
    VERSION_FROM => "lib/CSS/Watcher.pm",
    AUTHOR => 'Olexandr Sydorchuk',
    EXE_FILES => [ 'csswatcher' ],

    PREREQ_PM => {
        'Carp'              => '0',
        'CSS::Selector::Parser' => '0',
        'Log::Log4perl' => 0,
        'File::Slurp' => 0,
        'Path::Tiny'  => 0,
        'File::Copy::Recursive' => '0.38',
        },
);
