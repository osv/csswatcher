csswatcher [![Build Status](https://travis-ci.org/osv/csswatcher.png?branch=master)](https://travis-ci.org/osv/csswatcher)
=======

Generate completion suitable for [ac-html](https://github.com/cheunghy/ac-html).
Used by [ac-html-csswatcher](https://github.com/osv/ac-html-csswatcher) project.

## Installing

Using cpanminus:

```shell
git clone https://github.com/osv/csswatcher.git
cd csswatcher
curl -L https://cpanmin.us | perl - --sudo App::cpanminus
sudo cpanm -v -i .
```

or:

```
perl Makefile.PL
make
make test
sudo make install
```

More info after installation.

```shell
man csswatcher
```

## File .csswatcher

May be used like .projectile or .git, etc for setting project directory and
setup ignored files

```shell
% cat .csswatcher
# ignore minified css files "min.css"
ignore: min\.css$
# ignore bootstrap css files
ignore: bootstrap.*css$
```

Another example:

```shell
% cat .csswatcher
# ignore all css except app.css
ignore: \.css$
use: app\.css
```

See also https://github.com/osv/ac-html-csswatcher
