csswatcher [![Build Status](https://travis-ci.org/osv/csswatcher.png?branch=master)](https://travis-ci.org/osv/csswatcher)
=======

Generate completion suitable for [ac-html](https://github.com/cheunghy/ac-html).

## Installing

```shell
git clone https://github.com/osv/csswatcher.git
cd csswatcher
curl -L https://cpanmin.us | perl - --sudo App::cpanminus
sudo cpanm -v -i .
```

More info about
```shell
man csswatcher
```

## .csswatcher

May be used like .projectile or .git, etc for setting project directory and
setup ignored files

```shell
% cat .csswatcher
# ignore minified css files "min.css"
ignore: min\.css$
# ignore bootstrap css files
ignore: bootstrap.*css$
```

See also https://github.com/osv/ac-html-csswatcher
