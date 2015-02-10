# grache

Great Ruby Cache for gems

## Status

[![GitHub version](https://badge.fury.io/gh/korczis%2Fgrache.svg)](http://badge.fury.io/gh/korczis%2Fgrache)

## Getting started 

Is simple as typing following command:

```
gem install grach
```

We should get something like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ gem install grache
Successfully installed grache-0.0.2
1 gem installed
tomaskorcak@kx-mac:~/dev/grache-test$
```

## Commands

To list command type following:

```
grache help
```

We should get something like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache help
NAME
    grache - Graces - Cache for ruby gems.

SYNOPSIS
    grache [global options] command [command options] [arguments...]

VERSION
    0.0.2

GLOBAL OPTIONS
    --help    - Show this message
    --version - Display the program version

COMMANDS
    help    - Shows a list of commands or help for one command
    pack    - Manage your pack
    version - Show version
tomaskorcak@kx-mac:~/dev/grache-test$
```

### grache pack

As title suggest ```grache pack``` is fundamental command of grache.

Lets start with simple:

```
grache pack
```

We should get sometthing like this: 

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache pack
error: Command 'pack' requires a subcommand build,install,zip

NAME
    pack - Manage your pack

SYNOPSIS
    grache [global options] pack build
    grache [global options] pack install
    grache [global options] pack zip

COMMANDS
    build   - Build pack
    install - Install pack
    zip     - Zip created pack
tomaskorcak@kx-mac:~/dev/grache-test$
```

## References

[Travis CI Bundler Caching](http://docs.travis-ci.com/user/caching/)
