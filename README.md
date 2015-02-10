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

And we should get sometthing like this: 

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

### grache pack zip

Zips vendor/cache for deployment to S3.

Lets type:

```
grache pack zip
```

And we should get sometthing like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache pack zip
/Users/tomaskorcak/.rvm/gems/jruby-1.7.19@global/gems/json_pure-1.8.2/lib/json/common.rb:99 warning: already initialized constant NaN
/Users/tomaskorcak/.rvm/gems/jruby-1.7.19@global/gems/json_pure-1.8.2/lib/json/common.rb:101 warning: already initialized constant Infinity
/Users/tomaskorcak/.rvm/gems/jruby-1.7.19@global/gems/json_pure-1.8.2/lib/json/common.rb:103 warning: already initialized constant MinusInfinity
/Users/tomaskorcak/.rvm/gems/jruby-1.7.19@global/gems/json_pure-1.8.2/lib/json/common.rb:128 warning: already initialized constant UnparserError
Zipping pack: {
  "dir": "."
}
Zipping /Users/tomaskorcak/dev/grache-test
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache
Deflating ...
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata-0.6.13.gem
Deflating ...
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/decimal_spec.rb
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/integer_spec.rb
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/string_spec.rb
Deflating ...
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/xml-simple-1.1.4.gem
Created grache-21ca1e50ee980a3a987f52548d5a7f0dd5bc977187eda1d130774827d222925b.zip
```

## References

[Travis CI Bundler Caching](http://docs.travis-ci.com/user/caching/)
