# human-to-gpx

`human-to-gpx` is a Swift command line tool to convert exported data from Human to GPX.

## Installation

1. Clone the repository with submodules

        $ git clone --recursive https://github.com/edc1591/human-to-gpx.git
        # or
        $ git clone https://github.com/edc1591/human-to-gpx.git
        $ git submodule update --init --recursive

2. Install it

        $ xcodebuild install
        $ sudo ditto /tmp/human-to-gpx.dst / # copies the build product into /usr/local/bin
        
## Usage

```
$ human-to-gpx
Usage:
  Specify a Human JSON file: -f <path>
  Specify a Human archive folder to get information about its contents: -d <path>
  Optionally specify an output directory with (otherwise the current directory is used): -o <path>
```

## TODO

* Investigate using `NSXMLDocument` to generate the GPX file.

## License

This project is available under the MIT license.