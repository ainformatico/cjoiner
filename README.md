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
Join css and js assets and create a versioned file.

Author
----------------------------------------
Alejandro El Informático

Usage
----------------------------------------
`cjoiner` will use `pwd` as a primary path and will look for `config.yaml` file if no `config_file` is passed as argument.

`$ cjoiner [config_file]`

### Configuration file
`config.yaml`

* `config`: configuration wrapper
    * `compress`: set compression
    * `yui`: the _yui-compressor_ java file to use if wanted
    * `munge`: short the variable names
    * `charset`: set the charset
    * `debug`: file without compression
    * `debug_suffix`: suffix to `debug` file
    * `common_dependencies`: dependencies array
    * `common_path`: all items common path
    * `common_output`: all items output
    * `file`: asset file, join `common_path`
        * `name`: output name
        * `extension`: output extension
        * `type`: file type, `css` or `js`
        * `major`: major release
        * `minor`: minor release
        * `bugfix`: bugfix number
        * `compilation`: compilation number
        * `compress`: set compresion
        * `dependencies`: custom dependencies array
        * `output`: file output, join `common_output`

Requirements
----------------------------------------
* ruby 1.8
  * rubygems 1.3.7
  * gems
    * sprockets 1.0.2
    * yui-compressor 0.9.6
    * sass 3.1.4

Installation
----------------------------
There is no installation option but if you want to use cjoiner "anywhere" copy it to your binaries path.
