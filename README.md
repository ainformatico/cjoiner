cjoiner is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

cjoiner is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with cjoiner. If not, see <http://www.gnu.org/licenses/>.

cjoiner
========================================
Join css and js assets and create a versioned file. It also supports compression.

For now `cjoiner` is designed to work with javascript using [sprockets v.1.0.2](https://github.com/sstephenson/sprockets/tree/1.0.2) and css using [sass](http://sass-lang.com/)

Author
----------------------------------------
Alejandro El Informático

Installation
----------------------------

    $ [sudo] gem install cjoiner

Usage
----------------------------------------
### As CLI tool
`cjoiner` will use `pwd` as a primary path and will look for `config.yaml` file if no `config_file` is passed as argument.

    $ cjoiner [config_file]

### As a library

    require 'cjoiner'

Using an object:

    cjoiner = Cjoiner::Joiner.new data
    cjoiner.proccess!

Using the `yaml` file:

    cjoiner = Cjoiner::Joiner.new
    cjoiner.load_config! 'config.yaml'
    cjoiner.proccess!

### Configuration file
This is the skeleton for the configuration file or the data object:

`config.yaml`

* `config`: configuration wrapper
    * `compress`: _{boolean}_ set compression for all files
    * `yui`: _{string}_ the _yui-compressor_ java file to use if wanted
    * `munge`: _{boolean}_ short the variable names for js files
    * `charset`: _{string}_ set the charset
    * `debug`: _{boolean}_ save a file without compression, just all the concatenation
    * `debug_suffix`: _{string}_ suffix for the `debug` file, usually `name.debug.extension`
    * `common_dependencies`: _{array}_ general dependencies array
    * `common_path`: _{string}_ common path for all items
    * `common_output`: _{string}_ common output path for all files
    * `files`: define files
        * `file`: _{string}_ path and name for file (assuming `common_path` as root) to process, ex: `javascripts/all.js`
            * `name`: _{string}_ output name
            * `extension`: _{string}_ output extension
            * `type`: _{string}_ file type, `css` or `js`, this is optional as `cjoiner` can guess by the extension
            * `major`: _{int}_ major release
            * `minor`: _{int}_ minor release
            * `bugfix`: _{int}_ bugfix number
            * `compilation`: _{int}_ compilation number
            * `compress`: _{boolean}_ set compresion for this file, overrides general compression flag
            * `debug`: _{boolean}_ set debug for this file, overrides general debug flag
            * `dependencies`: _{array}_ custom dependencies array for this file
            * `output`: _{string}_ file output assuming `common_output` as root

#### Example

    $ cjoiner project.yaml

    ### project.yaml
    config :
      common_path         : /work/project/
      common_output       : /work/project/output/
      debug               : true
      common_dependencies : [
        javascripts/src/,
        javascripts/src/core/,
        javascripts/src/lib/,
        sass/
      ]
      files:
        javascripts/all.js :
          name         : all
          extension    : js
          major        : 1
          minor        : 0
          bugfix       : 0
          compilation  : 0
          output       : /javascripts/
        sass/css.sass  :
          name         : css
          extension    : css
          major        : 0
          minor        : 0
          bugfix       : 0
          compilation  : 1
          output       : /stylesheets/

    ### all.js (sprockets file)
    //= require "lib.js"
    //= require "debug.js"
    //= require "vendor/plugin.js"

    ### css.sass (sass file)
    @import defines
    @import mixins
    @import general

Will generate two compressed files and two debug files:

1. `/work/project/output/all.1.0.0.0.js`
2. `/work/project/output/all.debug.js`
3. `/work/project/output/css.1.0.0.0.js`
4. `/work/project/output/css.debug.js`

Requirements
----------------------------------------
* ruby 1.8.7, 1.9.3
    * rubygems > 1.3.7
    * gems
        * sprockets 1.0.2
        * yui-compressor > 0.9.6
        * sass > 3.1.4
