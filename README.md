# grache

Great Ruby Cache for gems

## Status

[![GitHub version](https://badge.fury.io/gh/korczis%2Fgrache.svg)](http://badge.fury.io/gh/korczis%2Fgrache)

## Getting started 

Is simple as typing following command:

```
gem install grache
```

We should get something like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ gem install grache
Successfully installed grache-0.0.12
1 gem installed
tomaskorcak@kx-mac:~/dev/grache-test$
```

### Using with GoodData

* Prepare your Gemfile as usually
* Name your script 'main.rb'
* Copy [wrapper.rb](https://github.com/korczis/grache-test/blob/master/stub.rb) to folder with your 'main.rb' script
* Build and release cache using `grache pack release` command
* Deploy your script, include:
    * Gemfile.Generated
    * Gemfile.Generated.lock
    * wrapper.rb
* Schedule wrapper.rb (instead of main.rb) for execution

## Commands

- [grache help](#grache-help)
- [grache pack](#grache-pack)
- [grache pack build](#grache-pack-build)
- [grache pack zip](#grache-pack-zip)
- [grache pack install](#grache-pack-install)

### grache help

Lets type following:

```
grache help
```

And we should get something like this:

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

Lets type followin:

```
grache pack
```

And we should get sometthing like this: 

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

Lets type following:

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

Lets type following:

```
grache pack zip
```

And we should get sometthing like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache pack zip
Zipping pack: {
  "dir": "."
}
Zipping /Users/tomaskorcak/dev/grache-test
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/activesupport-4.2.0.gem
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata-0.6.13.gem
Deflating ...
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/decimal_spec.rb
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/integer_spec.rb
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/string_spec.rb
Deflating ...
Deflating /Users/tomaskorcak/dev/grache-test/vendor/cache/xml-simple-1.1.4.gem
Created grache-21ca1e50ee980a3a987f52548d5a7f0dd5bc977187eda1d130774827d222925b.zip
```

### grache pack install

Downloads (and unpacks) vendor/cache from S3.

Lets type following:

```
grache pack install
```

And we should get sometthing like this:

```
tomaskorcak@kx-mac:~/dev/grache-test$ grache pack install
Installing pack: {
  "dir": "."
}
Creating /Users/tomaskorcak/dev/grache-test/vendor/
Looking for https://gdc-ms-grache.s3.amazonaws.com/grache-21ca1e50ee980a3a987f52548d5a7f0dd5bc977187eda1d130774827d222925b.zip
Extracting cache/
Extracting cache/activesupport-4.2.0.gem
Extracting cache/gooddata-0.6.13.gem
Extracting ...
Extracting cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/decimal_spec.rb
Extracting cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/integer_spec.rb
Extracting cache/gooddata_connectors_metadata-86f8943cf8f0/spec/unit/types/string_spec.rb
Extracting ...
Extracting cache/xml-simple-1.1.4.gem
Removing old grache-21ca1e50ee980a3a987f52548d5a7f0dd5bc977187eda1d130774827d222925b.zip
tomaskorcak@kx-mac:~/dev/grache-test$
```

### grache pack deploy

Deploys zipped cache to s3.

```
tomaskorcak@kx-mac:~/dev/downloader_projects/ads$ grache pack deploy
Access Key ID? YOUR_ACCESS_KEY_ID
Secret access key? YOUR_SECRET_ACCESS_KEY
tomaskorcak@kx-mac:~/dev/downloader_projects/ads$
```

## References

[Travis CI Bundler Caching](http://docs.travis-ci.com/user/caching/)
