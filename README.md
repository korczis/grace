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


### grache pack build

Builds the vendor/cache for deployment.

Lets type:

```
grache pack build
```

We should get sometthing like this: 

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache pack build
Packing /Users/tomaskorcak/dev/grache-test
Gemfile located at /Users/tomaskorcak/dev/grache-test/Gemfile
Deleting cache /Users/tomaskorcak/dev/grache-test/vendor
bundle pack --gemfile=/Users/tomaskorcak/dev/grache-test/Gemfile --all
Using ...
Using json 1.8.2
Using gooddata 0.6.13
Using gooddata_connectors_base 0.0.1 from https://github.com/gooddata/gooddata_connectors_base.git (at s3)
Using gooddata_connectors_downloader_salesforce 0.0.1 from https://github.com/gooddata/gooddata_connectors_downloader_salesforce (at gse)
Using gooddata_connectors_metadata 0.0.1 from https://github.com/gooddata/gooddata_connectors_metadata.git (at bds_implementation)
Bundle complete! 4 Gemfile dependencies, 40 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
Updating files in vendor/cache
  * i18n-0.7.0.gem
  * ....
  * gooddata-0.6.13.gem
tomaskorcak@kx-mac:~/dev/grache-test$
```

## References

[Travis CI Bundler Caching](http://docs.travis-ci.com/user/caching/)
